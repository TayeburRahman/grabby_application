import { Types } from 'mongoose';

export interface IPromoCode {
  _id?: Types.ObjectId;
  code: string;
  shopOwnerId: Types.ObjectId;
  status: 'active' | 'inactive';
  branchIds: Types.ObjectId[] | 'all';
  discountPercent?: number;
  createdAt?: Date;
  updatedAt?: Date;
}