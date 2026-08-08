import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { IHelpCenter } from './help_center.interface';
import { HelpCenter } from './help_center.model';

const createHelpCenter = async (payload: IHelpCenter): Promise<IHelpCenter> => {
  const result = await HelpCenter.create(payload);
  return result;
};

const getAllHelpCenters = async (): Promise<IHelpCenter[]> => {
  const result = await HelpCenter.find({}).sort({ createdAt: -1 });
  return result;
};

const getSingleHelpCenter = async (id: string): Promise<IHelpCenter | null> => {
  const result = await HelpCenter.findById(id);
  return result;
};

const updateHelpCenter = async (
  id: string,
  payload: Partial<IHelpCenter>
): Promise<IHelpCenter | null> => {
  const isExist = await HelpCenter.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Help Center not found');
  }

  const result = await HelpCenter.findOneAndUpdate({ _id: id }, payload, {
    new: true,
  });
  return result;
};

const deleteHelpCenter = async (id: string): Promise<IHelpCenter | null> => {
  const isExist = await HelpCenter.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Help Center not found');
  }

  const result = await HelpCenter.findByIdAndDelete(id);
  return result;
};

export const HelpCenterService = {
  createHelpCenter,
  getAllHelpCenters,
  getSingleHelpCenter,
  updateHelpCenter,
  deleteHelpCenter,
};
