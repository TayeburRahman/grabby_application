import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { AuthController } from './auth.controller';
import { AuthValidation } from './auth.validation';
import { validateRequest } from '../../middlewares/validateRequest';

const router = express.Router();

// ─── Customer Auth ──────────────────────────────────────────────────
router.post(
  "/customer/register",
  validateRequest(AuthValidation.registerCustomer),
  AuthController.registerCustomer
);

// ─── Shop Owner Auth ────────────────────────────────────────────────
router.post(
  "/shop-owner/register",
  validateRequest(AuthValidation.registerShopOwner),
  AuthController.registerShopOwner
);

// ─── Shared Auth Routes ─────────────────────────────────────────────
router.post(
  "/verify-otp",
  validateRequest(AuthValidation.verifyOtp),
  AuthController.verifyOtp
);

router.post(
  "/resend-otp",
  validateRequest(AuthValidation.resendOtp),
  AuthController.resendOtp
);

router.post(
  "/login",
  validateRequest(AuthValidation.loginZodSchema),
  AuthController.loginAccount
);

router.post(
  "/forgot-password",
  validateRequest(AuthValidation.forgotPasswordSchema),
  AuthController.forgotPass
);

router.post(
  "/verify-forgot-otp",
  validateRequest(AuthValidation.verifyForgotOtp),
  AuthController.verifyForgotOtp
);

router.post(
  "/resend-forgot-code",
  validateRequest(AuthValidation.resendOtp),
  AuthController.resendForgotCode
);

router.post(
  "/reset-password",
  validateRequest(AuthValidation.resetPasswordSchema),
  AuthController.resetPassword
);

router.patch(
  "/change-password",
  auth(ENUM_USER_ROLE.CUSTOMER, ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(AuthValidation.changePasswordSchema),
  AuthController.changePassword
);

router.get(
  "/profile",
  auth(ENUM_USER_ROLE.CUSTOMER, ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  AuthController.getMyProfile
);

router.patch(
  "/profile",
  auth(ENUM_USER_ROLE.CUSTOMER, ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  AuthController.updateMyProfile
);

export const AuthRoutes = router;
