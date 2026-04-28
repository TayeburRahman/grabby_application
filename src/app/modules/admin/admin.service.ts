import httpStatus from "http-status";
import ApiError from "../../../errors/ApiError";
import { paginationHelpers } from "../../../helpers/paginationHelper";
import { IOptions } from "../../../interfaces/paginations";
import { ShopOwner } from "../shop_owner/shop_owner.model";
import Auth from "../auth/auth.model";
import Admin from "./admin.model";
import Customer from "../customers/customers.model";
import { ENUM_USER_ROLE } from "../../../enums/user";

// ─── GET SHOP OWNER REQUESTS (pending approval) ────────────────────
const getShopOwnerRequests = async (
  query: { searchTerm?: string; approval_status?: string },
  paginationOptions: IOptions
) => {
  const { page, limit, skip, sortBy, sortOrder } =
    paginationHelpers.calculatePagination(paginationOptions);

  const conditions: Record<string, any> = {};

  if (query.approval_status && query.approval_status !== "all") {
    conditions.approval_status = query.approval_status;
  } else if (!query.approval_status) {
    conditions.approval_status = "pending";
  }

  if (query.searchTerm) {
    const regex = new RegExp(query.searchTerm, "i");
    conditions.$or = [
      { name: regex },
      { email: regex },
      { phone_number: regex },
      { shop_name: regex },
    ];
  }

  const [data, total] = await Promise.all([
    ShopOwner.find(conditions)
      .populate("authId", "name email phone_number is_block isActive role")
      .sort({ [sortBy]: sortOrder })
      .skip(skip)
      .limit(limit)
      .lean(),
    ShopOwner.countDocuments(conditions),
  ]);

  return {
    meta: { page, limit, total },
    data,
  };
};

// ─── ACCEPT SHOP OWNER ─────────────────────────────────────────────
const acceptShopOwner = async (payload: { id: string }) => {
  const shopOwner = await ShopOwner.findById(payload.id);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  if (shopOwner.approval_status === "approved") {
    throw new ApiError(httpStatus.BAD_REQUEST, "Shop owner is already approved");
  }

  shopOwner.approval_status = "approved";
  shopOwner.status = "active";
  await shopOwner.save();

  return shopOwner;
};

// ─── BLOCK SHOP OWNER ──────────────────────────────────────────────
const blockedShopOwner = async (payload: { id: string }) => {
  const shopOwner = await ShopOwner.findById(payload.id);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  // Toggle block status on Auth
  const auth = await Auth.findById(shopOwner.authId);
  if (!auth) {
    throw new ApiError(httpStatus.NOT_FOUND, "Auth record not found");
  }

  auth.is_block = !auth.is_block;
  await auth.save();

  // Update shop owner status accordingly
  shopOwner.status = auth.is_block ? "deactivate" : "active";
  await shopOwner.save();

  return auth;
};

// ─── REJECT SHOP OWNER ─────────────────────────────────────────────
const rejectShopOwner = async (payload: { id: string }) => {
  const shopOwner = await ShopOwner.findById(payload.id);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  shopOwner.approval_status = "rejected";
  shopOwner.status = "deactivate";
  await shopOwner.save();

  return shopOwner;
};

// ─── UPDATE SHOP OWNER DETAILS ─────────────────────────────────────
const updateShopOwnerDetails = async (
  id: string,
  payload: Record<string, any>
) => {
  const shopOwner = await ShopOwner.findById(id);
  if (!shopOwner) {
    throw new ApiError(httpStatus.NOT_FOUND, "Shop owner not found");
  }

  const updatedShopOwner = await ShopOwner.findByIdAndUpdate(id, payload, {
    new: true,
    runValidators: true,
  }).populate("authId", "name email phone_number is_block isActive role");

  return updatedShopOwner;
};

// ─── CREATE ADMIN (Only Super Admin) ────────────────────────────────
const createAdmin = async (payload: {
  name: string;
  email: string;
  phone_number: string;
  password: string;
}) => {
  const existingAuth = await Auth.findOne({ email: payload.email });
  if (existingAuth) {
    throw new ApiError(httpStatus.BAD_REQUEST, "Email already exists");
  }

  const authData = await Auth.create({
    name: payload.name,
    email: payload.email,
    phone_number: payload.phone_number,
    password: payload.password,
    role: ENUM_USER_ROLE.ADMIN,
    isActive: true,
    termsAccepted: true,
  });

  const admin = await Admin.create({
    authId: authData._id,
    name: payload.name,
    email: payload.email,
    phone_number: payload.phone_number,
  });

  return admin;
};

