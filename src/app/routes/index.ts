import express from 'express';
import { AuthRoutes } from '../modules/auth/auth.routes';
import { ShopOwnerRoutes } from '../modules/shop_owner/shop_owner.routes';
import { AdminRoutes } from '../modules/admin/admin.routes';
import { MenuCategoryRoutes } from '../modules/menu_category/menu_category.routes';
import { MenuRoutes } from '../modules/menu/menu.routes';
import { EventOfferRoutes } from '../modules/event_offer/event_offer.routes';
import { CustomerRoutes } from '../modules/customers/customers.routes';

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
];
moduleRoutes.forEach(route => router.use(route.path, route.route));

export default router;
