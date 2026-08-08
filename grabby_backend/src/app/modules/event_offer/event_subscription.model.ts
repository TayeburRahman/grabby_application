import { Schema, model } from 'mongoose';
import { IEventSubscription, EventSubscriptionModel } from './event_offer.interface';

const eventSubscriptionSchema = new Schema<IEventSubscription, EventSubscriptionModel>(
  {
    eventOfferId: { type: Schema.Types.ObjectId, ref: 'EventOffer', required: true },
    shopOwnerId: { type: Schema.Types.ObjectId, ref: 'ShopOwner', required: true },
    isActive: { type: Boolean, default: false },
    appliedOn: {
      type: String,
      enum: ['all', 'specific'],
      default: 'all',
    },
    specificItems: [
      { type: Schema.Types.ObjectId, ref: 'Menu' },
    ],
    discountType: {
      type: String,
      enum: ['percentage', 'fixed'],
    },
    discountValue: { type: Number },
  },
  { timestamps: true }
);

export const EventSubscription = model<IEventSubscription, EventSubscriptionModel>('EventSubscription', eventSubscriptionSchema);