// ─── UPDATE ADMIN PROFILE ───────────────────────────────────────────
const updateAdminProfile = async (
  adminId: string,
  payload: { name?: string; email?: string; phone_number?: string; profile_image?: string }
) => {
  const admin = await Admin.findById(adminId);
  if (!admin) {
    throw new ApiError(httpStatus.NOT_FOUND, "Admin not found");
  }

  // Update Admin profile
  const updatedAdmin = await Admin.findByIdAndUpdate(adminId, payload, {
    new: true,
    runValidators: true,
  }).populate("authId", "name email phone_number is_block isActive role");

  // Sync name/email/phone on Auth record
  const authUpdate: Record<string, any> = {};
  if (payload.name) authUpdate.name = payload.name;
  if (payload.email) authUpdate.email = payload.email;
  if (payload.phone_number) authUpdate.phone_number = payload.phone_number;

  if (Object.keys(authUpdate).length > 0) {
    await Auth.findByIdAndUpdate(admin.authId, authUpdate);
  }

  return updatedAdmin;
};

// ─── DELETE ADMIN ───────────────────────────────────────────────────
const deleteAdmin = async (adminId: string) => {
  const admin = await Admin.findById(adminId);
  if (!admin) {
    throw new ApiError(httpStatus.NOT_FOUND, "Admin not found");
  }

  // Prevent deleting a Super Admin
  const auth = await Auth.findById(admin.authId);
  if (auth?.role === ENUM_USER_ROLE.SUPER_ADMIN) {
    throw new ApiError(httpStatus.FORBIDDEN, "Cannot delete a Super Admin");
  }

  await Promise.all([
    Admin.findByIdAndDelete(adminId),
    Auth.findByIdAndDelete(admin.authId),
  ]);

  return { message: "Admin deleted successfully" };
};

// ─── GET ALL CUSTOMERS (Paginated + Search) ────────────────────────
const getAllCustomers = async (
  query: { searchTerm?: string; status?: string },
  paginationOptions: IOptions
) => {
  const { page, limit, skip, sortBy, sortOrder } =
    paginationHelpers.calculatePagination(paginationOptions);

  const conditions: Record<string, any> = {};

  if (query.status) {
    conditions.status = query.status;
  }

  if (query.searchTerm) {
    const regex = new RegExp(query.searchTerm, "i");
    conditions.$or = [
      { name: regex },
      { email: regex },
      { phone_number: regex },
    ];
  }

  const [data, total] = await Promise.all([
    Customer.find(conditions)
      .populate("authId", "name email phone_number is_block isActive role")
      .sort({ [sortBy]: sortOrder })
      .skip(skip)
      .limit(limit)
      .lean(),
    Customer.countDocuments(conditions),
  ]);

  return {
    meta: { page, limit, total },
    data,
  };
  
};

// ─── BLOCK/UNBLOCK CUSTOMER ────────────────────────────────────────
const blockedCustomer = async (payload: { id: string }) => {
  const customer = await Customer.findById(payload.id);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  const auth = await Auth.findById(customer.authId);
  if (!auth) {
    throw new ApiError(httpStatus.NOT_FOUND, "Auth record not found");
  }

  auth.is_block = !auth.is_block;
  await auth.save();

  customer.status = auth.is_block ? "deactivate" : "active";
  await customer.save();

  return {
    ...customer.toObject(),
    is_block: auth.is_block,
  };
};

// ─── CUSTOMER DETAILS BY ID ────────────────────────────────────────
const getCustomerDetails = async (customerId: string) => {
  const customer = await Customer.findById(customerId)
    .populate("authId", "name email phone_number is_block isActive role createdAt")
    .lean();

  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  return customer;
};

// ─── CUSTOMER OVERVIEW ─────────────────────────────────────────────
const getCustomerOverview = async () => {
  const [totalCustomers, activeCustomers] = await Promise.all([
    Customer.countDocuments(),
    Customer.countDocuments({ status: "active" }),
  ]);

  // Average orders per customer (placeholder: no Order model yet)
  const averageOrder = 0;

  return {
    totalCustomers,
    activeCustomers,
    averageOrder,
  };
};

// ─── GET ALL ADMINS (Only Super Admin) ──────────────────────────────
const getAllAdmins = async (
  paginationOptions: IOptions
) => {
  const { page, limit, skip, sortBy, sortOrder } =
    paginationHelpers.calculatePagination(paginationOptions);

  const [data, total] = await Promise.all([
    Admin.find()
      .populate("authId", "name email phone_number is_block isActive role createdAt")
      .sort({ [sortBy]: sortOrder })
      .skip(skip)
      .limit(limit)
      .lean(),
    Admin.countDocuments(),
  ]);

  return {
    meta: { page, limit, total },
    data,
  };
};

export const AdminService = {
  getShopOwnerRequests,
  acceptShopOwner,
  rejectShopOwner,
  blockedShopOwner,
  updateShopOwnerDetails,
  createAdmin,
  updateAdminProfile,
  deleteAdmin,
  getAllCustomers,
  blockedCustomer,
  getCustomerDetails,
  getCustomerOverview,
  getAllAdmins,
};
