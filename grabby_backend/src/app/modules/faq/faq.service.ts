import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { IFaq } from './faq.interface';
import { Faq } from './faq.model';

const createFaq = async (payload: IFaq): Promise<IFaq> => {
  const result = await Faq.create(payload);
  return result;
};

const getAllFaqs = async (): Promise<IFaq[]> => {
  const result = await Faq.find({}).sort({ createdAt: -1 });
  return result;
};

const getSingleFaq = async (id: string): Promise<IFaq | null> => {
  const result = await Faq.findById(id);
  return result;
};

const updateFaq = async (
  id: string,
  payload: Partial<IFaq>
): Promise<IFaq | null> => {
  const isExist = await Faq.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Faq not found');
  }

  const result = await Faq.findOneAndUpdate({ _id: id }, payload, {
    new: true,
  });
  return result;
};

const deleteFaq = async (id: string): Promise<IFaq | null> => {
  const isExist = await Faq.findById(id);
  if (!isExist) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Faq not found');
  }

  const result = await Faq.findByIdAndDelete(id);
  return result;
};

export const FaqService = {
  createFaq,
  getAllFaqs,
  getSingleFaq,
  updateFaq,
  deleteFaq,
};
