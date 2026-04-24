import { Schema, model } from 'mongoose';
import { ICart, CartModel } from './cart.interface';

const cartAdditionalItemSchema = new Schema(
  {
    itemId: { type: Schema.Types.ObjectId, required: true },
    name: { type: String, required: true },
    price: { type: Number, required: true },
    image: { type: String, default: null },
    quantity: { type: Number, required: true, default: 1 },
  },
  { _id: true }
);

const cartItemSchema = new Schema(
  {
    customerId: { type: Schema.Types.ObjectId, ref: 'Customer', required: true },
    branchId: { type: Schema.Types.ObjectId, ref: 'Branch', required: true },
    productId: { type: Schema.Types.ObjectId, required: true }, // Menu ID or Additional Item ID 
    menuName: { type: String, required: false },
    menuPrice: { type: Number, required: false },
    menuImage: { type: String, default: null },
    quantity: { type: Number, required: false, default: 0 },
    additionalItems: { type: [cartAdditionalItemSchema], default: [] },
    totalPrice: { type: Number, required: true },
  },
  { timestamps: true }
);

const cartSchema = new Schema<ICart, CartModel>(
  {
    customerId: { type: Schema.Types.ObjectId, ref: 'Customer', required: true },
    branchId: { type: Schema.Types.ObjectId, ref: 'Branch', required: true },
    items: { type: [cartItemSchema], default: [] },
    totalItems: { type: Number, default: 0 },
    totalAmount: { type: Number, default: 0 },
    appliedCredit: { type: Number, default: 0 },
  },
  { timestamps: true }
);

export const Cart = model<ICart, CartModel>('Cart', cartSchema);