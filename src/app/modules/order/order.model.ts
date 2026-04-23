import { Schema, model, Types } from 'mongoose';
import { IOrder, IOrderItem } from './order.interface';

const orderItemSchema = new Schema<IOrderItem>({
  productId: { type: Schema.Types.ObjectId, ref: 'Menu', required: true },
  menuName: { type: String, required: true },
  menuPrice: { type: Number, required: true },
  menuImage: { type: String, required: true },
  quantity: { type: Number, required: true },
  additionalItems: [
    {
      itemId: { type: Schema.Types.ObjectId, ref: 'AdditionalItem' },
      name: { type: String, required: true },
      price: { type: Number, required: true },
      quantity: { type: Number, required: true },
    },
  ],
  totalPrice: { type: Number, required: true },
});

const orderSchema = new Schema<IOrder>(
  {
    orderId: { type: String, required: true, unique: true },
    customerId: { type: Schema.Types.ObjectId, ref: 'Customer', required: true },
    branchId: { type: Schema.Types.ObjectId, ref: 'Branch', required: true },
    items: { type: [orderItemSchema], required: true },
    pickupType: {
      type: String,
      enum: ['carPickup', 'counterPickup'],
      required: true,
    },
    applyGrabbyCredit: { type: Number, default: 0 },
    applyPromoCode: { type: Number, default: 0 },
    totalAmount: { type: Number, required: true },
    carPlates: { type: String },
    status: {
      type: String,
      enum: ['placed', 'preparing', 'ready', 'completed', 'cancelled'],
      default: 'placed',
    },
    paymentStatus: {
      type: String,
      enum: ['paid', 'unpaid'],
      default: 'paid',
    },
    paymentMethod: { type: String, required: true },
    transactionId: { type: String, required: true },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const Order = model<IOrder>('Order', orderSchema);
