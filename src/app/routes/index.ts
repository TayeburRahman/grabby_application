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
import { CartRoutes } from '../modules/cart/cart.routes';
import { OrderRoutes } from '../modules/order/order.routes';
import { DashboardRoutes } from '../modules/dashboard/dashboard.routes';
import { FaqRoutes } from '../modules/faq/faq.routes';
import { FreeStructureRoutes } from '../modules/free_structure/free_structure.routes';
import { PricingPlanRoutes } from '../modules/pricing_plan/pricing_plan.routes';
import { ShopOwnerPlanRoutes } from '../modules/shop_owner_plan/shop_owner_plan.routes';
import { HelpCenterRoutes } from '../modules/help_center/help_center.routes';
import { TermsAndConditionsRoutes } from '../modules/terms_and_conditions/terms_and_conditions.routes';
import { NotificationRoutes } from '../modules/notification/notification.routes';

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
  {
    path: '/cart',
    route: CartRoutes,
  },
  {
    path: '/orders',
    route: OrderRoutes,
  },
  {
    path: '/dashboard',
    route: DashboardRoutes,
  },
  {
    path: '/faq',
    route: FaqRoutes,
  },
  {
    path: '/free-structure',
    route: FreeStructureRoutes,
  },
  {
    path: '/pricing-plan',
    route: PricingPlanRoutes,
  },
  {
    path: '/shop-owner-plan',
    route: ShopOwnerPlanRoutes,
  },
  {
    path: '/help-center',
    route: HelpCenterRoutes,
  },
  {
    path: '/terms-and-conditions',
    route: TermsAndConditionsRoutes,
  },
  {
    path: '/notifications',
    route: NotificationRoutes,
  },
];
moduleRoutes.forEach(route => router.use(route.path, route.route));

export default router;
