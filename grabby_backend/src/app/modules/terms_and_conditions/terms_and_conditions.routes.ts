import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { TermsAndConditionsController } from './terms_and_conditions.controller';

const router = express.Router();

router.get('/', TermsAndConditionsController.getTermsAndConditions);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  TermsAndConditionsController.createOrUpdateTermsAndConditions
);

export const TermsAndConditionsRoutes = router;
