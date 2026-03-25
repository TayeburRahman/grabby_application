import { Schema, model } from 'mongoose';
import { IEventOffer, EventOfferModel } from './event_offer.interface';

const eventOfferSchema = new Schema<IEventOffer, EventOfferModel>(
  {
    discountName: { type: String, required: true },
    eventName: { type: String, required: true },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    discountType: {
      type: String,
      enum: ['percentage', 'fixed'],
      default: 'percentage',
    },
    discountValue: { type: Number, required: true },
    isActive: { type: Boolean, default: true }, // Master switch
    createdBy: {
      type: String,
      enum: ['shop_owner', 'admin'],
      required: true,
    },
    createdByAdminId: { type: Schema.Types.ObjectId, ref: 'Admin', required: false },
    shopOwnerId: { type: Schema.Types.ObjectId, ref: 'ShopOwner', required: false },
  },
  { timestamps: true }
);

export const EventOffer = model<IEventOffer, EventOfferModel>('EventOffer', eventOfferSchema);
