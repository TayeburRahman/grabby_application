import { z } from 'zod';

const createSchema = z.object({
  body: z.object({
    name: z.string({ required_error: 'Name is required' }),
    shopOwnerId: z.string().optional(),
  }),
});

export const MenuCategoryValidation = { createSchema };
