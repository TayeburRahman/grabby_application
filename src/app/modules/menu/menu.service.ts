import mongoose from 'mongoose';
import { IMenu } from './menu.interface';
import { Menu } from './menu.model';
import QueryBuilder from '../../../builder/QueryBuilder';
import { EventSubscription } from '../event_offer/event_subscription.model';
import { Branch } from '../shop_owner/shop_owner.model';
import { MenuCategory } from '../menu_category/menu_category.model';

const attachActiveEvents = async (items: any[], shopOwnerId?: string) => {
  if (!shopOwnerId) {
    return items.map((item) => {
      const itemObj = item.toObject ? item.toObject() : item;
      itemObj.originalPrice = Number(itemObj.price);
      itemObj.price = Number(itemObj.price);
      itemObj.discount = false;
      itemObj.discountParcent = 0;
      return itemObj;
    });
  }

  const now = new Date();
  const plainItems = items.map((item) => (item.toObject ? item.toObject() : item));

  // 1. Find all active subscriptions for this shop owner
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

  // 2. Filter out those where template didn't match (eventOfferId will be null)
  const validSubscriptions = activeSubscriptions.filter((sub: any) => sub.eventOfferId !== null);

  if (validSubscriptions.length === 0) {
    return plainItems.map(itemObj => {
      itemObj.originalPrice = Number(itemObj.price);
      itemObj.price = Number(itemObj.price);
      itemObj.discount = false;
      itemObj.discountParcent = 0;
      return itemObj;
    });
  }

  return plainItems.map(itemObj => {
    // Find a valid subscription that applies to this item
    const applicableSubscription = validSubscriptions.find((sub: any) => {
      if (sub.appliedOn === 'all') return true;
      if (sub.appliedOn === 'specific' && sub.specificItems.some((id: any) => id.toString() === itemObj._id.toString())) {
        return true;
      }
      return false;
    });

    if (applicableSubscription) {
      const template: any = applicableSubscription.eventOfferId;
      const tObj = template.toObject();

      // Check for per-shop overrides
      const finalDiscountType = applicableSubscription.discountType || tObj.discountType;
      const finalDiscountValue = applicableSubscription.discountValue || tObj.discountValue;

      // ── Calculate Discounted Price ──
      const originalPrice = Number(itemObj.price);
      let discountedPrice = originalPrice;
      let discountParcentValue = 0;

      if (finalDiscountType === 'percentage') {
        discountedPrice = originalPrice - (originalPrice * finalDiscountValue) / 100;
        discountParcentValue = finalDiscountValue;
      } else if (finalDiscountType === 'fixed') {
        discountedPrice = originalPrice - finalDiscountValue;
        if (originalPrice > 0) {
          discountParcentValue = Math.round((finalDiscountValue / originalPrice) * 100);
        }
      }

      // Ensure price isn't negative
      discountedPrice = Math.max(0, discountedPrice);

      // Attach the template and the final settings
      itemObj.originalPrice = originalPrice;
      itemObj.price = Number(discountedPrice.toFixed(2));
      itemObj.discount = true;
      itemObj.discountParcent = discountParcentValue;
      itemObj.eventOffer = {
        discountName: tObj.discountName,
        eventName: tObj.eventName,
        endDate: tObj.endDate,
        discountType: finalDiscountType,
        discountValue: finalDiscountValue,
      };
    } else {
      itemObj.originalPrice = Number(itemObj.price);
      itemObj.price = Number(itemObj.price);
      itemObj.discount = false;
      itemObj.discountParcent = 0;
    }

    return itemObj;
  });
};

const create = async (payload: Partial<IMenu>): Promise<IMenu> => {
  if (payload.category) {
    if (payload.stampActive) {
      await MenuCategory.findByIdAndUpdate(payload.category, { stampActive: true });
      await Menu.updateMany(
        { category: payload.category },
        { stampActive: true, stamp: payload.stamp || 10 }
      );
    } else {
      await MenuCategory.findByIdAndUpdate(payload.category, { stampActive: false });
      await Menu.updateMany(
        { category: payload.category },
        { stampActive: false, stamp: 0 }
      );
    }
  }

  const result = await Menu.create(payload);
  return result;
};

