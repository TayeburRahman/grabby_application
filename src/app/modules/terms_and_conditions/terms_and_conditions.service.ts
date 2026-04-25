import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { ITermsAndConditions } from './terms_and_conditions.interface';
import { TermsAndConditions } from './terms_and_conditions.model';

const createTermsAndConditions = async (
  payload: ITermsAndConditions
): Promise<ITermsAndConditions> => {
  const result = await TermsAndConditions.create(payload);
  return result;
};

const getAllTermsAndConditions = async (): Promise<ITermsAndConditions[]> => {
  const result = await TermsAndConditions.find({}).sort({ createdAt: -1 });
  return result;
};

const getSingleTermsAndConditions = async (
  id: string
): Promise<ITermsAndConditions | null> => {
  const result = await TermsAndConditions.findById(id);
  return result;
};

const updateTermsAndConditions = async (
  id: string,
  payload: Partial<ITermsAndConditions>
): Promise<ITermsAndConditions | null> => {
  const isExist = await TermsAndConditions.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Terms and Conditions not found');
  }

  const result = await TermsAndConditions.findOneAndUpdate({ _id: id }, payload, {
    new: true,
  });
  return result;
};

const deleteTermsAndConditions = async (
  id: string
): Promise<ITermsAndConditions | null> => {
  const isExist = await TermsAndConditions.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Terms and Conditions not found');
  }

  const result = await TermsAndConditions.findByIdAndDelete(id);
  return result;
};

export const TermsAndConditionsService = {
  createTermsAndConditions,
  getAllTermsAndConditions,
  getSingleTermsAndConditions,
  updateTermsAndConditions,
  deleteTermsAndConditions,
};
