import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { ShopOwnerController } from './shop_owner.controller';
import { ShopOwnerValidation } from './shop_owner.validation';
import { validateRequest } from '../../middlewares/validateRequest';
import { uploadDocument, uploadFile } from '../../middlewares/fileUploader';

const router = express.Router();

// Screen 3: Save location
router.post(
  "/location",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.locationSchema),
  ShopOwnerController.saveLocation
);

// Screen 4: Save business info (Step 1/3)
router.post(
  "/business/info",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.businessInfoSchema),
  ShopOwnerController.saveBusinessInfo
);

// Screen 5: Save branches (Step 2/3)
router.post(
  "/business/branches",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.branchesSchema),
  ShopOwnerController.saveBranches
);

// Screen 6: Upload documents (Step 3/3)
router.post(
  "/business/documents",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  uploadDocument(),
  ShopOwnerController.saveDocuments
);

// ─── Update Profile (with optional profile_image upload) ───────────
router.patch(
  "/profile",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  uploadFile(),
  ShopOwnerController.updateProfile
);

// ─── Branch Management ─────────────────────────────────────────────
router.post(
  "/branch",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.createBranchSchema),
  ShopOwnerController.createBranch
);

router.get(
  "/branch",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  ShopOwnerController.getAllBranches
);

router.get(
  "/branch/:branchId",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.deleteBranchSchema),
  ShopOwnerController.getBranchDetails
);

router.delete(
  "/branch/:branchId",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.deleteBranchSchema),
  ShopOwnerController.deleteBranch
);

router.patch(
  "/branch/:branchId",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.updateBranchSchema),
  ShopOwnerController.updateBranch
);

router.patch(
  "/branch/:branchId/availability",
  auth(ENUM_USER_ROLE.SHOP_OWNER),
  validateRequest(ShopOwnerValidation.updateBranchAvailabilitySchema),
  ShopOwnerController.updateBranchAvailability
);

export const ShopOwnerRoutes = router;
