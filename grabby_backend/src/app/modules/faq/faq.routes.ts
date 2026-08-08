import express from 'express';
import { ENUM_USER_ROLE } from '../../../enums/user';
import auth from '../../middlewares/auth';
import { validateRequest } from '../../middlewares/validateRequest';
import { FaqController } from './faq.controller';
import { FaqValidation } from './faq.validation';

const router = express.Router();

router.get('/', FaqController.getAllFaqs);
router.get('/:id', FaqController.getSingleFaq);

router.post(
  '/',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(FaqValidation.createFaqZodSchema),
  FaqController.createFaq
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  validateRequest(FaqValidation.updateFaqZodSchema),
  FaqController.updateFaq
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  FaqController.deleteFaq
);

export const FaqRoutes = router;
