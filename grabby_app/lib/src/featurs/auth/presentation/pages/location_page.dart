import '../../../../src_export.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: AppPadding.getPadding12(context),
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppPadding.getPadding16(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagesConstant.kLocationIcon),
              ),

              CustomText(
                AppStaticStrings.enableLocation ?? 'Enable Location',
                variant: TextVariant.headlineLarge,
              ),

              CustomText(
                AppStaticStrings.locationDesc ??
                    'Ask and enable location to modify profile and access nearby cafes.',
                textAlign: TextAlign.center,
                variant: TextVariant.labelMedium,
                color: AppColors.kSecondaryTextColor,
              ),

              CustomButton(
                text: AppStaticStrings.enableLocation ?? 'Enable Location',
                onPressed: () {
                  final role = sl<OnboardingSplashBloc>().selectedRole;
                  if (role == UserRole.shop) {
                    context.push(RoutesPath.businessInfoPath);
                  } else {
                    context.pushNamed(RoutesPath.loginPath);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
