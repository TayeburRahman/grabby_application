import { Types, Document } from 'mongoose';

export type IOrderPickupType = 'carPickup' | 'counterPickup';
export type IOrderStatus = 'placed' | 'preparing' | 'ready' | 'completed' | 'cancelled';
export type IPaymentStatus = 'paid' | 'unpaid';

export interface IOrderItem {
  productId: Types.ObjectId;
  menuName: string;
  menuPrice: number;
  menuImage: string;
  quantity: number;
  additionalItems: {
    itemId: Types.ObjectId;
    name: string;
    price: number;
    quantity: number;
  }[];
  totalPrice: number;
}

export interface IOrder extends Document {
  orderId: string;
  customerId: Types.ObjectId;
  branchId: Types.ObjectId;
  items: IOrderItem[];
  pickupType: IOrderPickupType;
  applyGrabbyCredit?: number;
  applyPromoCode?: number;
  totalAmount: number;
  carPlates?: string;
  status: IOrderStatus;
  paymentStatus: IPaymentStatus;
  paymentMethod: string;
  transactionId: string;
  createdAt?: Date;
  updatedAt?: Date;
}
