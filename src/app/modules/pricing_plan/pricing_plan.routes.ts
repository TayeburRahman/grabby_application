import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { validateRequest } from '../../middlewares/validateRequest';
import { PricingPlanController } from './pricing_plan.controller';
import { PricingPlanValidation } from './pricing_plan.validation';

const router = express.Router();

router.get('/', PricingPlanController.getAllPricingPlans);
router.get('/:id', PricingPlanController.getSinglePricingPlan);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PricingPlanValidation.createPricingPlanZodSchema),
  PricingPlanController.createPricingPlan
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PricingPlanValidation.updatePricingPlanZodSchema),
  PricingPlanController.updatePricingPlan
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  PricingPlanController.deletePricingPlan
);

export const PricingPlanRoutes = router;
