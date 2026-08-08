import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { ICarPlate } from './car_plates.interface';
import CarPlate from './car_plates.model';

const createCarPlate = async (customerId: string, payload: Partial<ICarPlate>) => {
  const carPlate = await CarPlate.create({
    ...payload,
    customerId,
  });
  return carPlate;
};

const updateCarPlate = async (customerId: string, id: string, payload: Partial<ICarPlate>) => {
  const carPlate = await CarPlate.findOne({ _id: id, customerId });
  if (!carPlate) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Car plate not found');
  }

  const updatedCarPlate = await CarPlate.findByIdAndUpdate(id, payload, {
    new: true,
    runValidators: true,
  });

  return updatedCarPlate;
};

const deleteCarPlate = async (customerId: string, id: string) => {
  const carPlate = await CarPlate.findOne({ _id: id, customerId });
  if (!carPlate) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Car plate not found');
  }

  await CarPlate.findByIdAndDelete(id);
  return { message: 'Car plate deleted successfully' };
};

const getCarPlates = async (customerId: string) => {
  const carPlates = await CarPlate.find({ customerId });
  return carPlates;
};

const getSingleCarPlate = async (customerId: string, id: string) => {
  const carPlate = await CarPlate.findOne({ _id: id, customerId });
  if (!carPlate) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Car plate not found');
  }
  return carPlate;
};

export const CarPlateService = {
  createCarPlate,
  updateCarPlate,
  deleteCarPlate,
  getCarPlates,
  getSingleCarPlate,
};