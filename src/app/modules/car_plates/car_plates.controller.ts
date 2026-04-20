import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import { CarPlateService } from './car_plates.service';
import sendResponse from '../../../shared/sendResponse';

const createCarPlate = catchAsync(async (req: Request, res: Response) => {
  const customerId = req.user?.userId as string;
  const result = await CarPlateService.createCarPlate(customerId, req.body);
  sendResponse(res, {
    statusCode: httpStatus.CREATED,
    success: true,
    message: 'Car plate created successfully.',
    data: result,
  });
});

const updateCarPlate = catchAsync(async (req: Request, res: Response) => {
  const customerId = req.user?.userId as string;
  const result = await CarPlateService.updateCarPlate(customerId, req.params.id, req.body);
  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Car plate updated successfully.',
    data: result,
  });
});

const deleteCarPlate = catchAsync(async (req: Request, res: Response) => {
  const customerId = req.user?.userId as string;
  const result = await CarPlateService.deleteCarPlate(customerId, req.params.id);
  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: result.message,
  });
});

const getCarPlates = catchAsync(async (req: Request, res: Response) => {
  const customerId = req.user?.userId as string;
  const result = await CarPlateService.getCarPlates(customerId);
  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Car plates retrieved successfully.',
    data: result,
  });
});

const getSingleCarPlate = catchAsync(async (req: Request, res: Response) => {
  const customerId = req.user?.userId as string;
  const result = await CarPlateService.getSingleCarPlate(customerId, req.params.id);
  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Car plate retrieved successfully.',
    data: result,
  });
});

export const CarPlateController = {
  createCarPlate,
  updateCarPlate,
  deleteCarPlate,
  getCarPlates,
  getSingleCarPlate,
};