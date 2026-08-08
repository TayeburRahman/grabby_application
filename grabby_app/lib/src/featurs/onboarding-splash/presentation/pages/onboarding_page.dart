import '../../../../src_export.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl<OnboardingSplashBloc>();
    final isShop = bloc.selectedRole == UserRole.shop;

    List<Map<String, dynamic>> onboardingData = isShop
        ? [
            {
              'title': RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome  To ",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppColors.kWhiteTextColor),
                    ),
                    TextSpan(
                      text: "Grabby",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppColors.kPrimaryColor),
                    ),
                  ],
                ),
              ),
              'subtitle': AppStaticStrings.welcomeToGrabbyDesc,
              'img': ImagesConstant.kOnboardShopOwner1Img,
              'buttonText': AppStaticStrings.onboardYourShop,
            },
            {
              'title': CustomText(
                AppStaticStrings.manageOrdersInRealTime,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.receiveOrdersInstantly,
              'img': ImagesConstant.kOnboardShopOwner2Img,
              'buttonText': AppStaticStrings.onboardYourShop,
            },
            {
              'title': CustomText(
                AppStaticStrings.controlMenuAndPromotions,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.updateItemsPricesAvailability,
              'img': ImagesConstant.kOnboardShopOwner3Img,
              'buttonText': AppStaticStrings.onboardYourShop,
            },
            {
              'title': CustomText(
                AppStaticStrings.trackPerformanceAndGrow,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.viewOrdersLoyalActivity,
              'img': ImagesConstant.kOnboardShopOwner4Img,
              'buttonText': AppStaticStrings.onboardYourShop,
            },
          ]
        : [
            {
              'title': RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome  To ",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppColors.kWhiteTextColor),
                    ),
                    TextSpan(
                      text: "Grabby",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppColors.kPrimaryColor),
                    ),
                  ],
                ),
              ),
              'subtitle': AppStaticStrings.orderYourFavoriteCoffee,
              'img': ImagesConstant.kOnboard1Img,
              'buttonText': AppStaticStrings.startOrdering,
            },
            {
              'title': CustomText(
                AppStaticStrings.findTheBestCafe,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.searchExploreMenu,
              'img': ImagesConstant.kOnboard2Img,
              'buttonText': AppStaticStrings.startOrdering,
            },
            {
              'title': CustomText(
                AppStaticStrings.pickUpWithoutWaiting,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.chooseCarOrCounter,
              'img': ImagesConstant.kOnboard3Img,
              'buttonText': AppStaticStrings.startOrdering,
            },
            {
              'title': CustomText(
                AppStaticStrings.earnLoaylty,
                variant: TextVariant.headlineLarge,
                color: AppColors.kWhiteTextColor,
              ),
              'subtitle': AppStaticStrings.collectDigitalStamps,
              'img': ImagesConstant.kOnboard4Img,
              'buttonText': AppStaticStrings.startOrdering,
            },
          ];

    return BlocProvider.value(
      value: bloc,
      child: BlocListener<OnboardingSplashBloc, OnboardingSplashState>(
        listener: (context, state) {
          if (state is ShowRoleSelection) {
            if (isShop) {
              context.go(RoutesPath.shopOwnerOnboardingPath);
            } else {
              context.go(RoutesPath.loginPath);
            }
          }
        },
        child: PageView.builder(
          allowImplicitScrolling: true,
          itemBuilder: (context, index) {
            Map<String, dynamic> item = onboardingData[index];
            return OnboardingItemWidget(
              item: item,
              onboardingData: onboardingData,
              index: index,
            );
          },
          itemCount: onboardingData.length,
        ),
      ),
    );
  }
}
