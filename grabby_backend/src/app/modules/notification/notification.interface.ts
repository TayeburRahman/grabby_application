import { Model, Types } from 'mongoose';

export type INotification = {
  title: string;
  message: string;
  recipient: Types.ObjectId; // User (Customer or ShopOwner/Auth)
  role: 'customer' | 'shop_owner' | 'admin';
  orderId?: Types.ObjectId;
  isRead: boolean;
};

export type NotificationModel = Model<INotification, Record<string, unknown>>;
