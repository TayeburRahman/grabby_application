import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { EventOfferService } from './event_offer.service';
import { IReqUser } from '../auth/auth.interface';

// ──── Create Template ────
const createByShopOwner = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const payload = {
    ...req.body,
    shopOwnerId: userId,
    createdBy: 'shop_owner' as const,
  };
  const result = await EventOfferService.create(payload);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Event offer created successfully',
    data: result,
  });
});

const createByAdmin = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const payload = {
    ...req.body,
    createdBy: 'admin' as const,
    createdByAdminId: userId,
  };
  const result = await EventOfferService.create(payload);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Event offer created by admin successfully',
    data: result,
  });
});

// ──── Get Listing ────
const getAllForShopOwner = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { result, meta } = await EventOfferService.getAllForShopOwner(req.query, userId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Event offers with your activation status fetched successfully',
    meta,
    data: result,
  });
});

const getAllForAdmin = catchAsync(async (req: Request, res: Response) => {
  const { result, meta } = await EventOfferService.getAllForAdmin(req.query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'All event offers fetched successfully',
    meta,
    data: result,
  });
});

const getById = catchAsync(async (req: Request, res: Response) => {
  const result = await EventOfferService.getById(req.params.id);
  if (!result) {
    return sendResponse(res, { statusCode: 404, success: false, message: 'Event offer not found' });
  }
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Event offer fetched successfully',
    data: result,
  });
});

// ──── Per-Shop Settings (Multi-tenant Toggling) ────
const toggleActive = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const eventOfferId = req.params.id;

  const result = await EventOfferService.upsertSubscription(userId, eventOfferId, req.body);
  
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: `Event status toggled successfully for your shop`,
    data: result,
  });
});

// ──── Template Updates (Only for own templates) ────
const updateByShopOwner = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const existing = await EventOfferService.getById(req.params.id);

  if (!existing) {
    return sendResponse(res, { statusCode: 404, success: false, message: 'Event offer not found' });
  }
  if (existing.createdBy !== 'shop_owner' || (existing.shopOwnerId && existing.shopOwnerId?._id?.toString() !== userId)) {
    return sendResponse(res, { statusCode: 403, success: false, message: 'Forbidden: You can only update the primary details of your own events' });
  }

  const result = await EventOfferService.updateById(req.params.id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Event offer template updated successfully',
    data: result,
  });
});

const updateByAdmin = catchAsync(async (req: Request, res: Response) => {
  const result = await EventOfferService.updateById(req.params.id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Event offer template updated successfully',
    data: result,
  });
});

const deleteByShopOwner = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const existing = await EventOfferService.getById(req.params.id);
  if (!existing || existing.createdBy !== 'shop_owner' || (existing.shopOwnerId && existing.shopOwnerId?._id?.toString() !== userId)) {
    return sendResponse(res, { statusCode: 403, success: false, message: 'Forbidden: You can only delete your own events' });
  }
  await EventOfferService.deleteById(req.params.id);
  sendResponse(res, { statusCode: 200, success: true, message: 'Event offer deleted successfully' });
});

const deleteByAdmin = catchAsync(async (req: Request, res: Response) => {
  await EventOfferService.deleteById(req.params.id);
  sendResponse(res, { statusCode: 200, success: true, message: 'Event offer deleted successfully' });
});

export const EventOfferController = {
  createByShopOwner,
  createByAdmin,
  getAllForShopOwner,
  getAllForAdmin,
  getById,
  updateByShopOwner,
  updateByAdmin,
  toggleActive,
  deleteByShopOwner,
  deleteByAdmin,
};
