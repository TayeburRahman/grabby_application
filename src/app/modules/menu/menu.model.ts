import { Schema, model } from 'mongoose';
import { IMenu, MenuModel } from './menu.interface';

const additionalItemSchema = new Schema(
  {
    name: { type: String, required: true },
    price: { type: Number, required: true },
    image: { type: String, default: null },
  },
  { _id: true }
);

const additionalGroupSchema = new Schema(
  {
    groupName: { type: String, required: true },
    type: { type: String, enum: ['regular', 'optional'], required: true },
    items: { type: [additionalItemSchema], default: [] },
  },
  { _id: true }
);

const menuSchema = new Schema<IMenu, MenuModel>(
  {
    image: { type: String, default: '' },
    itemName: { type: String, required: true },
    category: { type: Schema.Types.ObjectId, ref: 'MenuCategory', required: true },
    shopOwnerId: { type: Schema.Types.ObjectId, ref: 'ShopOwner', required: true },
    price: { type: Number, required: true },
    description: { type: String, default: '' },
    additionalItems: { type: [additionalGroupSchema], default: [] },
    stamp: { type: Number, default: 0 },
    isAvailable: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export const Menu = model<IMenu, MenuModel>('Menu', menuSchema);
