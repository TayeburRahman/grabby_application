import express from "express";
import { CustomerStampController } from "./customer_stamps.controller";
import auth from "../../middlewares/auth";
import { ENUM_USER_ROLE } from "../../../enums/user";

const router = express.Router();

router.get(
  "/check-eligibility",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerStampController.checkEligibility
);

router.get(
  "/branch/:branchId",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerStampController.getCustomerStampsByBranch
);

router.post(
  "/add",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerStampController.addStamp
);

export const CustomerStampRoutes = router;
