import { Schema, model } from 'mongoose';
import { IShopOwnerPlan, ShopOwnerPlanModel } from './shop_owner_plan.interface';

const shopOwnerPlanSchema = new Schema<IShopOwnerPlan>(
  {
    shopOwnerId: {
      type: Schema.Types.ObjectId,
      ref: 'ShopOwner',
      required: true,
    },
    planId: {
      type: Schema.Types.ObjectId,
      ref: 'PricingPlan',
      required: true,
    },
    startDate: {
      type: Date,
      required: true,
    },
    endDate: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: ['active', 'expired', 'cancelled'],
      default: 'active',
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const ShopOwnerPlan = model<IShopOwnerPlan, ShopOwnerPlanModel>(
  'ShopOwnerPlan',
  shopOwnerPlanSchema
);
