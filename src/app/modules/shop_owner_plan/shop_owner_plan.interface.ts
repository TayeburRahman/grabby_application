import { Model, Types } from 'mongoose';

export type IShopOwnerPlan = {
  shopOwnerId: Types.ObjectId;
  planId: Types.ObjectId;
  startDate: Date;
  endDate: Date;
  status: 'active' | 'expired' | 'cancelled';
};

export type ShopOwnerPlanModel = Model<IShopOwnerPlan, Record<string, unknown>>;
