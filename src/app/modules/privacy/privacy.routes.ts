import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { PrivacyController } from './privacy.controller';

const router = express.Router();

router.get('/', PrivacyController.getPrivacy);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  PrivacyController.createOrUpdatePrivacy
);

export const PrivacyRoutes = router;
