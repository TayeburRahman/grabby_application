import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IFaq } from './faq.interface';
import { FaqService } from './faq.service';

const createFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await FaqService.createFaq(req.body);

  sendResponse<IFaq>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Faq created successfully',
    data: result,
  });
});

const getAllFaqs = catchAsync(async (req: Request, res: Response) => {
  const result = await FaqService.getAllFaqs();

  sendResponse<IFaq[]>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Faqs retrieved successfully',
    data: result,
  });
});

const getSingleFaq = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FaqService.getSingleFaq(id);

  sendResponse<IFaq>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Faq retrieved successfully',
    data: result,
  });
});

const updateFaq = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FaqService.updateFaq(id, req.body);

  sendResponse<IFaq>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Faq updated successfully',
    data: result,
  });
});

const deleteFaq = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await FaqService.deleteFaq(id);

  sendResponse<IFaq>(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Faq deleted successfully',
    data: result,
  });
});

export const FaqController = {
  createFaq,
  getAllFaqs,
  getSingleFaq,
  updateFaq,
  deleteFaq,
};
