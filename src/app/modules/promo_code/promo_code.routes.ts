import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { PromoCodeController } from './promo_code.controller';
import { PromoCodeValidation } from './promo_code.validation';
import { validateRequest } from '../../middlewares/validateRequest';

const router = express.Router();

router.post(
  '/',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PromoCodeValidation.createPromoCodeSchema),
  PromoCodeController.createPromoCode
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PromoCodeValidation.updatePromoCodeSchema),
  PromoCodeController.updatePromoCode
);

router.patch(
  '/:id/status',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PromoCodeValidation.updatePromoCodeStatusSchema),
  PromoCodeController.updatePromoCodeStatus
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(PromoCodeValidation.deletePromoCodeSchema),
  PromoCodeController.deletePromoCode
);

router.get(
  '/',
  validateRequest(PromoCodeValidation.getPromoCodesSchema),
  PromoCodeController.getPromoCodes
);

router.get(
  '/customer',
  PromoCodeController.getPromoCodesCustomer
);

router.post(
  '/validate',
  validateRequest(PromoCodeValidation.validatePromoCodeSchema),
  PromoCodeController.validatePromoCode
);

export const PromoCodeRoutes = router;