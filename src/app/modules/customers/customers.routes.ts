import express from "express";
import auth from "../../middlewares/auth";
import { ENUM_USER_ROLE } from "../../../enums/user";
import { CustomerController } from "./customers.controller";
import { CustomerValidation } from "./customers.validation";
import { validateRequest } from "../../middlewares/validateRequest";
import { uploadFile } from "../../middlewares/fileUploader";

const router = express.Router();

router.get(
  "/profile",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.getMyProfile
);

router.patch(
  "/profile",
  auth(ENUM_USER_ROLE.CUSTOMER),
  uploadFile(),
  validateRequest(CustomerValidation.updateCustomerSchema),
  CustomerController.updateProfile
);

router.patch(
  "/location",
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CustomerValidation.saveLocationSchema),
  CustomerController.saveLocation
);

router.get(
  "/branches",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.getBranches
);

router.get(
  "/branches/:id",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.getSingleBranch
);

router.post(
  "/convert-points",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.convertPoints
);

router.get(
  "/wallet",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.getWallet
);

export const CustomerRoutes = router;
