import express from "express";
import auth from "../../middlewares/auth";
import { ENUM_USER_ROLE } from "../../../enums/user";
import { AdminController } from "./admin.controller";
import { AdminValidation } from "./admin.validation";
import { validateRequest } from "../../middlewares/validateRequest";
import { MenuController } from "../menu/menu.controller";
import { MenuCategoryController } from "../menu_category/menu_category.controller";
import { ShopOwnerController } from "../shop_owner/shop_owner.controller";

const router = express.Router();

// ─── Shop Owner Management ─────────────────────────────────────────
router.get(
  "/shop_owner/request",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  AdminController.getShopOwnerRequests
);

router.patch(
  "/shop_owner/accept",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.acceptShopOwner),
  AdminController.acceptShopOwner
);

router.patch(
  "/shop_owner/reject",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.acceptShopOwner), // Using same validation for ID
  AdminController.rejectShopOwner
);

router.patch(
  "/shop_owner/blocked",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.blockedShopOwner),
  AdminController.blockedShopOwner
);

router.patch(
  "/shop_owner/details/:id",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.updateShopOwnerDetails),
  AdminController.updateShopOwnerDetails
);

// ─── Customer Management ────────────────────────────────────────────
router.get(
  "/customers",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  AdminController.getAllCustomers
);

router.patch(
  "/customer/blocked",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.blockedCustomer),
  AdminController.blockedCustomer
);

router.get(
  "/customer/overview",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  AdminController.getCustomerOverview
);

router.get(
  "/customer/:id",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.getCustomerDetails),
  AdminController.getCustomerDetails
);

router.get(
  "/all-products",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  MenuController.getAllForAdmin
);

router.get(
  "/all-categories",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  MenuCategoryController.getAll
);

router.get(
  "/all-branches",
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  ShopOwnerController.getAllBranches
);

router.get(
  '/all-shop-owners',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  ShopOwnerController.getAllShopOwners
);

// ─── Admin Management (Super Admin only) ───────────────────────────
router.get(
  "/",
  auth(ENUM_USER_ROLE.SUPER_ADMIN),
  AdminController.getAllAdmins
);

router.post(
  "/create",
  auth(ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.createAdmin),
  AdminController.createAdmin
);

router.patch(
  "/profile/:id",
  auth(ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.updateAdminProfile),
  AdminController.updateAdminProfile
);

router.delete(
  "/:id",
  auth(ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AdminValidation.deleteAdmin),
  AdminController.deleteAdmin
);

export const AdminRoutes = router;
