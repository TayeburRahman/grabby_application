import express from 'express';
import auth from '../../middlewares/auth';
import { validateRequest } from '../../middlewares/validateRequest';
import { EventOfferController } from './event_offer.controller';
import { EventOfferValidation } from './event_offer.validation';
import { ENUM_USER_ROLE } from '../../../enums/user';

const router = express.Router();

// ──── Shop Owner Routes ────
router.post(
  '/create',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(EventOfferValidation.createSchema),
  EventOfferController.createByShopOwner
);

router.get(
  '/shop',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  EventOfferController.getAllForShopOwner
);

router.patch(
  '/shop/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(EventOfferValidation.updateSchema),
  EventOfferController.updateByShopOwner
);

router.patch(
  '/toggle/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(EventOfferValidation.toggleActiveSchema),
  EventOfferController.toggleActive
);

router.delete(
  '/shop/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  EventOfferController.deleteByShopOwner
);

// ──── Admin Routes ────
router.post(
  '/admin/create',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(EventOfferValidation.createSchema),
  EventOfferController.createByAdmin
);

router.get(
  '/admin',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  EventOfferController.getAllForAdmin
);

router.patch(
  '/admin/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(EventOfferValidation.updateSchema),
  EventOfferController.updateByAdmin
);

router.delete(
  '/admin/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  EventOfferController.deleteByAdmin
);

// ──── Common ────
router.get(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  EventOfferController.getById
);

export const EventOfferRoutes = router;
