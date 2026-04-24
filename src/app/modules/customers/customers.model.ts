import mongoose, { Schema, Model } from "mongoose";
import { ICustomer } from "./customers.interface";

const CustomerSchema = new Schema<ICustomer>(
  {
    authId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Auth",
    },
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    phone_number: {
      type: String,
      required: true,
    },
    profile_image: {
      type: String,
      default: null,
    },
    status: {
      type: String,
      enum: ["active", "deactivate"],
      default: "active",
    },
    addressName: {
      type: String,
      default: null,
    },
    lat: {
      type: Number,
      default: null,
    },
    lon: {
      type: Number,
      default: null,
    },
    pointWallet: {
      type: Number,
      default: 0,
    },
    credWallet: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

const Customer: Model<ICustomer> = mongoose.model<ICustomer>("Customer", CustomerSchema);

export default Customer;
