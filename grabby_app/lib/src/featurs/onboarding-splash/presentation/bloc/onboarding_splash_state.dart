part of 'onboarding_splash_bloc.dart';

@immutable
sealed class OnboardingSplashState {}

/// Default initial state
final class OnboardingSplashInitial extends OnboardingSplashState {}

/// Splash screen is showing (2-second timer running)
class SplashLoading extends OnboardingSplashState {}

/// Timer done → navigate to Onboarding slides
class SplashFinished extends OnboardingSplashState {}

class ShowLogin extends OnboardingSplashState {}

/// User finished all onboarding slides
class ShowRoleSelection extends OnboardingSplashState {}

/// User picked a role → navigate to Login or SignUp
class RoleSelectionDone extends OnboardingSplashState {
  final UserRole role;
  RoleSelectionDone(this.role);
}

class AuthenticatedCustomer extends OnboardingSplashState {}

class AuthenticatedShopOwner extends OnboardingSplashState {}
