import { Model } from 'mongoose';

export type IFreeStructure = {
  content: string;
};

export type FreeStructureModel = Model<IFreeStructure, Record<string, unknown>>;