const getAll = async (query: Record<string, unknown>, shopOwnerId?: string, categoryId?: string) => {
  const filter: Record<string, unknown> = {};
  if (shopOwnerId && shopOwnerId !== 'all' && mongoose.Types.ObjectId.isValid(shopOwnerId)) {
    filter.shopOwnerId = shopOwnerId;
  }
  if (categoryId && categoryId !== 'all' && mongoose.Types.ObjectId.isValid(categoryId)) {
    filter.category = categoryId;
  }

  // Clean the query object to prevent QueryBuilder from adding incorrect filters
  const cleanQuery = { ...query };
  
  // Fields that are not in the Menu model but might be in the query
  const nonModelFields = ['shop', 'branch'];
  nonModelFields.forEach(field => delete cleanQuery[field]);

  // Fields that might be 'all'
  const allFields = ['category', 'shopOwnerId'];
  allFields.forEach(field => {
    if (cleanQuery[field] === 'all') {
      delete cleanQuery[field];
    }
  });

  const menuQuery = new QueryBuilder(Menu.find(filter), cleanQuery)
    .search(['itemName', 'description'])
    .filter()
    .sort()
    .paginate()
    .fields();

  menuQuery.modelQuery = menuQuery.modelQuery
    .populate('category', 'name')
    .populate('shopOwnerId', 'name shop_name');

  const result = await menuQuery.modelQuery;
  const meta = await menuQuery.countTotal();

  // Get stats for all items matching the current branch/category filter (not just current page)
  const [totalAvailable, totalUnavailable] = await Promise.all([
    Menu.countDocuments({ ...filter, isAvailable: true }),
    Menu.countDocuments({ ...filter, isAvailable: false }),
  ]);

  // Attach active events if shopOwnerId is known (either from filter or items)
  let processedResult = result;
  if (shopOwnerId || result.length > 0) {
    const sId = shopOwnerId || (result[0] as any).shopOwnerId?._id?.toString() || (result[0] as any).shopOwnerId?.toString();
    processedResult = await attachActiveEvents(result, sId);
  }

  return { 
    result: processedResult, 
    meta: {
      ...meta,
      totalAvailable,
      totalUnavailable
    } 
  };
};

const getById = async (id: string) => {
  const result = await Menu.findById(id)
    .populate('category', 'name')
    .populate('shopOwnerId', 'name');

  if (!result) return null;

  const processed = await attachActiveEvents([result], result.shopOwnerId?._id?.toString() || result.shopOwnerId?.toString());
  return processed[0];
};

const getByCategory = async (
  menuCategoryId: string | undefined,
  branchId: string | undefined,
  query: Record<string, unknown>
) => {
  const filter: Record<string, any> = { isAvailable: true };

  if (menuCategoryId && menuCategoryId !== 'all') {
    filter.category = menuCategoryId;
  }

  if (branchId) {
    const branch = await Branch.findById(branchId);
    if (branch) {
      filter.shopOwnerId = branch.shopOwnerId;
    }
  }

  // Clean the query object to prevent QueryBuilder from adding 'all' filters
  const cleanQuery = { ...query };
  if (cleanQuery.menuCategoryId === 'all') delete cleanQuery.menuCategoryId;
  if (cleanQuery.category === 'all') delete cleanQuery.category;

  const menuQuery = new QueryBuilder(Menu.find(filter), cleanQuery)
    .search(['itemName', 'description'])
    .sort()
    .paginate()
    .fields();

  menuQuery.modelQuery = menuQuery.modelQuery.populate('category', 'name').populate('shopOwnerId', 'name');

  const result = await menuQuery.modelQuery;
  const meta = await menuQuery.countTotal();

  // Get stats for all items matching the current branch/category filter (not just current page)
  const [totalAvailable, totalUnavailable] = await Promise.all([
    Menu.countDocuments({ ...filter, isAvailable: true }),
    Menu.countDocuments({ ...filter, isAvailable: false }),
  ]);

  let processedResult = result;
  if (result.length > 0) {
    const sId = (result[0] as any).shopOwnerId?._id?.toString() || (result[0] as any).shopOwnerId?.toString();
    processedResult = await attachActiveEvents(result, sId);
  }

  return { 
    result: processedResult, 
    meta: {
      ...meta,
      totalAvailable,
      totalUnavailable,
    } 
  };
};

const updateById = async (id: string, payload: Partial<IMenu>) => {
  const result = await Menu.findByIdAndUpdate(id, payload, { new: true })
    .populate('category', 'name');
  return result;
};

const deleteById = async (id: string) => {
  const result = await Menu.findByIdAndDelete(id);
  return result;
};

export const MenuService = {
  create,
  getAll,
  getById,
  getByCategory,
  updateById,
  deleteById,
  attachActiveEvents,
};
