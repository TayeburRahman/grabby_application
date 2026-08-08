import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import { AuthService } from './auth.service';
import sendResponse from '../../../shared/sendResponse';
import config from '../../../config';
import { IReqUser } from './auth.interface';

// ─── CUSTOMER REGISTER (Screen 1) ───────────────────────────────────
const registerCustomer = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.registerCustomer(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

// ─── SHOP OWNER REGISTER (Screen 1) ─────────────────────────────────
const registerShopOwner = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.registerShopOwner(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

// ─── VERIFY OTP (Screen 2) ──────────────────────────────────────────
const verifyOtp = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.verifyOtp({
    activation_code: req.body.activation_code,
    userEmail: req.body.email,
  });

  const cookieOptions = {
    secure: config.env === "production",
    httpOnly: true,
  };
  res.cookie("refreshToken", result.refreshToken, cookieOptions);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Account verified successfully.",
    data: result,
  });
});

// ─── RESEND OTP ─────────────────────────────────────────────────────
const resendOtp = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.resendOtp(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

// ─── LOGIN ──────────────────────────────────────────────────────────
const loginAccount = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.loginAccount(req.body);
  const cookieOptions = {
    secure: config.env === "production",
    httpOnly: true,
  };
  res.cookie("refreshToken", result.refreshToken, cookieOptions);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Logged in successfully!",
    data: result,
  });
});

// ─── FORGOT PASSWORD ────────────────────────────────────────────────
const forgotPass = catchAsync(async (req: Request, res: Response) => {
  await AuthService.forgotPass(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Check your email for the reset code!",
  });
});

// ─── VERIFY FORGOT PASSWORD OTP ─────────────────────────────────────
const verifyForgotOtp = catchAsync(async (req: Request, res: Response) => {
  await AuthService.checkIsValidForgetActivationCode(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Code verified successfully",
  });
});

// ─── RESEND FORGOT PASSWORD CODE ────────────────────────────────────
const resendForgotCode = catchAsync(async (req: Request, res: Response) => {
  await AuthService.resendCodeForgotAccount(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Code resent successfully",
  });
});

// ─── RESET PASSWORD ─────────────────────────────────────────────────
const resetPassword = catchAsync(async (req: Request, res: Response) => {
  await AuthService.resetPassword(req as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Password has been reset successfully.",
  });
});

// ─── CHANGE PASSWORD ────────────────────────────────────────────────
const changePassword = catchAsync(async (req: Request, res: Response) => {
  const user = req.user as IReqUser;
  await AuthService.changePassword(user, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Password changed successfully!",
  });
});

// ─── GET MY PROFILE ─────────────────────────────────────────────────
const getMyProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.myProfile(req.user as IReqUser);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Profile retrieved successfully",
    data: result,
  });
});

// ─── UPDATE MY PROFILE ──────────────────────────────────────────────
const updateMyProfile = catchAsync(async (req: Request, res: Response) => {
  const user = req.user as IReqUser;
  const result = await AuthService.updateMyProfile(user, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Profile updated successfully",
    data: result,
  });
});

export const AuthController = {
  registerCustomer,
  registerShopOwner,
  verifyOtp,
  resendOtp,
  loginAccount,
  forgotPass,
  verifyForgotOtp,
  resendForgotCode,
  resetPassword,
  changePassword,
  getMyProfile,
  updateMyProfile,
};
