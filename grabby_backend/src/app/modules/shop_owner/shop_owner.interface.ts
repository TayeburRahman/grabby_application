import mongoose, { Document } from "mongoose";

export type IDayHours = {
  day: string;
  open?: string;
  close?: string;
  isClosed: boolean;
};

export type IBranch = Document & {
  _id: mongoose.Schema.Types.ObjectId;
  shopOwnerId: mongoose.Schema.Types.ObjectId;
  branch_name: string;
  address: string;
  lat: number;
  lng: number;
  phone_number: string;
  availability: IDayHours[];
  applyMenuForAll: boolean;
  createdAt?: Date;
  updatedAt?: Date;
};

export type IShopOwner = Document & {
  _id: mongoose.Schema.Types.ObjectId;
  authId: mongoose.Schema.Types.ObjectId;
  name: string;
  email: string;
  phone_number: string;
  profile_image?: string | null;

  // Location (Screen 3)
  location?: {
    address: string;
    lat: number;
    lng: number;
  };

  // Business Info (Screen 4)
  shop_name?: string;
  shop_license_number?: string;
  contact_email?: string;
  contact_phone?: string;

  // Documents (Screen 6)
  business_license?: string | null;
  shop_logo?: string | null;

  // Registration status
  registration_step: number;
  approval_status: "pending" | "approved" | "rejected";

  status: "active" | "deactivate";
  isRewardPointEnabled?: boolean;

  // Stripe Connect & Bank Account
  stripeAccountId?: string | null;
  stripeAccountConnected?: boolean;
  stripeAccountStatus?: string;
  bankDetails?: {
    bankName?: string;
    routingNumber?: string;
    accountNumberLast4?: string;
    accountHolderName?: string;
    currency?: string;
  } | null;

  createdAt?: Date;
  updatedAt?: Date;
};

