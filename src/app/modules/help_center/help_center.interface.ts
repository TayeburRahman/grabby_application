import { Model } from 'mongoose';

export type IHelpCenter = {
  phone: string;
};

export type HelpCenterModel = Model<IHelpCenter, Record<string, unknown>>;
