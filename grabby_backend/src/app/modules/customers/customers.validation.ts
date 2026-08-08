import { z } from "zod";

const updateCustomerSchema = z.object({
  body: z.object({
    name: z.string().optional(),
    phone_number: z.string().optional(),
    addressName: z.string().optional(),
    lat: z.number().optional(),
    lon: z.number().optional(),
    profile_image: z.string().optional(),
  }),
});

const saveLocationSchema = z.object({
  body: z.object({
    addressName: z.string({ required_error: "Address name is required" }),
    lat: z.number({ required_error: "Latitude is required" }),
    lon: z.number({ required_error: "Longitude is required" }),
  }),
});

export const CustomerValidation = {
  updateCustomerSchema,
  saveLocationSchema,
};
