import { z } from 'zod';

const schemaObject = {
  discountName: z.string({ required_error: 'Discount name is required' }),
  eventName: z.string({ required_error: 'Event name is required' }),
  startDate: z.string({ required_error: 'Start date is required' }),
  endDate: z.string({ required_error: 'End date is required' }),
  appliedOn: z.enum(['all', 'specific']).optional(),
  specificItems: z.array(z.string()).optional(),
  discountType: z.enum(['percentage', 'fixed']).default('percentage').optional(),
  discountValue: z.number().optional(),
  isActive: z.boolean().optional(),
};

const createSchema = z.object({
  body: z.object(schemaObject),
});

const updateSchema = z.object({
  body: z.object(schemaObject).partial(),
});

const toggleActiveSchema = z.object({
  body: z.object({
    isActive: z.boolean({ required_error: 'isActive is required' }),
    appliedOn: z.enum(['all', 'specific']).optional(),
    specificItems: z.array(z.string()).optional(),
    discountType: z.enum(['percentage', 'fixed']).optional(),
    discountValue: z.number().optional(),
  }),
});

export const EventOfferValidation = { createSchema, updateSchema, toggleActiveSchema };
