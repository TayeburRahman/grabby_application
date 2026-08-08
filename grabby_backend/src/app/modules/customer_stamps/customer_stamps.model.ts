import mongoose, { Schema, Model } from "mongoose";
import { ICustomerStamp } from "./customer_stamps.interface";

const CustomerStampSchema = new Schema<ICustomerStamp>(
  {
    customer: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Customer",
    },
    branch: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Branch",
    },
    totalStamps: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

const CustomerStamp: Model<ICustomerStamp> = mongoose.model<ICustomerStamp>("CustomerStamp", CustomerStampSchema);

export default CustomerStamp;
