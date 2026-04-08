import { IMenu } from './menu.interface';
import { Menu } from './menu.model';
import QueryBuilder from '../../../builder/QueryBuilder';
import { EventSubscription } from '../event_offer/event_subscription.model';

const attachActiveEvents = async (items: any[], shopOwnerId?: string) => {
  if (!shopOwnerId) return items;
  const now = new Date();

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

  if (validSubscriptions.length === 0) return items;

  return items.map(item => {
    const itemObj = item.toObject ? item.toObject() : item;

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

      if (finalDiscountType === 'percentage') {
        discountedPrice = originalPrice - (originalPrice * finalDiscountValue) / 100;
      } else if (finalDiscountType === 'fixed') {
        discountedPrice = originalPrice - finalDiscountValue;
      }

      // Ensure price isn't negative
      discountedPrice = Math.max(0, discountedPrice);

      // Attach the template and the final settings
      itemObj.originalPrice = originalPrice;
      itemObj.price = Number(discountedPrice.toFixed(2));
      itemObj.eventOffer = {
        discountName: tObj.discountName,
        eventName: tObj.eventName,
        endDate: tObj.endDate,
        discountType: finalDiscountType,
        discountValue: finalDiscountValue,
      };
    }

    return itemObj;
  });
};

const create = async (payload: Partial<IMenu>): Promise<IMenu> => {
  const result = await Menu.create(payload);
  return result;
};

const getAll = async (query: Record<string, unknown>, shopOwnerId?: string, categoryId?: string) => {
  const filter: Record<string, unknown> = {};
  if (shopOwnerId) {
    filter.shopOwnerId = shopOwnerId;
  }
  if (categoryId) {
    filter.category = categoryId;
  }

  const menuQuery = new QueryBuilder(Menu.find(filter), query)
    .search(['itemName', 'description'])
    .filter()
    .sort()
    .paginate()
    .fields();

  menuQuery.modelQuery = menuQuery.modelQuery
    .populate('category', 'name')
    .populate('shopOwnerId', 'name');

  const result = await menuQuery.modelQuery;
  const meta = await menuQuery.countTotal();

  // Attach active events if shopOwnerId is known (either from filter or items)
  let processedResult = result;
  if (shopOwnerId || result.length > 0) {
    const sId = shopOwnerId || (result[0] as any).shopOwnerId?._id?.toString() || (result[0] as any).shopOwnerId?.toString();
    processedResult = await attachActiveEvents(result, sId);
  }

  return { result: processedResult, meta };
};

const getById = async (id: string) => {
  const result = await Menu.findById(id)
    .populate('category', 'name')
    .populate('shopOwnerId', 'name');

  if (!result) return null;

  const processed = await attachActiveEvents([result], result.shopOwnerId?._id?.toString() || result.shopOwnerId?.toString());
  return processed[0];
};

const getByCategory = async (categoryId: string, query: Record<string, unknown>) => {
  const menuQuery = new QueryBuilder(Menu.find({ category: categoryId, isAvailable: true }), query)
    .search(['itemName', 'description'])
    .sort()
    .paginate()
    .fields();

  menuQuery.modelQuery = menuQuery.modelQuery.populate('category', 'name').populate('shopOwnerId', 'name');

  const result = await menuQuery.modelQuery;
  const meta = await menuQuery.countTotal();

  let processedResult = result;
  if (result.length > 0) {
    const sId = (result[0] as any).shopOwnerId?._id?.toString() || (result[0] as any).shopOwnerId?.toString();
    processedResult = await attachActiveEvents(result, sId);
  }

  return { result: processedResult, meta };
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
};
