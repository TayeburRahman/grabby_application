import { Request, Response } from "express";
import catchAsync from "../../../shared/catchasync";
import sendResponse from "../../../shared/sendResponse";
import { AdminService } from "./admin.service";

// ─── GET SHOP OWNER REQUESTS ───────────────────────────────────────
const getShopOwnerRequests = catchAsync(async (req: Request, res: Response) => {
  const { searchTerm, approval_status, page, limit, sortBy, sortOrder } =
    req.query as Record<string, string>;

  const result = await AdminService.getShopOwnerRequests(
    { searchTerm, approval_status },
    { page: Number(page), limit: Number(limit), sortBy, sortOrder: sortOrder as any }
  );

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Shop owner requests retrieved successfully",
    meta: result.meta,
    data: result.data,
  });
});

// ─── ACCEPT SHOP OWNER ─────────────────────────────────────────────
const acceptShopOwner = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.acceptShopOwner(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Shop owner approved successfully",
    data: result,
  });
});

// ─── REJECT SHOP OWNER ─────────────────────────────────────────────
const rejectShopOwner = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.rejectShopOwner(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Shop owner rejected successfully",
    data: result,
  });
});

// ─── BLOCK/UNBLOCK SHOP OWNER ──────────────────────────────────────
const blockedShopOwner = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.blockedShopOwner(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.is_block
      ? "Shop owner blocked successfully"
      : "Shop owner unblocked successfully",
    data: result,
  });
});

// ─── UPDATE SHOP OWNER DETAILS ─────────────────────────────────────
const updateShopOwnerDetails = catchAsync(
  async (req: Request, res: Response) => {
    const result = await AdminService.updateShopOwnerDetails(
      req.params.id,
      req.body
    );
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: "Shop owner details updated successfully",
      data: result,
    });
  }
);

// ─── CREATE ADMIN ───────────────────────────────────────────────────
const createAdmin = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.createAdmin(req.body);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: "Admin created successfully",
    data: result,
  });
});

// ─── UPDATE ADMIN PROFILE ───────────────────────────────────────────
const updateAdminProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.updateAdminProfile(req.params.id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Admin profile updated successfully",
    data: result,
  });
});

// ─── DELETE ADMIN ───────────────────────────────────────────────────
const deleteAdmin = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.deleteAdmin(req.params.id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
  });
});

// ─── GET ALL CUSTOMERS ──────────────────────────────────────────────
const getAllCustomers = catchAsync(async (req: Request, res: Response) => {
  const { searchTerm, status, page, limit, sortBy, sortOrder } =
    req.query as Record<string, string>;

  const result = await AdminService.getAllCustomers(
    { searchTerm, status },
    { page: Number(page), limit: Number(limit), sortBy, sortOrder: sortOrder as any }
  );

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Customers retrieved successfully",
    meta: result.meta,
    data: result.data,
  });
});

// ─── BLOCK/UNBLOCK CUSTOMER ────────────────────────────────────────
const blockedCustomer = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.blockedCustomer(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.is_block
      ? "Customer blocked successfully"
      : "Customer unblocked successfully",
    data: result,
  });
});

// ─── CUSTOMER DETAILS BY ID ────────────────────────────────────────
const getCustomerDetails = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.getCustomerDetails(req.params.id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Customer details retrieved successfully",
    data: result,
  });
});

// ─── CUSTOMER OVERVIEW ─────────────────────────────────────────────
const getCustomerOverview = catchAsync(async (req: Request, res: Response) => {
  const result = await AdminService.getCustomerOverview();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Customer overview retrieved successfully",
    data: result,
  });
});

// ─── GET ALL ADMINS ───────────────────────────────────────────────
const getAllAdmins = catchAsync(async (req: Request, res: Response) => {
  const { page, limit, sortBy, sortOrder } = req.query as Record<string, string>;
  const result = await AdminService.getAllAdmins({
    page: Number(page),
    limit: Number(limit),
    sortBy,
    sortOrder: sortOrder as any,
  });

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Admins retrieved successfully",
    meta: result.meta,
    data: result.data,
  });
});

export const AdminController = {
  getShopOwnerRequests,
  acceptShopOwner,
  rejectShopOwner,
  blockedShopOwner,
  updateShopOwnerDetails,
  createAdmin,
  updateAdminProfile,
  deleteAdmin,
  getAllCustomers,
  blockedCustomer,
  getCustomerDetails,
  getCustomerOverview,
  getAllAdmins,
};
