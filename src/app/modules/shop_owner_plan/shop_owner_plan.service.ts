import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { PricingPlan } from '../pricing_plan/pricing_plan.model';
import { ShopOwnerPlan } from './shop_owner_plan.model';
import { Branch } from '../shop_owner/shop_owner.model';
import { Menu } from '../menu/menu.model';

const purchasePlan = async (shopOwnerId: string, planId: string) => {
  const plan = await PricingPlan.findById(planId);
  if (!plan) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Pricing plan not found');
  }

  // Deactivate any currently active plan for this shop owner
  await ShopOwnerPlan.updateMany(
    { shopOwnerId, status: 'active' },
    { status: 'expired' } // Or 'cancelled' if overlapping
  );

  const startDate = new Date();
  const endDate = new Date();
  endDate.setDate(startDate.getDate() + plan.perDay);

  const result = await ShopOwnerPlan.create({
    shopOwnerId,
    planId,
    startDate,
    endDate,
    status: 'active',
  });

  return result;
};

const getAdvertisedBranches = async (lat?: number, lon?: number) => {
  const now = new Date();

  // 1. Find all active shop owner plans
  const activePlans = await ShopOwnerPlan.find({
    status: 'active',
    endDate: { $gt: now },
  });

  if (activePlans.length === 0) {
    return [];
  }

  const activeShopOwnerIds = activePlans.map(p => p.shopOwnerId);

  // 2. Find branches belonging to these shop owners
  // We need to pick only 1 branch per shop owner
  const allBranches = await Branch.find({
    shopOwnerId: { $in: activeShopOwnerIds },
  }).populate('shopOwnerId');

  // 3. Group by shop owner and pick one random branch per owner
  const ownerToBranchesMap: Record<string, any[]> = {};
  allBranches.forEach((branch: any) => {
    const ownerId = branch.shopOwnerId._id.toString();
    if (!ownerToBranchesMap[ownerId]) {
      ownerToBranchesMap[ownerId] = [];
    }
    ownerToBranchesMap[ownerId].push(branch);
  });

  let selectedBranches: any[] = [];
  Object.values(ownerToBranchesMap).forEach(branches => {
    // Pick a random branch for this owner
    const randomIndex = Math.floor(Math.random() * branches.length);
    selectedBranches.push(branches[randomIndex]);
  });

  // 4. Sort by distance if lat/lon provided
  if (lat !== undefined && lon !== undefined) {
    selectedBranches.sort((a, b) => {
      const distA = Math.sqrt(Math.pow(a.lat - lat, 2) + Math.pow(a.lng - lon, 2));
      const distB = Math.sqrt(Math.pow(b.lat - lat, 2) + Math.pow(b.lng - lon, 2));
      return distA - distB;
    });
  } else {
    // Randomize order if no location
    selectedBranches = selectedBranches.sort(() => Math.random() - 0.5);
  }

  // 5. Limit to 4 branches and format response
  const finalBranches = selectedBranches.slice(0, 4);

  const result = await Promise.all(finalBranches.map(async (branch: any) => {
    // Fetch top 2 menus for this owner
    const topRatedMenus = await Menu.find({ 
      shopOwnerId: branch.shopOwnerId._id,
      isAvailable: true 
    }).limit(2).sort({ createdAt: -1 }); // Sorting by createdAt as a fallback for "top rated"

    return {
      branchId: branch._id,
      shopOwner: {
        profile_image: branch.shopOwnerId.profile_image,
        name: branch.shopOwnerId.name,
        phone_number: branch.shopOwnerId.phone_number,
      },
      topRatedMenus: topRatedMenus.map((menu: any) => ({
        _id: menu._id,
        itemName: menu.itemName,
        price: menu.price,
        image: menu.image,
        description: menu.description,
      })),
    };
  }));

  return result;
};

export const ShopOwnerPlanService = {
  purchasePlan,
  getAdvertisedBranches,
};
