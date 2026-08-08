import '../../../../src_export.dart';

/// The role-selection screen where the user chooses Customer or Driver.
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OnboardingSplashBloc>(),
      child: BlocListener<OnboardingSplashBloc, OnboardingSplashState>(
        listener: (context, state) {
          if (state is RoleSelectionDone) {
            final isFirstTime = sl<OnboardingLocalDataSource>().isFirstTime();
            if (isFirstTime) {
              context.go(RoutesPath.onboardingPath);
            } else {
              context.pushNamed(
                RoutesPath.signUpPath,
                extra: {'role': state.role.name},
              );
              // context.push(RoutesPath.requiredDocumentsPath);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: AppPadding.getPadding12(context),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppNameTextWidget(),
                    CustomText(
                      AppStaticStrings.yourFavoriteShopOneTapAway,
                      variant: TextVariant.titleMedium,
                      color: AppColors.kSecondaryTextColor,
                      textAlign: TextAlign.center,
                    ),

                    RoleCard(
                      title: AppStaticStrings.continueAsCustomer,
                      subtitle: AppStaticStrings.browseShopsAndOrderDrinks,
                      icon: ImagesConstant.kCustomerIcon,
                      role: UserRole.customer,
                    ),

                    RoleCard(
                      title: AppStaticStrings.continueAsShop,
                      subtitle: AppStaticStrings.manageOrdersAndMenu,
                      icon: ImagesConstant.kShopOwnerIcon,
                      role: UserRole.shop,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
