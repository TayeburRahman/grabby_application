import { logger } from "../shared/logger";
import Auth from "../app/modules/auth/auth.model";
import Admin from "../app/modules/admin/admin.model";
import { ENUM_USER_ROLE } from "../enums/user";
import config from "../config";

export const seedSuperAdmin = async () => {
  const { email, password, name, phone_number } = config.super_admin;

  const existingSuperAdmin = await Auth.findOne({
    role: ENUM_USER_ROLE.SUPER_ADMIN,
    email,
  });

  if (existingSuperAdmin) {
    return;
  }

  logger.info("Creating Super Admin...");

  const authData = await Auth.create({
    name,
    email,
    phone_number,
    password,
    role: ENUM_USER_ROLE.SUPER_ADMIN,
    isActive: true,
    termsAccepted: true,
  });

  await Admin.create({
    authId: authData._id,
    name,
    email,
    phone_number,
  });

  logger.info(`Super Admin created successfully (${email})`);
};
