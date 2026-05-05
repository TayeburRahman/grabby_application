import { z } from "zod";

const locationSchema = z.object({
  body: z.object({
    address: z.string({ required_error: "Address is required" }).min(1),
    lat: z.number({ required_error: "Latitude is required" }),
    lng: z.number({ required_error: "Longitude is required" }),
  }),
});

const businessInfoSchema = z.object({
  body: z.object({
    shop_name: z
      .string({ required_error: "Shop name is required" })
      .min(1, "Shop name cannot be empty"),
    shop_license_number: z
      .string({ required_error: "Shop license number is required" })
      .min(1, "License number cannot be empty"),
    contact_email: z
      .string({ required_error: "Contact email is required" })
      .email("Invalid email format"),
    contact_phone: z
      .string({ required_error: "Contact phone is required" })
      .min(4, "Phone number is too short"),
  }),
});

const dayHoursSchema = z.object({
  day: z.string({ required_error: "Day is required" }),
  open: z.string().optional(),
  close: z.string().optional(),
  isClosed: z.boolean().optional().default(false),
});

const branchSchema = z.object({
  branch_name: z
    .string({ required_error: "Branch name is required" })
    .min(1, "Branch name cannot be empty"),
  address: z.string({ required_error: "Address is required" }),
  lat: z.number({ required_error: "Latitude is required" }),
  lng: z.number({ required_error: "Longitude is required" }),
  phone_number: z
    .string({ required_error: "Phone number is required" })
    .min(4, "Phone number is too short"),
  availability: z.array(dayHoursSchema).optional(),
  applyMenuForAll: z.boolean().optional().default(false),
});

const branchesSchema = z.object({
  body: z.object({
    branches: z.array(branchSchema).min(1, "At least one branch is required"),
  }),
});

// ─── Update Profile ────────────────────────────────────────────────
const updateProfileSchema = z.object({
  body: z.object({
    name: z.string().min(1).optional(),
    email: z.string().email().optional(),
    phone_number: z.string().min(4).optional(),
    shop_name: z.string().min(1).optional(),
    shop_license_number: z.string().min(1).optional(),
    contact_email: z.string().email().optional(),
    contact_phone: z.string().min(4).optional(),
    location: z
      .object({
        address: z.string().optional(),
        lat: z.number().optional(),
        lng: z.number().optional(),
      })
      .optional(),
  }),
});

// ─── Create Branch ─────────────────────────────────────────────────
const createBranchSchema = z.object({
  body: z.object({
    branch_name: z
      .string({ required_error: "Branch name is required" })
      .min(1, "Branch name cannot be empty"),
    address: z.string({ required_error: "Address is required" }),
    lat: z.number({ required_error: "Latitude is required" }),
    lng: z.number({ required_error: "Longitude is required" }),
    phone_number: z
      .string({ required_error: "Phone number is required" })
      .min(4, "Phone number is too short"),
    availability: z.array(dayHoursSchema).optional(),
    applyMenuForAll: z.boolean().optional().default(false),
  }),
});

// ─── Update Branch ─────────────────────────────────────────────────
const updateBranchSchema = z.object({
  params: z.object({
    branchId: z.string({ required_error: "Branch ID is required" }),
  }),
  body: z.object({
    branch_name: z.string().min(1).optional(),
    address: z.string().optional(),
    lat: z.number().optional(),
    lng: z.number().optional(),
    phone_number: z.string().min(4).optional(),
    applyMenuForAll: z.boolean().optional(),
  }),
});

// ─── Delete Branch ─────────────────────────────────────────────────
const deleteBranchSchema = z.object({
  params: z.object({
    branchId: z.string({ required_error: "Branch ID is required" }),
  }),
});

// ─── Update Branch Availability ────────────────────────────────────
const updateBranchAvailabilitySchema = z.object({
  params: z.object({
    branchId: z.string({ required_error: "Branch ID is required" }),
  }),
  body: z.object({
    availability: z
      .array(dayHoursSchema)
      .min(1, "At least one day is required"),
  }),
});

export const ShopOwnerValidation = {
  locationSchema,
  businessInfoSchema,
  branchesSchema,
  updateProfileSchema,
  createBranchSchema,
  updateBranchSchema,
  deleteBranchSchema,
  updateBranchAvailabilitySchema,
};
