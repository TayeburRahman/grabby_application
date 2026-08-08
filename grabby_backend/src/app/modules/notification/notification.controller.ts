import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { INotification } from './notification.interface';
import { NotificationService } from './notification.service';
import { IReqUser } from '../auth/auth.interface';

const getMyNotifications = catchAsync(async (req: Request, res: Response) => {
  const { userId, role } = req.user as IReqUser;
  
  // Map roles if necessary, e.g., 'SHOP_OWNER' -> 'shop_owner'
  const formattedRole = role.toLowerCase() as any;

  const result = await NotificationService.getMyNotifications(userId, formattedRole);

  sendResponse<INotification[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Notifications retrieved successfully',
    data: result,
  });
});

const markAsRead = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await NotificationService.markAsRead(id);

  sendResponse<INotification>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Notification marked as read successfully',
    data: result,
  });
});

export const NotificationController = {
  getMyNotifications,
  markAsRead,
};
