import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { ShopOwnerPlanService } from './shop_owner_plan.service';
import { IReqUser } from '../auth/auth.interface';

const purchasePlan = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { planId } = req.body;
  const result = await ShopOwnerPlanService.purchasePlan(userId, planId);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Plan purchased successfully',
    data: result,
  });
});

const getAdvertisedBranches = catchAsync(async (req: Request, res: Response) => {
  const { lat, lon } = req.query;
  const result = await ShopOwnerPlanService.getAdvertisedBranches(
    lat ? Number(lat) : undefined,
    lon ? Number(lon) : undefined
  );

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Advertised branches retrieved successfully',
    data: result,
  });
});

export const ShopOwnerPlanController = {
  purchasePlan,
  getAdvertisedBranches,
};
