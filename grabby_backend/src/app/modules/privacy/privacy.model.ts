import { Schema, model } from 'mongoose';
import { IPrivacy, PrivacyModel } from './privacy.interface';

const privacySchema = new Schema<IPrivacy>(
  {
    content: {
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

export const Privacy = model<IPrivacy, PrivacyModel>('Privacy', privacySchema);
