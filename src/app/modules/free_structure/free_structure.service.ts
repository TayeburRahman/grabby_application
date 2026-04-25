import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { IFreeStructure } from './free_structure.interface';
import { FreeStructure } from './free_structure.model';

const createFreeStructure = async (payload: IFreeStructure): Promise<IFreeStructure> => {
  const result = await FreeStructure.create(payload);
  return result;
};

const getAllFreeStructures = async (): Promise<IFreeStructure[]> => {
  const result = await FreeStructure.find({}).sort({ createdAt: -1 });
  return result;
};

const getSingleFreeStructure = async (id: string): Promise<IFreeStructure | null> => {
  const result = await FreeStructure.findById(id);
  return result;
};

const updateFreeStructure = async (
  id: string,
  payload: Partial<IFreeStructure>
): Promise<IFreeStructure | null> => {
  const isExist = await FreeStructure.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Free structure not found');
  }

  const result = await FreeStructure.findOneAndUpdate({ _id: id }, payload, {
    new: true,
  });
  return result;
};

const deleteFreeStructure = async (id: string): Promise<IFreeStructure | null> => {
  const isExist = await FreeStructure.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Free structure not found');
  }

  const result = await FreeStructure.findByIdAndDelete(id);
  return result;
};

export const FreeStructureService = {
  createFreeStructure,
  getAllFreeStructures,
  getSingleFreeStructure,
  updateFreeStructure,
  deleteFreeStructure,
};
