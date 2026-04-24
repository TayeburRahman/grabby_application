import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { CartController } from './cart.controller';
import { CartValidation } from './cart.validation';
import { validateRequest } from '../../middlewares/validateRequest';

const router = express.Router();

router.post(
  '/add',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CartValidation.addToCartSchema),
  CartController.addToCart
);

router.patch(
  '/item/:itemId',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CartValidation.updateCartItemSchema),
  CartController.updateCartItem
);

router.delete(
  '/item/:itemId',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CartValidation.removeFromCartSchema),
  CartController.removeFromCart
);

router.get(
  '/',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CartController.getCart
);

router.delete(
  '/clear',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CartValidation.clearCartSchema),
  CartController.clearCart
);

router.get(
  '/summary',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CartController.getCartSummary
);

router.post(
  '/apply-credit',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CartController.applyCredit
);

export const CartRoutes = router;