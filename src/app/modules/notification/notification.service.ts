import { INotification } from './notification.interface';
import { Notification } from './notification.model';

const createNotification = async (payload: Partial<INotification>): Promise<INotification> => {
  const result = await Notification.create(payload);
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
