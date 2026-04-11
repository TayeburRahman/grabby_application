import express from 'express';
import auth from '../../middlewares/auth';
import { validateRequest } from '../../middlewares/validateRequest';
import { MenuCategoryController } from './menu_category.controller';
import { MenuCategoryValidation } from './menu_category.validation';
import { ENUM_USER_ROLE } from '../../../enums/user';

const router = express.Router();

router.post(
  '/create',
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(MenuCategoryValidation.createSchema),
  MenuCategoryController.create
);

router.get('/shop', auth(ENUM_USER_ROLE.SHOP_OWNER), MenuCategoryController.getByShopOwner);

router.get('/branch/:branchId', MenuCategoryController.getByBranch);

router.put('/:id', auth(ENUM_USER_ROLE.SHOP_OWNER), validateRequest(MenuCategoryValidation.createSchema), MenuCategoryController.update);

router.delete('/:id', auth(ENUM_USER_ROLE.SHOP_OWNER), MenuCategoryController.remove);

export const MenuCategoryRoutes = router;
