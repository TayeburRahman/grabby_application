import express from 'express';
import auth from '../../middlewares/auth';
import { MenuController } from './menu.controller';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { uploadFile } from '../../middlewares/fileUploader';

const router = express.Router();

// ──── Shop Owner Routes ────
router.post(
  '/upload-image',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  uploadFile(),
  MenuController.uploadImage
);

router.post(
  '/create',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  uploadFile(),
  MenuController.create
);

router.get(
  '/shop',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  MenuController.getAll
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  uploadFile(),
  MenuController.update
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  MenuController.remove
);

// ──── Public / Customer Routes ────
router.get(
  '/public',
  MenuController.getAllPublic
);

router.get(
  '/category/:categoryId',
  MenuController.getByCategory
);

router.get(
  '/:id',
  MenuController.getById
);

export const MenuRoutes = router;
