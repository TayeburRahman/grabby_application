import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { ITermsAndConditions } from './terms_and_conditions.interface';
import { TermsAndConditionsService } from './terms_and_conditions.service';

const createOrUpdateTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await TermsAndConditionsService.createOrUpdateTermsAndConditions(req.body);

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions saved successfully',
    data: result,
  });
});

const getTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await TermsAndConditionsService.getTermsAndConditions();

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions retrieved successfully',
    data: result,
  });
});

export const TermsAndConditionsController = {
  createOrUpdateTermsAndConditions,
  getTermsAndConditions,
};
