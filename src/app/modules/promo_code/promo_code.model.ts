import mongoose, { Schema, Model } from 'mongoose';
import { IPromoCode } from './promo_code.interface';

const PromoCodeSchema = new Schema<IPromoCode>(
  {
    code: {
      type: String,
      required: true,
      unique: true,
    },
    shopOwnerId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'ShopOwner',
    },
    status: {
      type: String,
      enum: ['active', 'inactive'],
      default: 'active',
    },
    branchIds: {
      type: Schema.Types.Mixed, // Can be array of ObjectIds or 'all'
      required: true,
      validate: {
        validator: function (value: any) {
          return Array.isArray(value) || value === 'all';
        },
        message: 'branchIds must be an array of ObjectIds or "all"',
      },
    },
    discountPercent: {
      type: Number,
      default: 0,
      min: 0,
      max: 100,
    },
  },
  {
    timestamps: true,
  }
);

const PromoCode: Model<IPromoCode> = mongoose.model<IPromoCode>('PromoCode', PromoCodeSchema);

export { PromoCode };