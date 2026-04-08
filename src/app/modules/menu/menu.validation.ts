import { z } from 'zod';

const additionalItemSchema = z.object({
  name: z.string({ required_error: 'Additional item name is required' }),
  price: z.number({ required_error: 'Additional item price is required' }),
  image: z.string().optional(),
});

const additionalGroupSchema = z.object({
  groupName: z.string({ required_error: 'Group name is required' }),
  type: z.enum(['regular', 'optional'], {
    required_error: 'Group type is required (regular or optional)',
  }),
  items: z.array(additionalItemSchema).default([]),
});

const createSchema = z.object({
  body: z.object({
    itemName: z.string({ required_error: 'Item name is required' }),
    category: z.string({ required_error: 'Category ID is required' }),
    price: z.number({ required_error: 'Price is required' }),
    description: z.string().optional(),
    additionalItems: z.array(additionalGroupSchema).optional(),
    stamp: z.number().optional(),
    isAvailable: z.boolean().optional(),
    shopOwnerId: z.string().optional(),
  }),
});

const updateSchema = z.object({
  body: z.object({
    itemName: z.string().optional(),
    category: z.string().optional(),
    price: z.number().optional(),
    description: z.string().optional(),
    additionalItems: z.array(additionalGroupSchema).optional(),
    stamp: z.number().optional(),
    isAvailable: z.boolean().optional(),
  }),
});

export const MenuValidation = { createSchema, updateSchema };
