class ApiEndpoints {
  ApiEndpoints._(); // prevent instantiation

  // ─── Base URL ──────────────────────────────────────────────────────────────
  // Swap this based on environment (dev / staging / prod)
  // static const String baseUrl = "http://10.10.20.50:5001";
  static const String baseUrl = "http://10.10.28.71:5000";

  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String customerRegister = "/auth/customer/register";
  static const String shopOwnerRegister = "/auth/shop-owner/register";
  static const String customerLogin = "/auth/login";
  static const String verifyOtp = "/auth/verify-otp";
  static const String resendOtp = "/auth/resend-otp";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resendForgotCode = "/auth/resend-forgot-code";
  static const String verifyForgotOtp = "/auth/verify-forgot-otp";
  static const String resetPassword = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String logout = "/auth/customer/logout";

  // ─── Profile ───────────────────────────────────────────────────────────────
  static const String profile = "/auth/profile";
  static const String updateProfile = "/customers/profile";
  static const String updateShopOwnerProfile = "/shop-owner/profile";
  static const String updateUserLocation = "/customers/location";
  static const String updateShopOwnerLocation = "/shop-owner/location";
  static const String pricingPlan = "/pricing-plan";

  // ─── Shop Owner Business & Stripe Connect ─────────────────────────────────
  static const String saveBusinessInfo = "/shop-owner/business/info";
  static const String saveBranches = "/shop-owner/business/branches";
  static const String saveBusinessDocuments = "/shop-owner/business/documents";
  static const String stripeConnectOnboardingLink =
      "/shop-owner/stripe-connect/onboarding-link";
  static const String stripeConnectStatus =
      "/shop-owner/stripe-connect/status";


  // ─── Menu ───────────────────────────────────────────────────────────────────
  static const String createMenuCategory = "/menu-category/create";
  static const String getMenuCategories = "/menu-category/shop";
  static String deleteMenuCategory(String id) => "/menu-category/$id";
  static const String createMenu = "/menu/create";
  static const String getShopMenuItems = "/menu/shop";
  static String updateMenu(String id) => "/menu/$id";
  static String deleteMenu(String id) => "/menu/$id";

  // ─── Branch Management ──────────────────────────────────────────────────────
  static const String branchBase = "/shop-owner/branch";
  static String branchUpdate(String id) => "/shop-owner/branch/$id";
  static String branchDelete(String id) => "/shop-owner/branch/$id";
  static String branchAvailability(String id) =>
      "/shop-owner/branch/$id/availability";

  // ─── Customer Branch Browsing ─────────────────────────────────────────────
  static const String customerBranches = "/customers/branches";
  static String customerBranchDetail(String id) => "/customers/branches/$id";
  static const String upcomingEvents = "/upcoming-events";
  static const String carPlates = "/car-plates";
  static String deleteCarPlate(String id) => "/car-plates/$id";

  // ─── Cart ──────────────────────────────────────────────────────────────────
  static const String addToCart = "/cart/add";
  static const String cartSummary = "/cart/summary";
  static String cartItem(String id) => "/cart/item/$id";
  static const String validatePromoCode = "/promo-code/validate";
  static const String applyCredit = "/cart/apply-credit";

  // ─── Reward/Wallet ──────────────────────────────────────────────────────────
  static const String wallet = "/customers/wallet";
  static const String convertPoints = "/customers/convert-points";

  // ─── Orders ──────────────────────────────────────────────────────────────────
  static const String orders = "/orders";
  static const String myOrders = "/orders/my-orders";
  static String orderDetail(String id) => "/orders/$id";
  static String branchOrders(String branchId) => "/orders/branch/$branchId";
  static String updateOrderStatus(String id) => "/orders/$id/status";
  static String cancelOrder(String id) => "/orders/$id/cancel";
  static String cancelRespond(String id) => "/orders/$id/cancel-respond";
  static const String shopDashboard = "/dashboard/shop-owner";

  // ─── Onboarding ────────────────────────────────────────────────────────────
  static const String feeStructure = "/free-structure";
  static const String faq = "/faq";
  static const String termsAndConditions = "/terms-and-conditions";
  static const String helpCenter = "/help-center";
  static String promotedAds(double lat, double lon) =>
      "/shop-owner-plan/ads?lat=$lat&lon=$lon";

  static const String notifications = "/notifications";
}
