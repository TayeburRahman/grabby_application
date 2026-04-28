import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { DashboardService } from './dashboard.service';
import { IReqUser } from '../auth/auth.interface';

const getShopOwnerDashboardStats = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await DashboardService.getShopOwnerDashboardStats(userId);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Dashboard stats retrieved successfully',
    data: result,
  });
});

const getAdminDashboardStats = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.getAdminDashboardStats();

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Admin dashboard stats retrieved successfully',
    data: result,
  });
});

export const DashboardController = {
  getShopOwnerDashboardStats,
  getAdminDashboardStats,
};
