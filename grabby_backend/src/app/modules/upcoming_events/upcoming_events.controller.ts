import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { UpcomingEventsService } from './upcoming_events.service';

const create = catchAsync(async (req: Request, res: Response) => {
  let icons: string[] = [];
  if (req.files && 'image' in req.files) {
    const files = req.files['image'] as Express.Multer.File[];
    icons = files.map(file => `/images/image/${file.filename}`);
  }

  const payload = {
    ...req.body,
    icons,
  };

  const result = await UpcomingEventsService.create(payload);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Upcoming event created successfully',
    data: result,
  });
});

const getAll = catchAsync(async (req: Request, res: Response) => {
  const { result, meta } = await UpcomingEventsService.getAll(req.query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Upcoming events fetched successfully',
    meta,
    data: result,
  });
});

const getById = catchAsync(async (req: Request, res: Response) => {
  const result = await UpcomingEventsService.getById(req.params.id);
  if (!result) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Upcoming event not found',
    });
  }
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Upcoming event fetched successfully',
    data: result,
  });
});

const update = catchAsync(async (req: Request, res: Response) => {
  let icons: string[] | undefined;
  if (req.files && 'image' in req.files) {
    const files = req.files['image'] as Express.Multer.File[];
    icons = files.map(file => `/images/image/${file.filename}`);
  }

  const payload = {
    ...req.body,
  };

  if (icons && icons.length > 0) {
    payload.icons = icons;
  }

  const result = await UpcomingEventsService.updateById(req.params.id, payload);
  if (!result) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Upcoming event not found',
    });
  }
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Upcoming event updated successfully',
    data: result,
  });
});

const remove = catchAsync(async (req: Request, res: Response) => {
  const result = await UpcomingEventsService.deleteById(req.params.id);
  if (!result) {
    return sendResponse(res, {
      statusCode: 404,
      success: false,
      message: 'Upcoming event not found',
    });
  }
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Upcoming event deleted successfully',
  });
});

export const UpcomingEventsController = {
  create,
  getAll,
  getById,
  update,
  remove,
};
