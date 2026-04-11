import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { MenuCategoryService } from './menu_category.service';
import { IReqUser } from '../auth/auth.interface';

const create = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const payload = { ...req.body };
  if (!payload.shopOwnerId) payload.shopOwnerId = userId as any;
  const result = await MenuCategoryService.create(payload);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Menu category created successfully',
    data: result,
  });
});

const getByShopOwner = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await MenuCategoryService.findByShopOwner(userId as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu categories fetched successfully',
    data: result,
  });
});

const update = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const category = await MenuCategoryService.findById(req.params.id);
  if (!category) {
    return sendResponse(res, { statusCode: 404, success: false, message: 'Category not found' });
  }
  if (category.shopOwnerId && category.shopOwnerId.toString() !== userId) {
    return sendResponse(res, { statusCode: 403, success: false, message: 'Forbidden' });
  }
  const result = await MenuCategoryService.updateById(req.params.id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu category updated successfully',
    data: result,
  });
});

const remove = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const category = await MenuCategoryService.findById(req.params.id);
  if (!category) {
    return sendResponse(res, { statusCode: 404, success: false, message: 'Category not found' });
  }
  if (category.shopOwnerId && category.shopOwnerId.toString() !== userId) {
    return sendResponse(res, { statusCode: 403, success: false, message: 'Forbidden' });
  }
  await MenuCategoryService.deleteById(req.params.id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu category deleted successfully',
  });
});

const getByBranch = catchAsync(async (req: Request, res: Response) => {
  const result = await MenuCategoryService.findByBranch(req.params.branchId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu categories fetched successfully',
    data: result,
  });
});

export const MenuCategoryController = {
  create,
  getByShopOwner,
  getByBranch,
  update,
  remove,
};
