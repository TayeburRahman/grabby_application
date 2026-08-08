import { z } from "zod";

const acceptShopOwner = z.object({
  body: z.object({
    id: z.string({ required_error: "Shop owner ID is required" }),
  }),
});

const blockedShopOwner = z.object({
  body: z.object({
    id: z.string({ required_error: "Shop owner ID is required" }),
  }),
});

const updateShopOwnerDetails = z.object({
  params: z.object({
    id: z.string({ required_error: "Shop owner ID is required" }),
  }),
  body: z.object({
    name: z.string().min(1).optional(),
    email: z.string().email().optional(),
    phone_number: z.string().min(4).optional(),
    shop_name: z.string().optional(),
    shop_license_number: z.string().optional(),
    contact_email: z.string().email().optional(),
    contact_phone: z.string().optional(),
    location: z
      .object({
        address: z.string().optional(),
        lat: z.number().optional(),
        lng: z.number().optional(),
      })
      .optional(),
    approval_status: z.enum(["pending", "approved", "rejected"]).optional(),
    status: z.enum(["active", "deactivate"]).optional(),
  }),
});

// ─── Create Admin ──────────────────────────────────────────────────
const createAdmin = z.object({
  body: z.object({
    name: z
      .string({ required_error: "Name is required" })
      .min(1, "Name cannot be empty"),
    email: z
      .string({ required_error: "Email is required" })
      .email("Invalid email format"),
    phone_number: z
      .string({ required_error: "Phone number is required" })
      .min(4, "Phone number is too short"),
    password: z
      .string({ required_error: "Password is required" })
      .min(6, "Password must be at least 6 characters"),
  }),
});

// ─── Update Admin Profile ──────────────────────────────────────────
const updateAdminProfile = z.object({
  params: z.object({
    id: z.string({ required_error: "Admin ID is required" }),
  }),
  body: z.object({
    name: z.string().min(1).optional(),
    email: z.string().email().optional(),
    phone_number: z.string().min(4).optional(),
  }),
});

// ─── Delete Admin ──────────────────────────────────────────────────
const deleteAdmin = z.object({
  params: z.object({
    id: z.string({ required_error: "Admin ID is required" }),
  }),
});

// ─── Block/Unblock Customer ────────────────────────────────────────
const blockedCustomer = z.object({
  body: z.object({
    id: z.string({ required_error: "Customer ID is required" }),
  }),
});

// ─── Customer Details ──────────────────────────────────────────────
const getCustomerDetails = z.object({
  params: z.object({
    id: z.string({ required_error: "Customer ID is required" }),
  }),
});

export const AdminValidation = {
  acceptShopOwner,
  blockedShopOwner,
  updateShopOwnerDetails,
  createAdmin,
  updateAdminProfile,
  deleteAdmin,
  blockedCustomer,
  getCustomerDetails,
};
