import dotenv from 'dotenv';
import path from 'path';

dotenv.config({
  path: path.join(process.cwd(), '.env'),
});

export default {
  env: process.env.NODE_ENV,
  port: process.env.PORT,
  ip: process.env.IP,
  base_url: process.env.BASE_URL,
  app_name: process.env.APP_NAME,
  database_url: process.env.MONGO_URL,
  database_password: process.env.DB_PASSWORD,
  activation_secret: process.env.ACTIVATION_SECRET,
  bcrypt_salt_rounds: process.env.BCRYPT_SALT_ROUNDS,
  jwt: {
    secret: process.env.JWT_SECRET,
    refresh_secret: process.env.JWT_REFRESH_SECRET,
    expires_in: process.env.JWT_EXPIRES_IN,
    refresh_expires_in: process.env.JWT_REFRESH_EXPIRES_IN,
  },
  smtp: {
    smtp_host: process.env.SMTP_HOST,
    smtp_port: process.env.SMTP_PORT,
    smtp_service: process.env.SMTP_SERVICE,
    smtp_mail: process.env.SMTP_MAIL,
    smtp_password: process.env.SMTP_PASSWORD,
  },
  stripe: {
    stripe_secret_key: process.env.STRIPE_SECRET_KEY,
  },
  onesignal: {
    app_id: process.env.ONESIGNAL_APP_ID,
    api_key: process.env.ONESIGNAL_API_KEY,
    onesignal_url: process.env.ONESIGNAL_URL || 'https://onesignal.com',
  },
  foloosi: {
    merchant_key: process.env.FOLOOSI_MERCHANT_KEY || 'live_$2y$10$6O0mhc6Iq.KtV2xyGFLaw.FEdhsn64OR7a9jV9zxvJ9ugSjck14IS',
    secret_key: process.env.FOLOOSI_SECRET_KEY || 'live_$2y$10$SjduEr4p1XrNVU-7sbGr.14vIFC..FjUDV9SXzmLb0cLThn79BjW',
  },
  super_admin: {
    email: process.env.SUPER_ADMIN_EMAIL || 'superadmin@ayah.com',
    password: process.env.SUPER_ADMIN_PASSWORD || 'superadmin123',
    name: process.env.SUPER_ADMIN_NAME || 'Super Admin',
    phone_number: process.env.SUPER_ADMIN_PHONE || '+971500000000',
  },
};
