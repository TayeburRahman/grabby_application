import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { CarPlateController } from './car_plates.controller';
import { CarPlateValidation } from './car_plates.validation';
import { validateRequest } from '../../middlewares/validateRequest';

const router = express.Router();

router.post(
  '/',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CarPlateValidation.createCarPlateSchema),
  CarPlateController.createCarPlate
);

router.get(
  '/',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CarPlateController.getCarPlates
);

router.get(
  '/:id',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CarPlateController.getSingleCarPlate
);

router.patch(
  '/:id',
  auth(ENUM_USER_ROLE.CUSTOMER),
  validateRequest(CarPlateValidation.updateCarPlateSchema),
  CarPlateController.updateCarPlate
);

router.delete(
  '/:id',
  auth(ENUM_USER_ROLE.CUSTOMER),
  CarPlateController.deleteCarPlate
);

export const CarPlateRoutes = router;