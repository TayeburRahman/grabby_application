import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { HelpCenterController } from './help_center.controller';

const router = express.Router();

router.get('/', HelpCenterController.getAllHelpCenters);
router.get('/:id', HelpCenterController.getSingleHelpCenter);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  HelpCenterController.createHelpCenter
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  HelpCenterController.updateHelpCenter
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  HelpCenterController.deleteHelpCenter
);

export const HelpCenterRoutes = router;
