import mongoose from 'mongoose';
import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { MenuService } from './menu.service';
import { IReqUser } from '../auth/auth.interface';
import { Branch } from '../shop_owner/shop_owner.model';

const create = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;

  let image = '';
  if (req.files && 'image' in req.files && req.files['image'][0]) {
    image = `/images/image/${req.files['image'][0].filename}`;
  }

  if (!image) {
    return sendResponse(res, {
      statusCode: 400,
      success: false,
      message: 'Image is required',
    });
  }

  let additionalItems = [];
  if (req.body.additionalItems) {
    try {
      additionalItems =
        typeof req.body.additionalItems === 'string'
          ? JSON.parse(req.body.additionalItems)
          : req.body.additionalItems;
    } catch {
      additionalItems = [];
    }
  }

  const isStampActive = req.body.stampActive === 'true' || req.body.stampActive === true;

  const payload = {
    ...req.body,
    image,
    additionalItems,
    shopOwnerId: req.body.shopOwnerId || userId,
    price: Number(req.body.price),
    stampActive: isStampActive,
    stamp: isStampActive ? (req.body.stamp ? Number(req.body.stamp) : 10) : 0,
  };

  const result = await MenuService.create(payload);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Menu item created successfully',
    data: result,
  });
});

const getAll = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const categoryId = req.query.category as string | undefined;
  const { result, meta } = await MenuService.getAll(req.query, userId, categoryId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu items fetched successfully',
    meta,
    data: result,
  });
});



const getById = catchAsync(async (req: Request, res: Response) => {
  const result = await MenuService.getById(req.params.id);
  if (!result) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Menu item not found',
    });
  }
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu item fetched successfully',
    data: result,
  });
});

const getByCategory = catchAsync(async (req: Request, res: Response) => {
  const { branchId } = req.params;
  const menuCategoryId = req.query.menuCategoryId as string | undefined;

  const { result, meta } = await MenuService.getByCategory(menuCategoryId, branchId, req.query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu items fetched successfully',
    meta,
    data: result,
  });
});

const update = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const existing = await MenuService.getById(req.params.id);

  if (!existing) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Menu item not found',
    });
  }

  if (existing.shopOwnerId && existing.shopOwnerId?._id.toString() !== userId) {
    return sendResponse(res, {
      statusCode: 403,
      success: false,
      message: 'Forbidden: You can only update your own menu items',
    });
  }

  // Handle image upload
  let image: string | undefined;
  if (req.files && 'image' in req.files && req.files['image'][0]) {
    image = `/images/image/${req.files['image'][0].filename}`;
  }

  // Parse additionalItems from stringified JSON (multipart form)
  let additionalItems;
  if (req.body.additionalItems) {
    try {
      additionalItems =
        typeof req.body.additionalItems === 'string'
          ? JSON.parse(req.body.additionalItems)
          : req.body.additionalItems;
    } catch {
      additionalItems = undefined;
    }
  }

  const isStampActive =
    req.body.stampActive !== undefined
      ? req.body.stampActive === 'true' || req.body.stampActive === true
      : undefined;

  const payload: Record<string, any> = { ...req.body };
  if (image) payload.image = image;
  if (additionalItems !== undefined) payload.additionalItems = additionalItems;
  if (payload.price) payload.price = Number(payload.price);

  if (isStampActive !== undefined) {
    payload.stampActive = isStampActive;
    payload.stamp = isStampActive
      ? req.body.stamp
        ? Number(req.body.stamp)
        : 10
      : 0;
  } else if (payload.stamp) {
    payload.stamp = Number(payload.stamp);
  }

  const result = await MenuService.updateById(req.params.id, payload);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu item updated successfully',
    data: result,
  });
});

const remove = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const existing = await MenuService.getById(req.params.id);

  if (!existing) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Menu item not found',
    });
  }

  if (existing.shopOwnerId && existing.shopOwnerId?._id.toString() !== userId) {
    return sendResponse(res, {
      statusCode: 403,
      success: false,
      message: 'Forbidden: You can only delete your own menu items',
    });
  }

  await MenuService.deleteById(req.params.id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Menu item deleted successfully',
  });
});

const uploadImage = catchAsync(async (req: Request, res: Response) => {
  let image = '';
  if (req.files && 'image' in req.files && req.files['image'][0]) {
    image = `/images/image/${req.files['image'][0].filename}`;
  }

  if (!image) {
    return sendResponse(res, {
      statusCode: 400,
      success: false,
      message: 'No image provided',
    });
  }

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Image uploaded successfully',
    data: { url: image },
  });
});



const getAllForAdmin = catchAsync(async (req: Request, res: Response) => {
  const categoryId = req.query.category as string | undefined;
  const branchId = req.query.branch as string | undefined;
  const shopId = req.query.shop as string | undefined;

  let shopOwnerId = undefined;

  if (shopId && shopId !== 'all' && mongoose.Types.ObjectId.isValid(shopId)) {
    shopOwnerId = shopId;
  } else if (branchId && branchId !== 'all' && mongoose.Types.ObjectId.isValid(branchId)) {
    const branch = await Branch.findById(branchId);
    if (branch) {
      shopOwnerId = branch.shopOwnerId.toString();
    }
  }

  const { result, meta } = await MenuService.getAll(req.query, shopOwnerId, categoryId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'All menu items fetched successfully',
    meta,
    data: result,
  });
});

export const MenuController = {
  uploadImage,
  create,
  getAll,
  getAllForAdmin,
  getById,
  getByCategory,
  update,
  remove,
};
