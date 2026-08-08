import '../../../../src_export.dart';

class LiveLocationSharingWidget extends StatelessWidget {
  const LiveLocationSharingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8EE),
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              const Icon(
                Icons.navigation_outlined,
                color: Color(0xFFA59BF9),
                size: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    const CustomText(
                      AppStaticStrings.sharingLiveLocation,
                      fontSize: 14,
                      color: Color(0xFFA59BF9),
                    ),
                    CustomText(
                      AppStaticStrings.shopCanSeeArrival,
                      fontSize: 12,
                      color: const Color(0xFFA59BF9).withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFD3E7D4)),
          ),
          Row(
            spacing: 8,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFA59BF9),
                  shape: BoxShape.circle,
                ),
              ),
              const CustomText(
                AppStaticStrings.locationUpdatingLive,
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
