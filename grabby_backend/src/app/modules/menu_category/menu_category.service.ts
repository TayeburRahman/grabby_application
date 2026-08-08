import { Branch } from '../shop_owner/shop_owner.model';
import { IMenuCategory } from './menu_category.interface';
import { MenuCategory } from './menu_category.model';

const create = async (payload: IMenuCategory): Promise<IMenuCategory> => {
  const result = await MenuCategory.create(payload);
  return result;
};

const findByShopOwner = async (shopOwnerId: string) => {
  const result = await MenuCategory.find({ shopOwnerId });
  return result;
};

const findByBranch = async (branchId: string) => {
  const branch = await Branch.findById(branchId);
  if (!branch) {
    return [];
  }
  const result = await MenuCategory.find({ shopOwnerId: branch.shopOwnerId });
  return result;
};

const findById = async (id: string) => {
  const result = await MenuCategory.findById(id);
  return result;
};

const updateById = async (id: string, payload: Partial<IMenuCategory>) => {
  const result = await MenuCategory.findByIdAndUpdate(id, payload, { new: true });
  return result;
};

const deleteById = async (id: string) => {
  const result = await MenuCategory.findByIdAndDelete(id);
  return result;
};

const findAll = async () => {
  // Return unique categories by name (or just all if preferred)
  // The user said "filter by items need database to set all items and filter"
  // So they probably want all distinct categories available.
  const result = await MenuCategory.find().sort({ name: 1 });
  return result;
};

export const MenuCategoryService = {
  create,
  findByShopOwner,
  findByBranch,
  findAll,
  findById,
  updateById,
  deleteById,
};
