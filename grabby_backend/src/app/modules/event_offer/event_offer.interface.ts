import { Model, Types } from 'mongoose';

export type IEventOffer = {
  discountName: string;
  eventName: string;
  startDate: Date;
  endDate: Date;
  discountType: 'percentage' | 'fixed';
  discountValue: number;
  isActive: boolean; // Master switch (Admin/Creator can disable the whole event)
  createdBy: 'shop_owner' | 'admin';
  createdByAdminId?: Types.ObjectId;
  shopOwnerId?: Types.ObjectId; // Only if created by a specific shop owner
};

export type IEventSubscription = {
  eventOfferId: Types.ObjectId;
  shopOwnerId: Types.ObjectId;
  isActive: boolean; // Personal shop toggle
  appliedOn: 'all' | 'specific';
  specificItems: Types.ObjectId[];
  discountType?: 'percentage' | 'fixed'; // Override
  discountValue?: number; // Override
};

export type EventOfferModel = Model<IEventOffer>;
export type EventSubscriptionModel = Model<IEventSubscription>;
