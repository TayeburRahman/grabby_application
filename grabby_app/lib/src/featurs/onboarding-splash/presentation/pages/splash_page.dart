import '../../../../src_export.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Use the singleton instance and fire the splash timer
      value: sl<OnboardingSplashBloc>()..add(LoadInitialData()),
      child: BlocListener<OnboardingSplashBloc, OnboardingSplashState>(
        listener: (context, state) {
          if (state is AuthenticatedCustomer) {
            context.goNamed(RoutesPath.navigationPath);
          } else if (state is AuthenticatedShopOwner) {
            context.goNamed(RoutesPath.shopNavigationPath);
          } else if (state is SplashFinished) {
            // Navigate to Onboarding slides
            context.go(RoutesPath.roleSelectionPath);
          } else if (state is ShowLogin) {
            context.go(RoutesPath.loginPath);
          } else {
            context.go(RoutesPath.shopNavigationPath);
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImagesConstant.kAppIcon,
                  height: MediaQuery.of(context).size.width / 1.5,
                ),
                AppNameTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
