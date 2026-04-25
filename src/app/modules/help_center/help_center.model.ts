import { Schema, model } from 'mongoose';
import { IHelpCenter, HelpCenterModel } from './help_center.interface';

const helpCenterSchema = new Schema<IHelpCenter>(
  {
    phone: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const HelpCenter = model<IHelpCenter, HelpCenterModel>('HelpCenter', helpCenterSchema);
