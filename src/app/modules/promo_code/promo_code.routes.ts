import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { PromoCodeController } from './promo_code.controller';
import { PromoCodeValidation } from './promo_code.validation';
import { validateRequest } from '../../middlewares/validateRequest';

const router = express.Router();

router.post(
  '/',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(PromoCodeValidation.createPromoCodeSchema),
  PromoCodeController.createPromoCode
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(PromoCodeValidation.updatePromoCodeSchema),
  PromoCodeController.updatePromoCode
);

router.patch(
  '/:id/status',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(PromoCodeValidation.updatePromoCodeStatusSchema),
  PromoCodeController.updatePromoCodeStatus
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(PromoCodeValidation.deletePromoCodeSchema),
  PromoCodeController.deletePromoCode
);

router.get(
  '/',
  validateRequest(PromoCodeValidation.getPromoCodesSchema),
  PromoCodeController.getPromoCodes
);

router.post(
  '/customer', 
  PromoCodeController.getPromoCodesCustomer
);

router.post(
  '/validate',
  validateRequest(PromoCodeValidation.validatePromoCodeSchema),
  PromoCodeController.validatePromoCode
);

export const PromoCodeRoutes = router;