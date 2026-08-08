import { Types } from "mongoose";

export interface ICustomerStamp {
  customer: Types.ObjectId;
  branch: Types.ObjectId;
  totalStamps: number;
}
