import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IHelpCenter } from './help_center.interface';
import { HelpCenterService } from './help_center.service';

const createHelpCenter = catchAsync(async (req: Request, res: Response) => {
  const result = await HelpCenterService.createHelpCenter(req.body);

  sendResponse<IHelpCenter>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Help Center created successfully',
    data: result,
  });
});

const getAllHelpCenters = catchAsync(async (req: Request, res: Response) => {
  const result = await HelpCenterService.getAllHelpCenters();

  sendResponse<IHelpCenter[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Help Centers retrieved successfully',
    data: result,
  });
});

const getSingleHelpCenter = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await HelpCenterService.getSingleHelpCenter(id);

  sendResponse<IHelpCenter>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Help Center retrieved successfully',
    data: result,
  });
});

const updateHelpCenter = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await HelpCenterService.updateHelpCenter(id, req.body);

  sendResponse<IHelpCenter>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Help Center updated successfully',
    data: result,
  });
});

const deleteHelpCenter = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await HelpCenterService.deleteHelpCenter(id);

  sendResponse<IHelpCenter>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Help Center deleted successfully',
    data: result,
  });
});

export const HelpCenterController = {
  createHelpCenter,
  getAllHelpCenters,
  getSingleHelpCenter,
  updateHelpCenter,
  deleteHelpCenter,
};
