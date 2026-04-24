import httpStatus from "http-status";
import ApiError from "../../../errors/ApiError";
import { ShopOwner, Branch } from "./shop_owner.model";

// Default UAE working hours (Sun–Thu: full day, Fri: after Jumu'ah prayer, Sat: regular)
const DEFAULT_UAE_AVAILABILITY = [
  { day: "Sunday", open: "7:00 AM", close: "11:00 PM", isClosed: false },
  { day: "Monday", open: "7:00 AM", close: "11:00 PM", isClosed: false },
  { day: "Tuesday", open: "7:00 AM", close: "11:00 PM", isClosed: false },
  { day: "Wednesday", open: "7:00 AM", close: "11:00 PM", isClosed: false },
  { day: "Thursday", open: "7:00 AM", close: "12:00 AM", isClosed: false },
  { day: "Friday", open: "2:00 PM", close: "12:00 AM", isClosed: false },
  { day: "Saturday", open: "8:00 AM", close: "11:00 PM", isClosed: false },
];

// ─── Screen 3: Save Location ────────────────────────────────────────
const saveLocation = async (
  userId: string,
  payload: { address: string; lat: number; lng: number }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  shopOwner.location = {
    address: payload.address,
    lat: payload.lat,
    lng: payload.lng,
  };
  shopOwner.registration_step = Math.max(shopOwner.registration_step, 3);
  await shopOwner.save();

  return shopOwner;
};

// ─── Screen 4: Save Business Info ───────────────────────────────────
const saveBusinessInfo = async (
  userId: string,
  payload: {
    shop_name: string;
    shop_license_number: string;
    contact_email: string;
    contact_phone: string;
  }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  shopOwner.shop_name = payload.shop_name;
  shopOwner.shop_license_number = payload.shop_license_number;
  shopOwner.contact_email = payload.contact_email;
  shopOwner.contact_phone = payload.contact_phone;
  shopOwner.registration_step = Math.max(shopOwner.registration_step, 4);
  await shopOwner.save();

  return shopOwner;
};

// ─── Screen 5: Save Branches ────────────────────────────────────────
const saveBranches = async (
  userId: string,
  payload: {
    branches: Array<{
      branch_name: string;
      address: string;
      lat: number;
      lng: number;
      phone_number: string;
      availability?: Array<{
        day: string;
        open: string;
        close: string;
        isClosed: boolean;
      }>;
      applyMenuForAll: boolean;
    }>;
  }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  // Remove old branches for this shop owner before saving new ones
  await Branch.deleteMany({ shopOwnerId: shopOwner._id });

  const branchDocs = payload.branches.map((b) => ({
    shopOwnerId: shopOwner._id,
    ...b,
    availability: b.availability && b.availability.length > 0
      ? b.availability
      : DEFAULT_UAE_AVAILABILITY,
  }));

  const createdBranches = await Branch.insertMany(branchDocs);

  shopOwner.registration_step = Math.max(shopOwner.registration_step, 5);
  await shopOwner.save();

  return createdBranches;
};

// ─── Screen 6: Upload Documents ─────────────────────────────────────
const saveDocuments = async (
  userId: string,
  files: { [key: string]: Express.Multer.File[] }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  if (files.business_license && files.business_license[0]) {
    shopOwner.business_license = `/images/documents/${files.business_license[0].filename}`;
  }
  if (files.shop_logo && files.shop_logo[0]) {
    shopOwner.shop_logo = `/images/logos/${files.shop_logo[0].filename}`;
  }

  shopOwner.registration_step = 6;
  shopOwner.approval_status = "pending";
  await shopOwner.save();

  return shopOwner;
};

// ─── Update Profile ────────────────────────────────────────────────
const updateProfile = async (
  userId: string,
  payload: Record<string, any>,
  profileImageFile?: Express.Multer.File
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  if (profileImageFile) {
    payload.profile_image = `/images/profile/${profileImageFile.filename}`;
  }

  const updatedShopOwner = await ShopOwner.findByIdAndUpdate(userId, payload, {
    new: true,
    runValidators: true,
  }).populate("authId", "name email phone_number is_block isActive role");

  return updatedShopOwner;
};

// ─── Create Branch ─────────────────────────────────────────────────
const createBranch = async (
  userId: string,
  payload: {
    branch_name: string;
    address: string;
    lat: number;
    lng: number;
    phone_number: string;
    availability?: Array<{
      day: string;
      open: string;
      close: string;
      isClosed: boolean;
    }>;
    applyMenuForAll: boolean;
  }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branchData = {
    shopOwnerId: shopOwner._id,
    ...payload,
    availability:
      payload.availability && payload.availability.length > 0
        ? payload.availability
        : DEFAULT_UAE_AVAILABILITY,
  };

  const branch = await Branch.create(branchData);
  return branch;
};

// ─── Delete Branch ─────────────────────────────────────────────────
const deleteBranch = async (userId: string, branchId: string) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branch = await Branch.findOne({
    _id: branchId,
    shopOwnerId: shopOwner._id,
  });
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  await Branch.findByIdAndDelete(branchId);
  return { message: "Branch deleted successfully" };
};

// ─── Update Branch Data ────────────────────────────────────────────
const updateBranch = async (
  userId: string,
  branchId: string,
  payload: Record<string, any>
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branch = await Branch.findOne({
    _id: branchId,
    shopOwnerId: shopOwner._id,
  });
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  const updatedBranch = await Branch.findByIdAndUpdate(branchId, payload, {
    new: true,
    runValidators: true,
  });

  return updatedBranch;
};

// ─── Update Branch Availability ────────────────────────────────────
const updateBranchAvailability = async (
  userId: string,
  branchId: string,
  payload: {
    availability: Array<{
      day: string;
      open: string;
      close: string;
      isClosed: boolean;
    }>;
  }
) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branch = await Branch.findOne({
    _id: branchId,
    shopOwnerId: shopOwner._id,
  });
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  branch.availability = payload.availability;
  await branch.save();

  return branch;
};

const getAllBranches = async (userId: string) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branches = await Branch.find({ shopOwnerId: shopOwner._id });
  return branches;
};

const getBranchDetails = async (userId: string, branchId: string) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const branch = await Branch.findOne({
    _id: branchId,
    shopOwnerId: shopOwner._id,
  });
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  return branch;
};

// ─── Toggle Reward Points ──────────────────────────────────────────
const toggleRewardPoints = async (userId: string) => {
  const shopOwner = await ShopOwner.findById(userId);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  shopOwner.isRewardPointEnabled = !shopOwner.isRewardPointEnabled;
  await shopOwner.save();

  return shopOwner;
};

export const ShopOwnerService = {
  saveLocation,
  saveBusinessInfo,
  saveBranches,
  saveDocuments,
  updateProfile,
  createBranch,
  deleteBranch,
  updateBranch,
  updateBranchAvailability,
  getAllBranches,
  getBranchDetails,
  toggleRewardPoints,
};
