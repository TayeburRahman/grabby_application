import { Model, Types } from 'mongoose';

export type IMenuCategory = {
  name: string;
  shopOwnerId?: Types.ObjectId;
  stampActive?: boolean;
};

export type MenuCategoryModel = Model<IMenuCategory>;
