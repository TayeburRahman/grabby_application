import { Types } from 'mongoose';
import { IEventOffer, IEventSubscription } from './event_offer.interface';
import { EventOffer } from './event_offer.model';
import { EventSubscription } from './event_subscription.model';
import QueryBuilder from '../../../builder/QueryBuilder';

const create = async (payload: any): Promise<IEventOffer> => {
  const result = await EventOffer.create(payload);

  // If a shop owner creates it personally, auto-subscribe them to it
  if (result.createdBy === 'shop_owner' && result.shopOwnerId) {
    // If activating new, deactivate all other subscriptions for this shop
    if (payload.isActive === true) {
      await EventSubscription.updateMany(
        { shopOwnerId: result.shopOwnerId },
        { $set: { isActive: false } }
      );
    }

    await EventSubscription.create({
      eventOfferId: result._id,
      shopOwnerId: result.shopOwnerId,
      isActive: payload.isActive === undefined ? true : payload.isActive,
      appliedOn: payload.appliedOn || 'all',
      specificItems: payload.specificItems || [],
    });
  }

  return result;
};

const checkAndDeactivateExpired = async (filter: Record<string, any> = {}) => {
  const now = new Date();
  await EventOffer.updateMany(
    {
      ...filter,
      isActive: true,
      endDate: { $lt: now },
    },
    { $set: { isActive: false } }
  );
};

// Shop Owner: get own events + admin-created events WITH their personal subscription state
const getAllForShopOwner = async (query: Record<string, unknown>, shopOwnerId: string) => {
  await checkAndDeactivateExpired();

  // 1. Get all templates (Admin + Own)
  const eventQuery = new QueryBuilder(
    EventOffer.find({
      $or: [
        { shopOwnerId, createdBy: 'shop_owner' },
        { createdBy: 'admin' },
      ],
    }),
    query
  )
    .search(['discountName', 'eventName'])
    .filter()
    .sort()
    .paginate()
    .fields();

  eventQuery.modelQuery = eventQuery.modelQuery
    .populate('shopOwnerId', 'name')
    .populate('createdByAdminId', 'name');

  const events = await eventQuery.modelQuery;
  const meta = await eventQuery.countTotal();

  // 2. Fetch or attach the shop's personal subscription status for each event
  const result = await Promise.all(
    events.map(async (event) => {
      const subscription = await EventSubscription.findOne({
        eventOfferId: event._id,
        shopOwnerId: new Types.ObjectId(shopOwnerId),
      }).populate('specificItems', 'itemName price');

      return {
        ...event.toObject(),
        subscription: subscription || null, // Shows per-shop settings
      };
    })
  );

  return { result, meta };
};

const getAllForAdmin = async (query: Record<string, unknown>) => {
  await checkAndDeactivateExpired();

  const eventQuery = new QueryBuilder(EventOffer.find(), query)
    .search(['discountName', 'eventName'])
    .filter()
    .sort()
    .paginate()
    .fields();

  eventQuery.modelQuery = eventQuery.modelQuery
    .populate('shopOwnerId', 'name')
    .populate('createdByAdminId', 'name');

  const result = await eventQuery.modelQuery;
  const meta = await eventQuery.countTotal();

  return { result, meta };
};

const getById = async (id: string) => {
  const event = await EventOffer.findById(id);
  if (event && event.isActive && event.endDate < new Date()) {
    event.isActive = false;
    await event.save();
  }
  return await EventOffer.findById(id).populate('shopOwnerId', 'name');
};

const updateById = async (id: string, payload: Partial<IEventOffer>) => {
  console.log(payload);
  return await EventOffer.findByIdAndUpdate(id, payload, { new: true });
};

// ──── New Methodology for Subscription Toggling ────
const upsertSubscription = async (
  shopOwnerId: string,
  eventOfferId: string,
  payload: Partial<IEventSubscription>
) => {
  // 1. Fetch current subscription to see if it already exists
  const existingSub = await EventSubscription.findOne({ shopOwnerId, eventOfferId });

  // 2. If activation is being requested, we need a target scope (all or specific)
  if (payload.isActive === true) {
    const targetAppliedOn = payload.appliedOn || existingSub?.appliedOn;
    const targetSpecificItems = payload.specificItems || existingSub?.specificItems;

    if (!targetAppliedOn) {
      throw new Error("You must specify 'appliedOn' (all or specific) when activating an event for the first time.");
    }
    if (targetAppliedOn === 'specific' && (!targetSpecificItems || targetSpecificItems.length === 0)) {
      throw new Error("You must include 'specificItems' when activating for specific items.");
    }

    // Deactivate all other active events for this shop owner
    await EventSubscription.updateMany(
      { shopOwnerId: new Types.ObjectId(shopOwnerId), eventOfferId: { $ne: new Types.ObjectId(eventOfferId) } },
      { $set: { isActive: false } }
    );
  }

  const result = await EventSubscription.findOneAndUpdate(
    { shopOwnerId, eventOfferId },
    { $set: payload },
    { upsert: true, new: true, runValidators: true }
  ).populate('specificItems', 'itemName price');

  return result;
};

const deleteById = async (id: string) => {
  await EventSubscription.deleteMany({ eventOfferId: id });
  return await EventOffer.findByIdAndDelete(id);
};

export const EventOfferService = {
  create,
  getAllForShopOwner,
  getAllForAdmin,
  getById,
  updateById,
  upsertSubscription,
  deleteById,
};
