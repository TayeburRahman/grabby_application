import { IPrivacy } from './privacy.interface';
import { Privacy } from './privacy.model';

const createOrUpdatePrivacy = async (payload: IPrivacy): Promise<IPrivacy | null> => {
  const result = await Privacy.findOneAndUpdate({}, payload, {
    new: true,
    upsert: true,
  });
  return result;
};

const getPrivacy = async (): Promise<IPrivacy | null> => {
  const result = await Privacy.findOne({});
  return result;
};

export const PrivacyService = {
  createOrUpdatePrivacy,
  getPrivacy,
};
