import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { IPricingPlan } from './pricing_plan.interface';
import { PricingPlan } from './pricing_plan.model';

const createPricingPlan = async (payload: IPricingPlan): Promise<IPricingPlan> => {
  const result = await PricingPlan.create(payload);
  return result;
};

const getAllPricingPlans = async (): Promise<IPricingPlan[]> => {
  const result = await PricingPlan.find({}).sort({ createdAt: -1 });
  return result;
};

const getSinglePricingPlan = async (id: string): Promise<IPricingPlan | null> => {
  const result = await PricingPlan.findById(id);
  return result;
};

const updatePricingPlan = async (
  id: string,
  payload: Partial<IPricingPlan>
): Promise<IPricingPlan | null> => {
  const isExist = await PricingPlan.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Pricing plan not found');
  }

  const result = await PricingPlan.findOneAndUpdate({ _id: id }, payload, {
    new: true,
  });
  return result;
};

const deletePricingPlan = async (id: string): Promise<IPricingPlan | null> => {
  const isExist = await PricingPlan.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Pricing plan not found');
  }

  const result = await PricingPlan.findByIdAndDelete(id);
  return result;
};

export const PricingPlanService = {
  createPricingPlan,
  getAllPricingPlans,
  getSinglePricingPlan,
  updatePricingPlan,
  deletePricingPlan,
};
