import 'package:get_it/get_it.dart';
import 'package:grabby_app/src/core/services/socket_service.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/datasources/onboarding_remote_data_source.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/domain/repositories/onboarding_repository.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/presentation/bloc/info_bloc/onboarding_info_bloc.dart';
import 'package:grabby_app/src/featurs/profile-settings/data/datasources/notification_remote_data_source.dart';
import 'package:grabby_app/src/featurs/profile-settings/data/repositories/notification_repository_impl.dart';
import 'package:grabby_app/src/featurs/profile-settings/data/services/branch_service.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/branch/branch_bloc.dart';

import 'package:grabby_app/src/featurs/branch/data/datasources/branch_remote_data_source.dart';
import 'package:grabby_app/src/featurs/branch/data/repositories/branch_repository_impl.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/notification/notification_bloc.dart';
import 'package:grabby_app/src/featurs/reward/data/datasources/reward_remote_data_source.dart';
import 'package:grabby_app/src/featurs/reward/data/repositories/reward_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabby_app/src/featurs/cart-checkout/data/datasources/car_plate_remote_data_source.dart';
import 'package:grabby_app/src/featurs/cart-checkout/data/repositories/car_plate_repository_impl.dart';
import 'package:grabby_app/src/featurs/cart-checkout/domain/repositories/car_plate_repository.dart';
import 'package:grabby_app/src/featurs/cart-checkout/presentation/bloc/car_plate_bloc.dart';
import 'package:grabby_app/src/featurs/cart-checkout/data/datasources/cart_remote_data_source.dart';
import 'package:grabby_app/src/featurs/cart-checkout/data/repositories/cart_repository_impl.dart';
import 'package:grabby_app/src/featurs/cart-checkout/domain/repositories/cart_repository.dart';
import 'package:grabby_app/src/featurs/cart-checkout/presentation/bloc/cart_bloc.dart';
import 'package:grabby_app/src/featurs/reward/presentation/bloc/reward_bloc.dart';
import 'package:grabby_app/src/featurs/order/data/datasources/order_remote_data_source.dart';
import 'package:grabby_app/src/featurs/order/domain/repositories/order_repository.dart';
import 'package:grabby_app/src/featurs/order/presentation/bloc/order_bloc.dart';
import 'package:grabby_app/src/featurs/home/data/datasources/home_remote_data_source.dart';
import 'package:grabby_app/src/featurs/home/domain/repositories/home_repository.dart';
import 'package:grabby_app/src/featurs/home/presentation/bloc/shop_dashboard_bloc.dart';
import 'package:grabby_app/src/featurs/home/presentation/bloc/promoted_ads_bloc.dart';
import 'package:grabby_app/src/featurs/support/data/datasources/support_remote_data_source.dart';
import 'package:grabby_app/src/featurs/support/domain/repositories/support_repository.dart';
import 'package:grabby_app/src/featurs/support/presentation/bloc/support_bloc.dart';
import '../../src_export.dart' ;

final sl = GetIt.instance;

Future<void> init() async {
  //! Shared
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(sl()),
  );

  sl.registerLazySingleton<LocationService>(
    () => LocationService(
      socketService: sl(),
      localStorageService: sl(),
    ),
  );

  sl.registerLazySingleton<SocketService>(() => SocketService());

  sl.registerLazySingleton<ApiService>(
    () => ApiService(baseUrl: ApiEndpoints.baseUrl, localStorageService: sl()),
  );

  //! Features - Onboarding & Splash
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton(
    () => OnboardingSplashBloc(
      localDataSource: sl(),
      localStorageService: sl(),
      profileRepository: sl(),
      locationService: sl(),
    ),
  );

  // ─── Feature: Auth ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));

  // ─── Feature: Profile ──────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      profileRepository: sl(),
      locationService: sl(),
      socketService: sl(),
      localStorageService: sl(),
    ),
  );

  // ─── Feature: Branch ───────────────────────────────────────────────────────
  sl.registerLazySingleton<BranchService>(() => BranchService(sl()));
  sl.registerFactory<BranchBloc>(() => BranchBloc(branchService: sl()));

  // ─── Feature: Menu ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerFactory<MenuBloc>(() => MenuBloc(sl()));

  // ─── Feature: Promotion ────────────────────────────────────────────────────
  sl.registerLazySingleton<PromotionRemoteDataSource>(
    () => PromotionRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PromotionRepository>(
    () => PromotionRepositoryImpl(sl()),
  );
  sl.registerFactory<PromotionBloc>(() => PromotionBloc(sl()));

  // ─── Feature: Customer Branch ─────────────────────────────────────────────
  sl.registerLazySingleton<BranchRemoteDataSource>(
    () => BranchRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(sl()),
  );
  sl.registerFactory<CustomerBranchBloc>(
    () => CustomerBranchBloc(branchRepository: sl()),
  );

  // ─── Feature: Car Plate ────────────────────────────────────────────────────
  sl.registerLazySingleton<CarPlateRemoteDataSource>(
    () => CarPlateRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CarPlateRepository>(
    () => CarPlateRepositoryImpl(sl()),
  );
  sl.registerFactory<CarPlateBloc>(() => CarPlateBloc(sl()));

  // ─── Feature: Reward ───────────────────────────────────────────────────────
  sl.registerLazySingleton<RewardRemoteDataSource>(
    () => RewardRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RewardRepository>(
    () => RewardRepositoryImpl(sl()),
  );
  sl.registerFactory<RewardBloc>(() => RewardBloc(sl()));

  // ─── Feature: Cart ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl()),
  );
  sl.registerFactory<CartBloc>(() => CartBloc(sl()));

  // ─── Feature: Order ────────────────────────────────────────────────────────
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl()),
  );
  sl.registerFactory<OrderBloc>(() => OrderBloc(sl()));

  // ─── Feature: Home (Dashboard) ────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );
  sl.registerFactory<ShopDashboardBloc>(() => ShopDashboardBloc(sl()));
  sl.registerFactory<PromotedAdsBloc>(
    () => PromotedAdsBloc(repository: sl(), locationService: sl()),
  );

  // ─── Feature: Onboarding Info ─────────────────────────────────────────────
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerFactory<OnboardingInfoBloc>(() => OnboardingInfoBloc(sl()));

  // ─── Feature: Support ──────────────────────────────────────────────────────
  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SupportRepository>(() => SupportRepositoryImpl(sl()));
  sl.registerFactory<SupportBloc>(() => SupportBloc(repository: sl()));
  sl.registerFactory<LocationSelectionBloc>(
    () => LocationSelectionBloc(locationService: sl()),
  );

  // ─── Feature: Notifications ────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(repository: sl()),
  );
}
