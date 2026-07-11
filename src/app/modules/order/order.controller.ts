import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { OrderService } from './order.service';
import { Order } from './order.model';
import { IReqUser } from '../auth/auth.interface';

const createOrder = catchAsync(async (req: Request, res: Response) => {
  const { userId, authId } = req.user as IReqUser;
  const result = await OrderService.createOrder(userId, authId, req.body);

  sendResponse(res, {
    statusCode: httpStatus.CREATED,
    success: true,
    message: 'Order created successfully',
    data: result,
  });
});

const getMyOrders = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await OrderService.getMyOrders(userId, req.query);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Orders retrieved successfully',
    meta: result.meta,
    data: result.data,
  });
});

const getSingleOrder = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await OrderService.getSingleOrder(id);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Order retrieved successfully',
    data: result,
  });
});

const updateOrderStatus = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const { status } = req.body;
  const result = await OrderService.updateOrderStatus(id, status);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Order status updated successfully',
    data: result,
  });
});

const getBranchOrders = catchAsync(async (req: Request, res: Response) => {
  const { branchId } = req.params;
  const result = await OrderService.getBranchOrders(branchId, req.query);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Branch orders retrieved successfully',
    meta: result.meta,
    data: result.data,
  });
});

const getAllOrders = catchAsync(async (req: Request, res: Response) => {
  const result = await OrderService.getAllOrders(req.query);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'All orders retrieved successfully',
    meta: result.meta,
    data: result.data,
  });
});

const cancelOrder = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { id } = req.params;
  const { cancelNote, cancelStatus } = req.body;
  const result = await OrderService.cancelOrder(id, userId, cancelNote, cancelStatus);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Cancel request sent successfully',
    data: result,
  });
});

const respondCancelRequest = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const { action } = req.body;
  const result = await OrderService.respondCancelRequest(id, action);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: `Cancel request ${action}ed successfully`,
    data: result,
  });
});

const updateOrderLocation = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await OrderService.updateOrderLocation(id, req.body);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Location updated successfully',
    data: result,
  });
});

const updateOrderNearbyStatus = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { id } = req.params;
  const result = await OrderService.updateOrderNearbyStatus(id, userId);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Order nearby status updated successfully',
    data: result,
  });
});

const handlePaymentWebhook = catchAsync(async (req: Request, res: Response) => {
  const payload = req.body;

  if (payload.type === 'checkout.session.completed') {
    const session = payload.data.object;
    const orderId = session.client_reference_id || session.metadata?.orderId;
    const transactionNo = session.payment_intent || session.id;

    if (orderId) {
      await OrderService.confirmPayment(orderId, transactionNo, session);
    }
  }

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Webhook processed successfully',
    data: null,
  });
});

const verifyPayment = catchAsync(async (req: Request, res: Response) => {
  const { orderId } = req.params;
  const result = await Order.findOne({ orderId });

  if (!result) {
    return sendResponse(res, {
      statusCode: httpStatus.NOT_FOUND,
      success: false,
      message: 'Order not found',
      data: null,
    });
  }

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'Payment verification status retrieved successfully',
    data: {
      orderId: result.orderId,
      paymentStatus: result.paymentStatus,
      transactionId: result.transactionId,
      referenceToken: result.referenceToken,
    },
  });
});

export const OrderController = {
  createOrder,
  getMyOrders,
  getSingleOrder,
  getBranchOrders,
  getAllOrders,
  updateOrderStatus,
  cancelOrder,
  respondCancelRequest,
  updateOrderLocation,
  updateOrderNearbyStatus,
  handlePaymentWebhook,
  verifyPayment,
};
