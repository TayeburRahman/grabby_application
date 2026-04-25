import express from 'express';
import { OrderController } from './order.controller';
import { OrderValidation } from './order.validation';
import { validateRequest } from '../../middlewares/validateRequest';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';

const router = express.Router();

router.post(
  '/',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(OrderValidation.createOrderSchema),
  OrderController.createOrder
);

router.get(
  '/my-orders',
  auth(ENUM_USER_ROLE.CUSTOMER),
  OrderController.getMyOrders
);

router.get(
  '/branch/:branchId',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  OrderController.getBranchOrders
);

router.get(
  '/:id',
  auth(ENUM_USER_ROLE.CUSTOMER, ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  OrderController.getSingleOrder
);

router.patch(
  '/:id/status',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(OrderValidation.updateOrderStatusSchema),
  OrderController.updateOrderStatus
);

router.patch(
  '/:id/cancel',
  auth(ENUM_USER_ROLE.CUSTOMER),
  OrderController.cancelOrder
);

router.patch(
  '/:id/location',
  auth(ENUM_USER_ROLE.CUSTOMER),
  OrderController.updateOrderLocation
);

export const OrderRoutes = router;
