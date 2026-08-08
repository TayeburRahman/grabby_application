import 'package:bloc/bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../src_export.dart';
import 'package:meta/meta.dart';

part 'onboarding_splash_event.dart';
part 'onboarding_splash_state.dart';

/// The roles a user can choose on the Role Selection screen.
enum UserRole { customer, shop }

class OnboardingSplashBloc
    extends Bloc<OnboardingSplashEvent, OnboardingSplashState> {
  final OnboardingLocalDataSource localDataSource;
  final LocalStorageService localStorageService;
  final ProfileRepository profileRepository;
  final LocationService locationService;
  UserRole selectedRole = UserRole.customer;

  OnboardingSplashBloc({
    required this.localDataSource,
    required this.localStorageService,
    required this.profileRepository,
    required this.locationService,
  }) : super(SplashLoading()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<RoleSelected>(_onRoleSelected);

    // Initialize selectedRole from storage
    selectedRole = localDataSource.getUserRole() ?? UserRole.customer;
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<OnboardingSplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 3));

    final token = localStorageService.getAccessToken();
    if (token != null) {
      final role = localStorageService.getUserRoleFromToken();
      if (role == 'CUSTOMER') {
        // Initial location update on app launch
        print('Initial Location Update - User Token: $token');

        try {
          final locationData = await locationService.getLocationData();
          if (locationData != null) {
            final response = await profileRepository.updateUserLocation(
              addressName: locationData.address,
              lat: locationData.latitude,
              lon: locationData.longitude,
            );
            print('Initial Location Update Response: $response');
          } else {
            print('Initial Location Update: Failed to get location data.');
          }
        } catch (e) {
          print('Initial Location Update Error: $e');
        }

        emit(AuthenticatedCustomer());
        return;
      } else if (role == 'SHOP_OWNER') {
        print('Initial Location Update - User Token: $token');

        try {
          final locationData = await locationService.getLocationData();
          if (locationData != null) {
            final response = await profileRepository.updateUserLocation(
              addressName: locationData.address,
              lat: locationData.latitude,
              lon: locationData.longitude,
            );
            print('Initial Location Update Response: $response');
          } else {
            print('Initial Location Update: Failed to get location data.');
          }
        } catch (e) {
          print('Initial Location Update Error: $e');
        }
        emit(AuthenticatedShopOwner());
        return;
      }
    }

    if (localDataSource.isFirstTime()) {
      emit(SplashFinished());
    } else {
      emit(ShowLogin());
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingSplashState> emit,
  ) async {
    await localDataSource.setFirstTime(false);
    emit(ShowRoleSelection());
  }

  Future<void> _onRoleSelected(
    RoleSelected event,
    Emitter<OnboardingSplashState> emit,
  ) async {
    selectedRole = event.role;
    await localDataSource.saveUserRole(selectedRole);
    emit(RoleSelectionDone(selectedRole));
  }

  void updateSelectedRole(UserRole role) {
    selectedRole = role;
  }
}
