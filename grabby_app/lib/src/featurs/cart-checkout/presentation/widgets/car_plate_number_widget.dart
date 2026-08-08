import '../../../../src_export.dart';

class CarPlateNumberWidget extends StatelessWidget {
  final String plateNumber;
  final VoidCallback onTap;

  const CarPlateNumberWidget({
    super.key,
    required this.plateNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            plateNumber,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.kTextColor,
          ),
          ButtonTapWidget(
            onTap: onTap,
            child: CustomText(
              AppStaticStrings.managePlates,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.kSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
