import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { TermsAndConditionsController } from './terms_and_conditions.controller';

const router = express.Router();

router.get('/', TermsAndConditionsController.getAllTermsAndConditions);
router.get('/:id', TermsAndConditionsController.getSingleTermsAndConditions);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  TermsAndConditionsController.createTermsAndConditions
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  TermsAndConditionsController.updateTermsAndConditions
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  TermsAndConditionsController.deleteTermsAndConditions
);

export const TermsAndConditionsRoutes = router;
