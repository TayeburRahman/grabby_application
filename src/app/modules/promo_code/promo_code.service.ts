import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { PromoCode } from './promo_code.model';
import { Branch } from '../shop_owner/shop_owner.model';

const createPromoCode = async (userId: string, payload: any) => {
  if (Array.isArray(payload)) {
    // Bulk creation
    const promoCodesToCreate = [];

    for (const promoCodeData of payload) {
      const { code, status, branchIds } = promoCodeData;

      // If branchIds is 'all', get all branch IDs for the shop owner
      let finalBranchIds = branchIds;
      if (branchIds === 'all') {
        const branches = await Branch.find({ shopOwnerId: userId }).select('_id');
        finalBranchIds = branches.map(b => b._id);
      }

      promoCodesToCreate.push({
        code,
        shopOwnerId: userId,
        status: status || 'active',
        branchIds: finalBranchIds,
      });
    }

    const promoCodes = await PromoCode.insertMany(promoCodesToCreate);
    return promoCodes;
  } else {
    // Single creation
    const { code, status, branchIds } = payload;

    // If branchIds is 'all', get all branch IDs for the shop owner
    let finalBranchIds = branchIds;
    if (branchIds === 'all') {
      const branches = await Branch.find({ shopOwnerId: userId }).select('_id');
      finalBranchIds = branches.map(b => b._id);
    }

    const promoCode = await PromoCode.create({
      code,
      shopOwnerId: userId,
      status,
      branchIds: finalBranchIds,
    });

    return promoCode;
  }
};

const updatePromoCode = async (userId: string, id: string, payload: any) => {
  const promoCode = await PromoCode.findOne({ _id: id, shopOwnerId: userId });
  if (!promoCode) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Promo code not found');
  }

  const { branchIds } = payload;
  let finalBranchIds = branchIds;
  if (branchIds === 'all') {
    const branches = await Branch.find({ shopOwnerId: userId }).select('_id');
    finalBranchIds = branches.map(b => b._id);
  }

  const updatedPromoCode = await PromoCode.findByIdAndUpdate(id, { ...payload, branchIds: finalBranchIds }, {
    new: true,
    runValidators: true,
  });

  return updatedPromoCode;
};

const updatePromoCodeStatus = async (userId: string, id: string, status: string) => {
  const promoCode = await PromoCode.findOne({ _id: id, shopOwnerId: userId });
  if (!promoCode) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Promo code not found');
  }

  const updatedPromoCode = await PromoCode.findByIdAndUpdate(id, { status }, {
    new: true,
    runValidators: true,
  });

  return updatedPromoCode;
};

const deletePromoCode = async (userId: string, id: string) => {
  const promoCode = await PromoCode.findOne({ _id: id, shopOwnerId: userId });
  if (!promoCode) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Promo code not found');
  }

  await PromoCode.findByIdAndDelete(id);
  return { message: 'Promo code deleted successfully' };
};

const getPromoCodes = async (query: any) => {
  const { shopOwnerId, branchId, code, status } = query;

  let filter: any = {};

  if (shopOwnerId) {
    filter.shopOwnerId = shopOwnerId;
  }

  if (branchId) {
    filter.$or = [
      { branchIds: branchId },
      { branchIds: 'all' },
    ];
  }

  if (code) {
    filter.code = { $regex: code, $options: 'i' }; // Case-insensitive search
  }

  if (status) {
    filter.status = status;
  }

  const promoCodes = await PromoCode.find(filter).populate('shopOwnerId', 'name email');
  return promoCodes;
};

const validatePromoCode = async (code: string, branchId: string) => {
  const promoCode = await PromoCode.findOne({
    code,
    status: 'active',
    $or: [
      { branchIds: branchId },
      { branchIds: 'all' },
    ],
  });

  return {
    isValid: !!promoCode,
    code: promoCode?.code || null,
    status: promoCode?.status || null,
    branchIds: promoCode?.branchIds || null,
    message: promoCode ? 'Promo code is valid' : 'Promo code is not valid or inactive',
  };
};

const getPromoCodesCustomer = async (query: any) => {
  const { branchId } = query;
  let filter: any = {};

  if (branchId) {
    filter.branchIds = branchId;
  }
  
  const promoCodes = await PromoCode.find(filter).select('status branchId');

  return promoCodes;
};
 
export const PromoCodeService = {
  createPromoCode,
  updatePromoCode,
  updatePromoCodeStatus,
  deletePromoCode,
  getPromoCodes,
  validatePromoCode,
  getPromoCodesCustomer
};