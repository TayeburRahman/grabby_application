import '../../../../src_export.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      "GRABBY",
      variant: TextVariant.displayMedium,
      color: AppColors.kPrimaryColor,
    );
  }
}
