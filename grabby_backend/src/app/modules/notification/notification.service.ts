import { INotification } from './notification.interface';
import { Notification } from './notification.model';

import Customer from '../customers/customers.model';
import { ShopOwner } from '../shop_owner/shop_owner.model';
import Auth from '../auth/auth.model';
import { sendNotificationOnesignal } from '../../../utils/onesignal';

const createNotification = async (payload: Partial<INotification>): Promise<INotification> => {
  const result = await Notification.create(payload);

  try {
    let authId = null;

    if (payload.role === 'customer') {
      const customer = await Customer.findById(payload.recipient);
      authId = customer?.authId;
    } else if (payload.role === 'shop_owner') {
      const shopOwner = await ShopOwner.findById(payload.recipient);
      authId = shopOwner?.authId;
    }

    if (authId) {
      const auth = await Auth.findById(authId);
      if (auth && auth.playerIds && auth.playerIds.length > 0) {
        await sendNotificationOnesignal(
          auth.playerIds,
          { eng: payload.title || 'New Notification' },
          { eng: payload.message || 'You have a new notification.' },
          'notification',
          payload.orderId?.toString()
        );
      }
    }
  } catch (error) {
    console.error('Error in sending push notification:', error);
  }

  return result;
};

const getMyNotifications = async (
  recipient: string,
  role: string
): Promise<INotification[]> => {
  const result = await Notification.find({ recipient, role }).sort({ createdAt: -1 });
  return result;
};

const markAsRead = async (id: string): Promise<INotification | null> => {
  const result = await Notification.findByIdAndUpdate(
    id,
    { isRead: true },
    { new: true }
  );
  return result;
};

export const NotificationService = {
  createNotification,
  getMyNotifications,
  markAsRead,
};
