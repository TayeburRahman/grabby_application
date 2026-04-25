import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { ShopOwnerPlanController } from './shop_owner_plan.controller';

const router = express.Router();

// Customer/Public side: Get 4 random nearby advertised branches
router.get('/ads', ShopOwnerPlanController.getAdvertisedBranches);

// Shop Owner side: Purchase a plan (dummy data/free for now)
router.post(
  '/purchase',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  ShopOwnerPlanController.purchasePlan
);

export const ShopOwnerPlanRoutes = router;
