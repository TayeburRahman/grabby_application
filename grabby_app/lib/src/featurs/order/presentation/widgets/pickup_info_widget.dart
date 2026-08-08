import '../../../../src_export.dart';

class PickupInfoWidget extends StatelessWidget {
  const PickupInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const CustomText(
            AppStaticStrings.pickupInfo,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          Row(
            spacing: 8,
            children: [
              SvgPicture.asset(
                ImagesConstant.kContactPickupIcon,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFA59BF9),
                  BlendMode.srcIn,
                ),
              ),
              const CustomText(
                AppStaticStrings.counterPickup,
                fontSize: 12,
                color: Color(0xFFA59BF9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
