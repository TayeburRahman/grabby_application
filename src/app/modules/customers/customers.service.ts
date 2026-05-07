import httpStatus from "http-status";
import ApiError from "../../../errors/ApiError";
import { ICustomer } from "./customers.interface";
import Customer from "./customers.model";
import { Branch } from "../shop_owner/shop_owner.model";
import { Menu } from "../menu/menu.model";
import { MenuCategory } from "../menu_category/menu_category.model";
import { MenuService } from "../menu/menu.service";
import { CustomerStampService } from "../customer_stamps/customer_stamps.service";
import QueryBuilder from "../../../builder/QueryBuilder";
import { EventSubscription } from "../event_offer/event_subscription.model";

const getActiveEventForShopOwner = async (shopOwnerId: string) => {
  if (!shopOwnerId) return null;
  const now = new Date();
  const activeSubscriptions = await EventSubscription.find({
    shopOwnerId,
    isActive: true,
  }).populate({
    path: 'eventOfferId',
    match: {
      isActive: true,
      startDate: { $lte: now },
      endDate: { $gte: now },
    }
  });

  const validSubscription = activeSubscriptions.find((sub: any) => sub.eventOfferId !== null);
  if (!validSubscription) return null;

  const template: any = validSubscription.eventOfferId;
  return {
    discountType: validSubscription.discountType || template.discountType,
    discountValue: validSubscription.discountValue || template.discountValue,
    endDate: template.endDate,
  };
};

const updateProfile = async (
  userId: string,
  payload: Partial<ICustomer>,
  profileImageFile?: any
) => {
  const customer = await Customer.findById(userId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  if (profileImageFile) {
    payload.profile_image = `/images/profile/${profileImageFile.filename}`;
  }

  const updatedCustomer = await Customer.findByIdAndUpdate(userId, payload, {
    new: true,
    runValidators: true,
  }).populate({
    path: "authId",
    select: "role"
  });

  await Customer.findByIdAndUpdate(updatedCustomer?.authId, payload)

  return updatedCustomer;
};

const getMyProfile = async (userId: string) => {
  const customer = await Customer.findById(userId).populate({
    path: "authId",
    select: "role"
  });
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }
  return customer;
};

const deg2rad = (deg: number) => deg * (Math.PI / 180);

