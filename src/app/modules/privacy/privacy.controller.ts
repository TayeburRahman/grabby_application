import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IPrivacy } from './privacy.interface';
import { PrivacyService } from './privacy.service';

const createOrUpdatePrivacy = catchAsync(async (req: Request, res: Response) => {
  const result = await PrivacyService.createOrUpdatePrivacy(req.body);

  sendResponse<IPrivacy>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Privacy Policy saved successfully',
    data: result,
  });
});

const getPrivacy = catchAsync(async (req: Request, res: Response) => {
  const result = await PrivacyService.getPrivacy();

  sendResponse<IPrivacy>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Privacy Policy fetched successfully',
    data: result,
  });
});

export const PrivacyController = {
  createOrUpdatePrivacy,
  getPrivacy,
};
