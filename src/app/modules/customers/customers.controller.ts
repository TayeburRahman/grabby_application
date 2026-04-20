import httpStatus from "http-status";
import catchAsync from "../../../shared/catchasync";
import sendResponse from "../../../shared/sendResponse";
import { CustomerService } from "./customers.service";

const getMyProfile = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const result = await CustomerService.getMyProfile(userId);
  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Profile retrieved successfully",
    data: result,
  });
});

const updateProfile = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const payload = req.body;
  const files = req.files as { [fieldname: string]: Express.Multer.File[] } | undefined;
  const profileImageFile = files?.profile_image?.[0];

  const result = await CustomerService.updateProfile(userId, payload, profileImageFile);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Profile updated successfully",
    data: result,
  });
});

/**
 * Get branches for the customer.
 * Uses query parameters lat/lon, or coordinates from customer profile.
 */
const getBranches = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const customer = await CustomerService.getMyProfile(userId);

  // Use provided lat/lon or default to customer's saved location
  const lat = req.query.lat ? Number(req.query.lat) : (customer.lat || undefined);
  const lon = req.query.lon ? Number(req.query.lon) : (customer.lon || undefined);

  if (!lat || !lon) {
    return sendResponse(res, {
      statusCode: httpStatus.OK, // or you can use httpStatus.BAD_REQUEST depending on your frontend logic
      success: false,
      message: "Please add your location to see nearby branches",
      data: [],
    });
  }

  const result = await CustomerService.getBranchesForCustomer(lat, lon);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Branches retrieved successfully",
    data: result,
  });
});

const saveLocation = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const payload = req.body;

  const result = await CustomerService.saveLocation(userId, payload);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Location updated successfully",
    data: result,
  });
});

const getSingleBranch = catchAsync(async (req, res) => {
  const branchId = req.params.id;
  const userId = req.user?.userId as string;
  const customer = await CustomerService.getMyProfile(userId);

  const lat = req.query.lat ? Number(req.query.lat) : (customer.lat || undefined);
  const lon = req.query.lon ? Number(req.query.lon) : (customer.lon || undefined);
  const categoryId = req.query.categoryId as string | undefined;
  const customerAuthId = req.user?.authId?.toString();

  const result = await CustomerService.getSingleBranch(branchId, lat, lon, categoryId, req.query, customerAuthId);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Branch details retrieved successfully",
    data: result.branch,
    meta: result.meta || undefined,
  });
});

const getBranchDetails = catchAsync(async (req, res) => {
  const branchId = req.params.id;
  const userId = req.user?.userId as string;
  const customer = await CustomerService.getMyProfile(userId);

  const lat = req.query.lat ? Number(req.query.lat) : (customer.lat || undefined);
  const lon = req.query.lon ? Number(req.query.lon) : (customer.lon || undefined);

  const result = await CustomerService.getBranchDetailsBrief(branchId, lat, lon);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Branch brief details retrieved successfully",
    data: result,
  });
});

export const CustomerController = {
  getMyProfile,
  updateProfile,
  saveLocation,
  getBranches,
  getSingleBranch,
  getBranchDetails,
};
