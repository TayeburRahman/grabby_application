import { z } from 'zod';

const cartItemSchema = z.object({
  branchId: z.string({ required_error: 'Branch ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  productId: z.string({ required_error: 'Product ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  menuName: z.string().optional(),
  menuPrice: z.number().optional().default(0),
  menuImage: z.string().optional(),
  quantity: z.number().optional().default(0),
  additionalItems: z.array(z.object({
    itemId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
    name: z.string().min(1, 'Item name cannot be empty'),
    price: z.number().min(0, 'Price cannot be negative'),
    image: z.string().optional(),
    quantity: z.number().min(1, 'Quantity must be at least 1'),
  })).optional().default([]),
});

const addToCartSchema = z.object({
  body: z.union([
    cartItemSchema,
    z.array(cartItemSchema)
  ]),
});

const updateCartItemSchema = z.object({
  params: z.object({
    itemId: z.string({ required_error: 'Cart item ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
  body: z.object({
    quantity: z.number().min(0, 'Quantity cannot be negative').optional(),
    additionalItems: z.array(z.object({
      itemId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
      name: z.string().min(1, 'Item name cannot be empty').optional(),
      price: z.number().min(0, 'Price cannot be negative').optional(),
      image: z.string().optional(),
      quantity: z.number().min(1, 'Quantity must be at least 1').optional(),
    })).optional(),
  }),
});

const removeFromCartSchema = z.object({
  params: z.object({
    itemId: z.string({ required_error: 'Cart item ID is required' }).regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId'),
  }),
});

const clearCartSchema = z.object({
  body: z.object({
    branchId: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid ObjectId').optional(),
  }),
});

export const CartValidation = {
  addToCartSchema,
  updateCartItemSchema,
  removeFromCartSchema,
  clearCartSchema,
};