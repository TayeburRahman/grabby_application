import { Schema, model } from 'mongoose';
import { IMenuCategory, MenuCategoryModel } from './menu_category.interface';

const menuCategorySchema = new Schema<IMenuCategory, MenuCategoryModel>(
  {
    name: { type: String, required: true },
    shopOwnerId: { type: Schema.Types.ObjectId, ref: 'ShopOwner', required: false },
    stampActive: { type: Boolean, default: false },
  },
  { timestamps: true }
);

export const MenuCategory = model<IMenuCategory, MenuCategoryModel>('MenuCategory', menuCategorySchema);