const getDistanceInKm = (lat1: number, lon1: number, lat2: number, lon2: number) => {
  const R = 6371; // Radius of the earth in km
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

const formatTimeAMPM = (timeStr: string) => {
  if (!timeStr) return "";
  let [h, m] = timeStr.split(':');
  let hours = parseInt(h);
  const minutes = m ? m.trim().substring(0, 2) : "00";
  if (isNaN(hours)) return timeStr;
  const ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  hours = hours ? hours : 12;
  return `${hours}:${minutes} ${ampm}`;
};

const getBranchStatusAndTiming = (availability: any[]) => {
  const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  const todayName = days[new Date().getDay()];
  const todayAvail = availability?.find((a: any) => a.day === todayName);

  let isOpen = false;
  let statusText = "Closed";
  let timing = "Closed Today";

  if (todayAvail) {
    if (todayAvail.open && todayAvail.close) {
      timing = `Open: ${formatTimeAMPM(todayAvail.open)} - ${formatTimeAMPM(todayAvail.close)}`;
    }

    if (!todayAvail.isClosed) {
      isOpen = true;
      statusText = "Open";
    } else {
      isOpen = false;
      statusText = "Closed";
      timing = "Closed Today";
    }
  }

  const isClosed = todayAvail ? todayAvail.isClosed : true;

  return { isOpen, statusText, timing, isClosed };
};

const processBranchData = (branch: any, lat?: number, lon?: number) => {
  let distanceKm = null;
  let distanceText = "";
  if (lat && lon && branch.lat && branch.lng) {
    distanceKm = getDistanceInKm(lat, lon, branch.lat, branch.lng);
    distanceText = `${distanceKm.toFixed(1)} km`;
  }

  const { isOpen, statusText, timing, isClosed } = getBranchStatusAndTiming(branch.availability);

  return {
    _id: branch._id,
    branch_name: branch.branch_name,
    shop_name: branch.shopOwnerId?.shop_name,
    image: branch.shopOwnerId?.profile_image || branch.shopOwnerId?.shop_logo || null,
    address: branch.address,
    distance: distanceKm,
    distanceText: distanceText || "",
    isOpen,
    statusText,
    timing,
    isClosed,
    tags: ["Car", "Counter"],
    lat: branch.lat,
    lng: branch.lng,
  };
};

/*** Get branches based on customer address (lat, lon) 
 * Sorts branches by proximity to the customer if coordinates are provided 
 */

const getBranchesForCustomer = async (lat?: number, lon?: number, searchTerm?: string) => {
  let filter: any = {};
  if (searchTerm) {
    filter.$or = [
      { branch_name: { $regex: searchTerm, $options: "i" } },
      { address: { $regex: searchTerm, $options: "i" } },
    ];
  }

  const branches = await Branch.find(filter).populate("shopOwnerId", "shop_name shop_logo profile_image");

  const processedBranches = await Promise.all(branches.map(async (branch: any) => {
    const processed: any = processBranchData(branch, lat, lon);
    const activeEvent = await getActiveEventForShopOwner((branch.shopOwnerId as any)?._id?.toString() || (branch.shopOwnerId as any)?.toString());
    if (activeEvent) {
      processed.discount = activeEvent.discountValue;
      processed.discountType = activeEvent.discountType;
      processed.endDate = activeEvent.endDate;
    }
    return processed;
  }));

  if (lat && lon) {
    return processedBranches.sort((a, b) => (a.distance || 0) - (b.distance || 0));
  }

  return processedBranches;
};

const getSingleBranch = async (
  branchId: string,
  lat?: number,
  lon?: number,
  categoryId?: string,
  query: Record<string, unknown> = {},
  customerAuthId?: string
) => {
  const branch = await Branch.findById(branchId).populate("shopOwnerId", "shop_name shop_logo profile_image");
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  const formattedBranch: any = processBranchData(branch, lat, lon);
  const activeEvent = await getActiveEventForShopOwner((branch.shopOwnerId as any)?._id?.toString() || (branch.shopOwnerId as any)?.toString());
  if (activeEvent) {
    formattedBranch.discount = activeEvent.discountValue;
    formattedBranch.discountType = activeEvent.discountType;
    formattedBranch.endDate = activeEvent.endDate;
  }

  const shopOwnerId = (branch.shopOwnerId as any)?._id;

  let meta = null;

  if (shopOwnerId) {
    const categoryFilter: any = { shopOwnerId };
    if (categoryId) {
      categoryFilter._id = categoryId;
    }
    const categories = await MenuCategory.find(categoryFilter);

    const menuFilter: any = { shopOwnerId, isAvailable: true };
    if (categoryId) {
      menuFilter.category = categoryId;
    }

    const menuQuery = new QueryBuilder(Menu.find(menuFilter).populate("category"), query)
      .sort()
      .paginate()
      .fields();

    const rawMenus = await menuQuery.modelQuery;
    meta = await menuQuery.countTotal();

    const menus = await MenuService.attachActiveEvents(rawMenus, shopOwnerId.toString());

    const branchStampData = customerAuthId
      ? await CustomerStampService.getCustomerStampsByBranch(customerAuthId, branchId)
      : { totalStamps: 0 };
    const branchTotalStamps = branchStampData.totalStamps || 0;

    const categoriesWithMenus = categories.map((cat: any) => {
      return {
        _id: cat._id,
        name: cat.name,
        stampActive: cat.stampActive,
        menus: menus
          .filter((m: any) => m.category?._id?.toString() === cat._id.toString())
          .map((menu: any) => {
            const menuObj = menu?.toObject ? menu.toObject() : menu;
            return {
              ...menuObj,
              totalStamps: branchTotalStamps,
              isFree: (menuObj.stamp || 0) > 0 && branchTotalStamps >= (menuObj.stamp || 0),
              remainingStamps: branchTotalStamps - (menuObj.stamp || 0),
            };
          })
      };
    });

    formattedBranch.totalStamps = branchTotalStamps
    // Filter out categories that have no menus (especially important when paginating)
    formattedBranch.menu_categories = categoriesWithMenus.filter(cat => cat.menus.length > 0);
  } else {
    formattedBranch.menu_categories = [];
  }

  return { branch: formattedBranch, meta };
};

const getBranchDetailsBrief = async (branchId: string, lat?: number, lon?: number) => {
  const branch = await Branch.findById(branchId).populate("shopOwnerId", "shop_name shop_logo profile_image");
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  const processed: any = processBranchData(branch, lat, lon);
  const activeEvent = await getActiveEventForShopOwner((branch.shopOwnerId as any)?._id?.toString() || (branch.shopOwnerId as any)?.toString());
  if (activeEvent) {
    processed.discount = activeEvent.discountValue;
    processed.discountType = activeEvent.discountType;
    processed.endDate = activeEvent.endDate;
  }
  return processed;
};

const saveLocation = async (
  userId: string,
  payload: { addressName: string; lat: number; lon: number }
) => {
  const customer = await Customer.findById(userId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  const updatedCustomer = await Customer.findByIdAndUpdate(userId, payload, {
    new: true,
    runValidators: true,
  });

  return updatedCustomer;
};

const convertPoints = async (userId: string, pointsToConvert: number) => {
  if (![500, 1000, 1500, 2000].includes(pointsToConvert)) {
    throw new ApiError(httpStatus.BAD_REQUEST, "Invalid points amount. Must be 500, 1000, 1500, or 2000.");
  }

  const customer = await Customer.findById(userId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  if (customer.pointWallet < pointsToConvert) {
    throw new ApiError(httpStatus.BAD_REQUEST, "Insufficient points in wallet");
  }

  const creditToAdd = pointsToConvert / 100;

  customer.pointWallet -= pointsToConvert;
  customer.credWallet += creditToAdd;

  await customer.save();

  return customer;
};

const getWallet = async (userId: string) => {
  const customer = await Customer.findById(userId).select('pointWallet credWallet');
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }
  return customer;
};

export const CustomerService = {
  updateProfile,
  getMyProfile,
  saveLocation,
  getBranchesForCustomer,
  getSingleBranch,
  getBranchDetailsBrief,
  convertPoints,
  getWallet,
};

