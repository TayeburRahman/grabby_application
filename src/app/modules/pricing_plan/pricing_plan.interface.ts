import { Model } from 'mongoose';

export type IPricingPlan = {
  icon: string;
  name: string;
  details: string;
  price: number;
  perDay: number;
};

export type PricingPlanModel = Model<IPricingPlan, Record<string, unknown>>;
