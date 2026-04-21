import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import { CartService } from './cart.service';
import sendResponse from '../../../shared/sendResponse';
import { IReqUser } from '../auth/auth.interface';

const addToCart = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await CartService.addToCart(userId, req.body);

  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Item added to cart successfully',
    data: result,
  });
});

const updateCartItem = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { itemId } = req.params;
  const result = await CartService.updateCartItem(userId, itemId, req.body);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Cart item updated successfully',
    data: result,
  });
});

const removeFromCart = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { itemId } = req.params;
  const result = await CartService.removeFromCart(userId, itemId);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Item removed from cart successfully',
    data: result,
  });
});

const getCart = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { branchId } = req.query;
  const result = await CartService.getCart(userId, branchId as string);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Cart retrieved successfully',
    data: result,
  });
});

const clearCart = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { branchId } = req.body;
  const result = await CartService.clearCart(userId, branchId);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
    data: result,
  });
});

const getCartSummary = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const { branchId } = req.query;
  const result = await CartService.getCartSummary(userId, branchId as string);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Cart summary retrieved successfully',
    data: result,
  });
});

export const CartController = {
  addToCart,
  updateCartItem,
  removeFromCart,
  getCart,
  clearCart,
  getCartSummary,
};