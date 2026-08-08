import express from "express";
import auth from "../../middlewares/auth";
import { ENUM_USER_ROLE } from "../../../enums/user";
import { CustomerController } from "./customers.controller";

const router = express.Router();

router.get(
  "/details/:id",
  auth(ENUM_USER_ROLE.CUSTOMER),
  CustomerController.getBranchDetails
);

export const BranchRoutes = router;
