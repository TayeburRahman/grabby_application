import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import { ShopOwnerService } from './shop_owner.service';
import sendResponse from '../../../shared/sendResponse';
import { IReqUser } from '../auth/auth.interface';

// ─── Screen 3: Save Location ────────────────────────────────────────
const saveLocation = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.saveLocation(userId, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Location saved successfully.",
    data: result,
  });
});

// ─── Screen 4: Save Business Info ───────────────────────────────────
const saveBusinessInfo = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.saveBusinessInfo(userId, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Business information saved successfully.",
    data: result,
  });
});

// ─── Screen 5: Save Branches ────────────────────────────────────────
const saveBranches = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.saveBranches(userId, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Branches saved successfully.",
    data: result,
  });
});

// ─── Screen 6: Upload Documents ─────────────────────────────────────
const saveDocuments = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.saveDocuments(userId, req.files as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Documents uploaded successfully. Registration is pending admin approval.",
    data: result,
  });
});

// ─── Update Profile ────────────────────────────────────────────────
const updateProfile = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const files = req.files as { [key: string]: Express.Multer.File[] } | undefined;
  const profileImageFile = files?.profile_image?.[0];
  const result = await ShopOwnerService.updateProfile(userId, req.body, profileImageFile);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Profile updated successfully.",
    data: result,
  });
});

// ─── Create Branch ─────────────────────────────────────────────────
const createBranch = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.createBranch(userId, req.body);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: "Branch created successfully.",
    data: result,
  });
});

// ─── Get All Branches ───────────────────────────────────────────────
const getAllBranches = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.getAllBranches(userId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Branches retrieved successfully.",
    data: result,
  });
});

// ─── Get Branch Details ─────────────────────────────────────────────
const getBranchDetails = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.getBranchDetails(userId, req.params.branchId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Branch details retrieved successfully.",
    data: result,
  });
});

// ─── Delete Branch ─────────────────────────────────────────────────
const deleteBranch = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.deleteBranch(userId, req.params.branchId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

// ─── Update Branch Data ────────────────────────────────────────────
const updateBranch = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.updateBranch(userId, req.params.branchId, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Branch updated successfully.",
    data: result,
  });
});

// ─── Update Branch Availability ────────────────────────────────────
const updateBranchAvailability = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.updateBranchAvailability(
    userId,
    req.params.branchId,
    req.body
  );
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Branch availability updated successfully.",
    data: result,
  });
});

// ─── Toggle Reward Points ──────────────────────────────────────────
const toggleRewardPoints = catchAsync(async (req: Request, res: Response) => {
  const { userId } = req.user as IReqUser;
  const result = await ShopOwnerService.toggleRewardPoints(userId);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: `Reward points feature is now ${result.isRewardPointEnabled ? 'enabled' : 'disabled'}.`,
    data: result,
  });
});

export const ShopOwnerController = {
  saveLocation,
  saveBusinessInfo,
  saveBranches,
  saveDocuments,
  updateProfile,
  createBranch,
  getAllBranches,
  getBranchDetails,
  deleteBranch,
  updateBranch,
  updateBranchAvailability,
  toggleRewardPoints,
};
