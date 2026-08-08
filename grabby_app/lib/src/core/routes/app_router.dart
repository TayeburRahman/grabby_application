import 'package:grabby_app/src/featurs/cart-checkout/presentation/bloc/cart_bloc.dart';
import 'package:grabby_app/src/featurs/cart-checkout/presentation/pages/stripe_payment_webview_page.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/branch/branch_bloc.dart';
import 'package:grabby_app/src/featurs/support/presentation/bloc/support_bloc.dart';
import 'package:grabby_app/src/featurs/support/presentation/pages/terms_and_conditions_page.dart';

import '../../src_export.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    redirect: (context, state) {
      debugPrint("Navigating to: ${state.matchedLocation}");
      return null; // No redirection, just logging
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',

        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: RoutesPath.onboardingPath,

        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingPage();
        },
      ),
      GoRoute(
        path: RoutesPath.roleSelectionPath,
        name: RoutesPath.roleSelectionPath,
        builder: (BuildContext context, GoRouterState state) {
          return const RoleSelectionPage();
        },
      ),
      GoRoute(
        path: RoutesPath.loginPath,
        name: RoutesPath.loginPath,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: RoutesPath.signUpPath,
        name: RoutesPath.signUpPath,
        builder: (BuildContext context, GoRouterState state) {
          return SignUpPage(extra: state.extra as Map<String, dynamic>?);
        },
      ),
      GoRoute(
        path: RoutesPath.forgotPasswordPath,
        name: RoutesPath.forgotPasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: RoutesPath.verificationPath,
        name: RoutesPath.verificationPath,
        builder: (BuildContext context, GoRouterState state) {
          return VerificationPage(extra: state.extra as Map<String, dynamic>?);
        },
      ),
      GoRoute(
        path: RoutesPath.forgotEmailPath,
        name: RoutesPath.forgotEmailPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotEmailPage();
        },
      ),
      GoRoute(
        path: RoutesPath.navigationPath,
        name: RoutesPath.navigationPath,
        builder: (BuildContext context, GoRouterState state) {
          return const NavigationPage();
        },
      ),
      GoRoute(
        path: RoutesPath.resetPasswordPath,
        name: RoutesPath.resetPasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return ResetPasswordPage(extra: state.extra as Map<String, dynamic>?);
        },
      ),
      GoRoute(
        path: RoutesPath.locationPath,
        name: RoutesPath.locationPath,
        builder: (BuildContext context, GoRouterState state) {
          return const LocationPage();
        },
      ),
      GoRoute(
        path: RoutesPath.restruantDetailsPath,
        name: RoutesPath.restruantDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<CustomerBranchBloc>(),
            child: RestruantDetailsPage(branchId: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.menuPath,
        name: RoutesPath.menuPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<CustomerBranchBloc>(),
            child: MenuPage(branchId: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.itemDetailsPath,
        name: RoutesPath.itemDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ItemDetailsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.cartPath,
        name: RoutesPath.cartPath,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<OrderBloc>()),
            ],
            child: const CartPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.carPlatesPath,
        name: RoutesPath.carPlatesPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<CarPlateBloc>(),
            child: const CarPlatesPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.addCarPlatePath,
        name: RoutesPath.addCarPlatePath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<CarPlateBloc>(),
            child: const AddCarPlatePage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.checkoutPath,
        name: RoutesPath.checkoutPath,
        builder: (BuildContext context, GoRouterState state) {
          return PaymentPage(order: state.extra as OrderModel);
        },
      ),
      GoRoute(
        path: RoutesPath.paymentSuccessPath,
        name: RoutesPath.paymentSuccessPath,
        builder: (BuildContext context, GoRouterState state) {
          return PaymentSuccessPage(order: state.extra as OrderModel);
        },
      ),
      GoRoute(
        path: RoutesPath.stripePaymentWebviewPath,
        name: RoutesPath.stripePaymentWebviewPath,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as Map<String, dynamic>;
          return StripePaymentWebviewPage(
            order: args['order'] as OrderModel,
            paymentUrl: args['paymentUrl'] as String,
          );
        },
      ),
      GoRoute(
        path: RoutesPath.stripeConnectWebviewPath,
        name: RoutesPath.stripeConnectWebviewPath,
        builder: (BuildContext context, GoRouterState state) {
          final onboardingUrl = state.extra as String;
          return StripeConnectWebviewPage(
            onboardingUrl: onboardingUrl,
          );
        },
      ),

      GoRoute(
        path: RoutesPath.orderTrackingPath,
        name: RoutesPath.orderTrackingPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<OrderBloc>(),
            child: OrderTrackingPage(orderId: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.orderHistoryPath,
        name: RoutesPath.orderHistoryPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<OrderBloc>(),
            child: const OrderHistoryPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.orderTrackingMapViewPath,
        name: RoutesPath.orderTrackingMapViewPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<OrderBloc>(),
            child: OrderTrackingMapViewPage(orderId: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.orderCanceledPath,
        name: RoutesPath.orderCanceledPath,
        builder: (BuildContext context, GoRouterState state) {
          return  OrderCanceledPage(orderId: state.extra as String,);
        },
      ),
      GoRoute(
        path: RoutesPath.loyaltyRewardPath,
        name: RoutesPath.loyaltyRewardPath,
        builder: (BuildContext context, GoRouterState state) {
          return const LoyaltyRewardPage();
        },
      ),
      GoRoute(
        path: RoutesPath.suggestAShopPath,
        name: RoutesPath.suggestAShopPath,
        builder: (BuildContext context, GoRouterState state) {
          return const SuggestAShopPage();
        },
      ),
      GoRoute(
        path: RoutesPath.profilePath,
        name: RoutesPath.profilePath,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: RoutesPath.personalInfoPath,
        name: RoutesPath.personalInfoPath,
        builder: (BuildContext context, GoRouterState state) {
          return const PersonalInformationPage();
        },
      ),
      GoRoute(
        path: RoutesPath.notificationPath,
        name: RoutesPath.notificationPath,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationPage();
        },
      ),
      GoRoute(
        path: RoutesPath.accountSettingsPath,
        name: RoutesPath.accountSettingsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const AccountSettingsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.changePasswordPath,
        name: RoutesPath.changePasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordPage();
        },
      ),
      GoRoute(
        path: RoutesPath.shopNavigationPath,
        name: RoutesPath.shopNavigationPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ShopNavigationPage();
        },
      ),
      GoRoute(
        path: RoutesPath.shopOrderManagementPath,
        name: RoutesPath.shopOrderManagementPath,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<OrderBloc>()),
              BlocProvider(create: (context) => sl<BranchBloc>()),
            ],
            child: const ShopOrderManagementPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.shopOrderDetailsPath,
        name: RoutesPath.shopOrderDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<OrderBloc>(),
            child: ShopOrderDetailsPage(
              orderId: (state.extra as OrderModel).id ?? '',
              socketOrderID: (state.extra as OrderModel).orderId ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.promotionPath,
        name: RoutesPath.promotionPath,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<PromotionBloc>()..add(GetPromotionsEvent())),
              BlocProvider(create: (context) => sl<MenuBloc>()..add(GetMenuItemsEvent())),
            ],
            child: const PromotionPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.businessProfilePath,
        name: RoutesPath.businessProfileName,
        builder: (BuildContext context, GoRouterState state) {
          return const BusinessProfilePage();
        },
      ),
      GoRoute(
        path: RoutesPath.branchManagementPath,
        name: RoutesPath.branchManagementName,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (_) => sl<BranchBloc>()..add(GetBranchesEvent()),
            child: const BranchManagementPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.branchTimingsPath,
        name: RoutesPath.branchTimingsName,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (_) => sl<BranchBloc>()..add(GetBranchesEvent()),
            child: const BranchTimingsPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesPath.rewardSettingsPath,
        name: RoutesPath.rewardSettingsName,
        builder: (BuildContext context, GoRouterState state) {
          return const RewardSettingsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.shopMenuManagementPath,
        name: RoutesPath.shopMenuManagementName,
        builder: (BuildContext context, GoRouterState state) {
          return const ShopMenuManagementPage();
        },
      ),
      GoRoute(
        path: RoutesPath.editItemPath,
        name: RoutesPath.editItemName,
        builder: (BuildContext context, GoRouterState state) {
          return EditItemPage(item: state.extra as MenuItemModel?);
        },
      ),
      GoRoute(
        path: RoutesPath.shopOwnerOnboardingPath,
        name: RoutesPath.shopOwnerOnboardingPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ShopOwnerOnboardingPage();
        },
      ),
      GoRoute(
        path: RoutesPath.marketingCampaignsPath,
        name: RoutesPath.marketingCampaignsName,
        builder: (BuildContext context, GoRouterState state) {
          return const MarketingCampaignsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.campaignTierDetailPath,
        name: RoutesPath.campaignTierDetailName,
        builder: (BuildContext context, GoRouterState state) {
          return CampaignTierDetailPage(
            tierData: state.extra as Map<String, dynamic>,
          );
        },
      ),
      GoRoute(
        path: RoutesPath.businessInfoPath,
        name: RoutesPath.businessInfoPath,
        builder: (BuildContext context, GoRouterState state) {
          return const BusinessInfoPage();
        },
      ),
      GoRoute(
        path: RoutesPath.branchLocationsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const BranchLocationsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.requiredDocumentsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const RequiredDocumentsPage();
        },
      ),
      GoRoute(
        path: RoutesPath.locationSelectionPath,
        name: RoutesPath.locationSelectionName,
        builder: (BuildContext context, GoRouterState state) {
          return const LocationSelectionPage();
        },
      ),
      GoRoute(
        path: RoutesPath.termsAndConditionsPath,
        name: RoutesPath.termsAndConditionsPath,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => sl<SupportBloc>(),
            child: const TermsAndConditionsPage(),
          );
        },
      ),
    ],
  );
}
