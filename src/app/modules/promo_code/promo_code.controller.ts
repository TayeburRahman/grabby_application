import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import { PromoCodeService } from './promo_code.service';
import sendResponse from '../../../shared/sendResponse';
import { IReqUser } from '../auth/auth.interface';

const createPromoCode = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await PromoCodeService.createPromoCode(userId, req.body);

  const isBulk = Array.isArray(req.body);
  const message = isBulk
    ? `${(result as any[]).length} promo codes created successfully.`
    : 'Promo code created successfully.';

  sendResponse(res, {
    statusCode: 201,
    success: true,
    message,
    data: result,
  });
});

const updatePromoCode = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await PromoCodeService.updatePromoCode(userId, req.params.id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Promo code updated successfully.',
    data: result,
  });
});

const updatePromoCodeStatus = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await PromoCodeService.updatePromoCodeStatus(userId, req.params.id, req.body.status);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Promo code status updated successfully.',
    data: result,
  });
});

const deletePromoCode = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await PromoCodeService.deletePromoCode(userId, req.params.id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

const getPromoCodes = catchAsync(async (req: Request, res: Response) => {
  const result = await PromoCodeService.getPromoCodes(req.query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Promo codes retrieved successfully.',
    data: result,
  });
});

const getPromoCodesCustomer = catchAsync(async (req: Request, res: Response) => {
  const result = await PromoCodeService.getPromoCodesCustomer(req.query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Promo codes retrieved successfully.',
    data: result,
  });
});

const validatePromoCode = catchAsync(async (req: Request, res: Response) => {
  const { code, shopOwnerId, cartId } = req.body;

  const result = await PromoCodeService.validatePromoCode(code, shopOwnerId, cartId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
    data: result,
  });
});

export const PromoCodeController = {
  createPromoCode,
  updatePromoCode,
  updatePromoCodeStatus,
  deletePromoCode,
  getPromoCodes,
  getPromoCodesCustomer,
  validatePromoCode,
};