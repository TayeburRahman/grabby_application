import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IFreeStructure } from './free_structure.interface';
import { FreeStructureService } from './free_structure.service';

const createFreeStructure = catchAsync(async (req: Request, res: Response) => {
  const result = await FreeStructureService.createFreeStructure(req.body);

  sendResponse<IFreeStructure>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Free structure created successfully',
    data: result,
  });
});

const getAllFreeStructures = catchAsync(async (req: Request, res: Response) => {
  const result = await FreeStructureService.getAllFreeStructures();

  sendResponse<IFreeStructure[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Free structures retrieved successfully',
    data: result,
  });
});

const getSingleFreeStructure = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FreeStructureService.getSingleFreeStructure(id);

  sendResponse<IFreeStructure>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Free structure retrieved successfully',
    data: result,
  });
});

const updateFreeStructure = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FreeStructureService.updateFreeStructure(id, req.body);

  sendResponse<IFreeStructure>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Free structure updated successfully',
    data: result,
  });
});

const deleteFreeStructure = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FreeStructureService.deleteFreeStructure(id);

  sendResponse<IFreeStructure>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Free structure deleted successfully',
    data: result,
  });
});

export const FreeStructureController = {
  createFreeStructure,
  getAllFreeStructures,
  getSingleFreeStructure,
  updateFreeStructure,
  deleteFreeStructure,
};
