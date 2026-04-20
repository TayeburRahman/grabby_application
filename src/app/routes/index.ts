import express from 'express';
import { AuthRoutes } from '../modules/auth/auth.routes';
import { ShopOwnerRoutes } from '../modules/shop_owner/shop_owner.routes';
import { AdminRoutes } from '../modules/admin/admin.routes';
import { MenuCategoryRoutes } from '../modules/menu_category/menu_category.routes';
import { MenuRoutes } from '../modules/menu/menu.routes';
import { EventOfferRoutes } from '../modules/event_offer/event_offer.routes';
import { CustomerRoutes } from '../modules/customers/customers.routes';
import { CustomerStampRoutes } from '../modules/customer_stamps/customer_stamps.routes';
import { BranchRoutes } from '../modules/customers/branches.routes';
import { PromoCodeRoutes } from '../modules/promo_code/promo_code.routes';
import { UpcomingEventsRoutes } from '../modules/upcoming_events/upcoming_events.routes';
import { CarPlateRoutes } from '../modules/car_plates/car_plates.routes';

const router = express.Router();

const moduleRoutes = [
  {
    path: '/auth',
    route: AuthRoutes,
  },
  {
    path: '/shop-owner',
    route: ShopOwnerRoutes,
  },
  {
    path: '/menu-category',
    route: MenuCategoryRoutes,
  },
  {
    path: '/menu',
    route: MenuRoutes,
  },
  {
    path: '/event-offer',
    route: EventOfferRoutes,
  },
  {
    path: '/admin',
    route: AdminRoutes,
  },
  {
    path: '/customers',
    route: CustomerRoutes,
  },
  {
    path: '/customer-stamps',
    route: CustomerStampRoutes,
  },
  {
    path: '/branches',
    route: BranchRoutes,
  },
  {
    path: '/promo-code',
    route: PromoCodeRoutes,
  },
  {
    path: '/upcoming-events',
    route: UpcomingEventsRoutes,
  },
  {
    path: '/car-plates',
    route: CarPlateRoutes,
  },
];
moduleRoutes.forEach(route => router.use(route.path, route.route));

export default router;
