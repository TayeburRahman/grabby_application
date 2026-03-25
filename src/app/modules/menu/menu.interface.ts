import { Model, Types } from 'mongoose';

export type IAdditionalItem = {
  name: string;
  price: number;
};

export type IAdditionalGroup = {
  groupName: string;
  type: 'regular' | 'optional';
  items: IAdditionalItem[];
};

export type IMenu = {
  image: string;
  itemName: string;
  category: Types.ObjectId;
  shopOwnerId: Types.ObjectId;
  price: number;
  description: string;
  additionalItems: IAdditionalGroup[];
  stamp: number;
  isAvailable: boolean;
  eventOffer?: any;
};

export type MenuModel = Model<IMenu>;
