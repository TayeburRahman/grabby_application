import express from 'express';
import { DashboardController } from './dashboard.controller';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';

const router = express.Router();

router.get(
  '/shop-owner',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  DashboardController.getShopOwnerDashboardStats
);

router.get(
  '/admin',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getAdminDashboardStats
);

export const DashboardRoutes = router;
