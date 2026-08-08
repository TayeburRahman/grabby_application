import { z } from 'zod';

const createPromoCodeSchema = z.object({
  body: z.union([
    // Single promo code
    z.object({
      code: z.string({ required_error: 'Code is required' }).min(1, 'Code cannot be empty'),
      shopOwnerId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId').optional(),
      status: z.enum(['active', 'inactive']).optional().default('active'),
      discountPercent: z.number().min(0).max(100).optional().default(0),
      branchIds: z.union([
        z.array(z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId')),
        z.literal('all'),
      ], { required_error: 'branchIds is required' }),
    }),
    // Bulk promo codes
    z.array(z.object({
      code: z.string({ required_error: 'Code is required' }).min(1, 'Code cannot be empty'),
      shopOwnerId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId').optional(),
      status: z.enum(['active', 'inactive']).optional().default('active'),
      discountPercent: z.number().min(0).max(100).optional().default(0),
      branchIds: z.union([
        z.array(z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId')),
        z.literal('all'),
      ], { required_error: 'branchIds is required' }),
    })).min(1, 'At least one promo code is required for bulk creation'),
  ]),
});

const updatePromoCodeSchema = z.object({
  params: z.object({
    id: z.string({ required_error: 'Promo code ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
  body: z.object({
    code: z.string().min(1).optional(),
    status: z.enum(['active', 'inactive']).optional(),
    discountPercent: z.number().min(0).max(100).optional(),
    branchIds: z.union([
      z.array(z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId')),
      z.literal('all'),
    ]).optional(),
  }),
});

const updatePromoCodeStatusSchema = z.object({
  params: z.object({
    id: z.string({ required_error: 'Promo code ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
  body: z.object({
    status: z.enum(['active', 'inactive'], { required_error: 'Status is required' }),
  }),
});

const deletePromoCodeSchema = z.object({
  params: z.object({
    id: z.string({ required_error: 'Promo code ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
});

const getPromoCodesSchema = z.object({
  query: z.object({
    shopOwnerId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId').optional(),
    branchId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId').optional(),
    code: z.string().optional(),
    status: z.enum(['active', 'inactive']).optional(),
  }),
});

const validatePromoCodeSchema = z.object({
  body: z.object({
    code: z.string({ required_error: 'Code is required' }).min(1, 'Code cannot be empty'),
    shopOwnerId: z.string({ required_error: 'Shop Owner ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
    cartId: z.string({ required_error: 'Cart ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
});

export const PromoCodeValidation = {
  createPromoCodeSchema,
  updatePromoCodeSchema,
  updatePromoCodeStatusSchema,
  deletePromoCodeSchema,
  getPromoCodesSchema,
  validatePromoCodeSchema,
};