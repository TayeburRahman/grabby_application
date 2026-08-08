import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IPricingPlan } from './pricing_plan.interface';
import { PricingPlanService } from './pricing_plan.service';

const createPricingPlan = catchAsync(async (req: Request, res: Response) => {
  const result = await PricingPlanService.createPricingPlan(req.body);

  sendResponse<IPricingPlan>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Pricing plan created successfully',
    data: result,
  });
});

const getAllPricingPlans = catchAsync(async (req: Request, res: Response) => {
  const result = await PricingPlanService.getAllPricingPlans();

  sendResponse<IPricingPlan[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Pricing plans retrieved successfully',
    data: result,
  });
});

const getSinglePricingPlan = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await PricingPlanService.getSinglePricingPlan(id);

  sendResponse<IPricingPlan>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Pricing plan retrieved successfully',
    data: result,
  });
});

const updatePricingPlan = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await PricingPlanService.updatePricingPlan(id, req.body);

  sendResponse<IPricingPlan>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Pricing plan updated successfully',
    data: result,
  });
});

const deletePricingPlan = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await PricingPlanService.deletePricingPlan(id);

  sendResponse<IPricingPlan>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Pricing plan deleted successfully',
    data: result,
  });
});

export const PricingPlanController = {
  createPricingPlan,
  getAllPricingPlans,
  getSinglePricingPlan,
  updatePricingPlan,
  deletePricingPlan,
};
