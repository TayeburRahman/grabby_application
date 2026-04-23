import { z } from 'zod';

const createOrderSchema = z.object({
  body: z.object({
    branchId: z.string({ required_error: 'Branch ID is required' }),
    items: z.array(
      z.object({
        productId: z.string({ required_error: 'Product ID is required' }),
        menuName: z.string({ required_error: 'Menu name is required' }),
        menuPrice: z.number({ required_error: 'Menu price is required' }),
        menuImage: z.string({ required_error: 'Menu image is required' }),
        quantity: z.number({ required_error: 'Quantity is required' }),
        additionalItems: z.array(
          z.object({
            itemId: z.string({ required_error: 'Item ID is required' }),
            name: z.string({ required_error: 'Name is required' }),
            price: z.number({ required_error: 'Price is required' }),
            quantity: z.number({ required_error: 'Quantity is required' }),
          })
        ),
        totalPrice: z.number({ required_error: 'Total price is required' }),
      })
    ),
    pickupType: z.enum(['carPickup', 'counterPickup'], {
      required_error: 'Pickup type is required',
    }),
    applyGrabbyCredit: z.number().optional().nullable(),
    applyPromoCode: z.number().optional().nullable(),
    totalAmount: z.number({ required_error: 'Total amount is required' }),
    carPlates: z.string().optional(),
    paymentMethod: z.string({ required_error: 'Payment method is required' }),
    transactionId: z.string().optional(),
  }),
});

const updateOrderStatusSchema = z.object({
  body: z.object({
    status: z.enum(['placed', 'preparing', 'ready', 'completed', 'cancelled'], {
      required_error: 'Status is required',
    }),
  }),
});

export const OrderValidation = {
  createOrderSchema,
  updateOrderStatusSchema,
};
