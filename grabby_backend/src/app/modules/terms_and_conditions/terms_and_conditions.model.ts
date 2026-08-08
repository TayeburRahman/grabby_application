import { Schema, model } from 'mongoose';
import { ITermsAndConditions, TermsAndConditionsModel } from './terms_and_conditions.interface';

const termsAndConditionsSchema = new Schema<ITermsAndConditions>(
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

export const TermsAndConditions = model<ITermsAndConditions, TermsAndConditionsModel>(
  'TermsAndConditions',
  termsAndConditionsSchema
);
