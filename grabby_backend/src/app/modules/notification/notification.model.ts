import { Schema, model } from 'mongoose';
import { INotification, NotificationModel } from './notification.interface';

const notificationSchema = new Schema<INotification>(
  {
    title: {
      type: String,
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    recipient: {
      type: Schema.Types.ObjectId,
      required: true,
    },
    role: {
      type: String,
      enum: ['customer', 'shop_owner', 'admin'],
      required: true,
    },
    orderId: {
      type: Schema.Types.ObjectId,
      ref: 'Order',
    },
    isRead: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const Notification = model<INotification, NotificationModel>(
  'Notification',
  notificationSchema
);
