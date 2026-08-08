import mongoose, { Schema, Model } from "mongoose";
import { IShopOwner, IBranch } from "./shop_owner.interface";

const ShopOwnerSchema = new Schema<IShopOwner>(
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

    // Location (Screen 3)
    location: {
      address: { type: String },
      lat: { type: Number },
      lng: { type: Number },
    },

    // Business Info (Screen 4)
    shop_name: { type: String },
    shop_license_number: { type: String },
    contact_email: { type: String },
    contact_phone: { type: String },

    // Documents (Screen 6)
    business_license: { type: String, default: null },
    shop_logo: { type: String, default: null },

    // Registration tracking
    registration_step: {
      type: Number,
      default: 2, // After OTP verified, step 2 done -> next is 3
    },
    approval_status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
    status: {
      type: String,
      enum: ["active", "deactivate"],
      default: "active",
    },
    isRewardPointEnabled: {
      type: Boolean,
      default: true,
    },

    // Stripe Connect & Bank Account
    stripeAccountId: { type: String, default: null },
    stripeAccountConnected: { type: Boolean, default: false },
    stripeAccountStatus: { type: String, default: "unlinked" },
    bankDetails: {
      bankName: { type: String, default: "" },
      routingNumber: { type: String, default: "" },
      accountNumberLast4: { type: String, default: "" },
      accountHolderName: { type: String, default: "" },
      currency: { type: String, default: "aed" },
    },
  },
  {
    timestamps: true,
  }
);

const DayHoursSchema = new Schema(
  {
    day: { type: String, required: true },
    open: { type: String },
    close: { type: String },
    isClosed: { type: Boolean, default: false },
  },
  { _id: false }
);

const BranchSchema = new Schema<IBranch>(
  {
    shopOwnerId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "ShopOwner",
    },
    branch_name: {
      type: String,
      required: true,
    },
    address: {
      type: String,
      required: true,
    },
    lat: {
      type: Number,
      required: true,
    },
    lng: {
      type: Number,
      required: true,
    },
    phone_number: {
      type: String,
      required: true,
    },
    availability: {
      type: [DayHoursSchema],
      default: [],
    },
    applyMenuForAll: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

const ShopOwner: Model<IShopOwner> = mongoose.model<IShopOwner>("ShopOwner", ShopOwnerSchema);
const Branch: Model<IBranch> = mongoose.model<IBranch>("Branch", BranchSchema);

export { ShopOwner, Branch };
