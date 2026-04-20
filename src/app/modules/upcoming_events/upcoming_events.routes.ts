import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { uploadFile } from '../../middlewares/fileUploader';
import { validateRequest } from '../../middlewares/validateRequest';
import { UpcomingEventsController } from './upcoming_events.controller';
import { UpcomingEventsValidation } from './upcoming_events.validation';

const router = express.Router();

router.post(
  '/create',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  uploadFile(),
  validateRequest(UpcomingEventsValidation.createUpcomingEventZodSchema),
  UpcomingEventsController.create
);

router.get('/', UpcomingEventsController.getAll);

router.get('/:id', UpcomingEventsController.getById);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  uploadFile(),
  validateRequest(UpcomingEventsValidation.updateUpcomingEventZodSchema),
  UpcomingEventsController.update
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  UpcomingEventsController.remove
);

export const UpcomingEventsRoutes = router;
