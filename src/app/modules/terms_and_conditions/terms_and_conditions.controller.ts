import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { ITermsAndConditions } from './terms_and_conditions.interface';
import { TermsAndConditionsService } from './terms_and_conditions.service';

const createTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await TermsAndConditionsService.createTermsAndConditions(req.body);

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions created successfully',
    data: result,
  });
});

const getAllTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await TermsAndConditionsService.getAllTermsAndConditions();

  sendResponse<ITermsAndConditions[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions retrieved successfully',
    data: result,
  });
});

const getSingleTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await TermsAndConditionsService.getSingleTermsAndConditions(id);

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions retrieved successfully',
    data: result,
  });
});

const updateTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await TermsAndConditionsService.updateTermsAndConditions(id, req.body);

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions updated successfully',
    data: result,
  });
});

const deleteTermsAndConditions = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await TermsAndConditionsService.deleteTermsAndConditions(id);

  sendResponse<ITermsAndConditions>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Terms and Conditions deleted successfully',
    data: result,
  });
});

export const TermsAndConditionsController = {
  createTermsAndConditions,
  getAllTermsAndConditions,
  getSingleTermsAndConditions,
  updateTermsAndConditions,
  deleteTermsAndConditions,
};
