import { z } from 'zod';

const createPricingPlanZodSchema = z.object({
  body: z.object({
    icon: z.string({
      required_error: 'Icon is required',
    }),
    name: z.string({
      required_error: 'Name is required',
    }),
    details: z.string({
      required_error: 'Details are required',
    }),
    price: z.number({
      required_error: 'Price is required',
    }),
    perDay: z.number({
      required_error: 'Per day value is required',
    }),
  }),
});

const updatePricingPlanZodSchema = z.object({
  body: z.object({
    icon: z.string().optional(),
    name: z.string().optional(),
    details: z.string().optional(),
    price: z.number().optional(),
    perDay: z.number().optional(),
  }),
});

export const PricingPlanValidation = {
  createPricingPlanZodSchema,
  updatePricingPlanZodSchema,
};
