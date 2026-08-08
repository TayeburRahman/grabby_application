import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { validateRequest } from '../../middlewares/validateRequest';
import { FreeStructureController } from './free_structure.controller';
import { FreeStructureValidation } from './free_structure.validation';

const router = express.Router();

router.get('/', FreeStructureController.getAllFreeStructures);
router.get('/:id', FreeStructureController.getSingleFreeStructure);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(FreeStructureValidation.createFreeStructureZodSchema),
  FreeStructureController.createFreeStructure
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(FreeStructureValidation.updateFreeStructureZodSchema),
  FreeStructureController.updateFreeStructure
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  FreeStructureController.deleteFreeStructure
);

export const FreeStructureRoutes = router;
