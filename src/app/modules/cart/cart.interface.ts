import { Types, Document, Model } from 'mongoose';

export interface ICartItem {
  _id?: Types.ObjectId;
  customerId: Types.ObjectId;
  branchId: Types.ObjectId;
  productId: Types.ObjectId; // Menu ID
  menuName?: string;
  menuPrice?: number;
  menuImage?: string;
  quantity?: number;
  additionalItems?: ICartAdditionalItem[];
  totalPrice: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface ICartAdditionalItem {
  _id?: Types.ObjectId;
  itemId: Types.ObjectId;
  name: string;
  price: number;
  image?: string;
  quantity: number;
}

export interface ICart extends Document {
  customerId: Types.ObjectId;
  branchId: Types.ObjectId;
  items: ICartItem[];
  totalItems: number;
  totalAmount: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface CartModel extends Model<ICart> {
  // Add any custom static methods here if needed
}