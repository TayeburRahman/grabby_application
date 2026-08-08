import { ITermsAndConditions } from './terms_and_conditions.interface';
import { TermsAndConditions } from './terms_and_conditions.model';

const createOrUpdateTermsAndConditions = async (
  payload: ITermsAndConditions
): Promise<ITermsAndConditions | null> => {
  const result = await TermsAndConditions.findOneAndUpdate({}, payload, {
    new: true,
    upsert: true,
  });
  return result;
};

const getTermsAndConditions = async (): Promise<ITermsAndConditions | null> => {
  const result = await TermsAndConditions.findOne({});
  return result;
};

export const TermsAndConditionsService = {
  createOrUpdateTermsAndConditions,
  getTermsAndConditions,
};
