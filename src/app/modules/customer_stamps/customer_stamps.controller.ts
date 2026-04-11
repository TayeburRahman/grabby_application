import httpStatus from "http-status";
import catchAsync from "../../../shared/catchasync";
import sendResponse from "../../../shared/sendResponse";
import { CustomerStampService } from "./customer_stamps.service";

const getCustomerStampsByBranch = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const branchId = req.params.branchId;

  const result = await CustomerStampService.getCustomerStampsByBranch(userId, branchId);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Customer stamps retrieved successfully",
    data: result,
  });
});

const addStamp = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const { branchId, stamps } = req.body;

  const result = await CustomerStampService.addStamp(userId, branchId, stamps || 1);

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Stamp added successfully",
    data: result,
  });
});

const checkEligibility = catchAsync(async (req, res) => {
  const userId = req.user?.userId as string;
  const { branchId, menuId, stamps } = req.query;

  const result = await CustomerStampService.checkEligibility(
    userId,
    branchId as string,
    menuId as string,
    Number(stamps || 0)
  );

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: "Eligibility checked successfully",
    data: result,
  });
});


export const CustomerStampController = {
  getCustomerStampsByBranch,
  addStamp,
  checkEligibility,
};
