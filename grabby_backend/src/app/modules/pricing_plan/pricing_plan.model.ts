import { Schema, model } from 'mongoose';
import { IPricingPlan, PricingPlanModel } from './pricing_plan.interface';

const pricingPlanSchema = new Schema<IPricingPlan>(
  {
    icon: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    details: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    perDay: {
      type: Number,
      required: true,
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const PricingPlan = model<IPricingPlan, PricingPlanModel>('PricingPlan', pricingPlanSchema);
