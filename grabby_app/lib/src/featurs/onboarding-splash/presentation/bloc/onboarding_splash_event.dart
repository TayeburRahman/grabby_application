part of 'onboarding_splash_bloc.dart';

@immutable
sealed class OnboardingSplashEvent {}

/// Fired when the Splash screen starts — triggers the timer
class LoadInitialData extends OnboardingSplashEvent {}

/// Fired when the user finishes all onboarding slides and presses "Get Started"
class OnboardingCompleted extends OnboardingSplashEvent {}

/// Fired when user selects their role on the role-selection screen
class RoleSelected extends OnboardingSplashEvent {
  final UserRole role;
  RoleSelected(this.role);
}
