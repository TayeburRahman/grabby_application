import '../../../../src_export.dart';

class TierCardWidget extends StatelessWidget {
  const TierCardWidget({super.key, required this.tier});

  final Map<String, dynamic> tier;

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: () {
        context.pushNamed(RoutesPath.campaignTierDetailName, extra: tier);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          spacing: 6,
          children: [
            if (tier['icon'].toString().startsWith('http'))
              CustomNetworkImage(imageUrl: tier['icon'], width: 40, height: 40)
            else
              SvgPicture.asset(
                tier['icon'],
                // height: 24,
                // width: 24,
                // colorFilter: ColorFilter.mode(tier['color'], BlendMode.srcIn),
              ),
            // space12W,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    tier['tier'],
                    variant: TextVariant.labelLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    tier['duration'],
                    variant: TextVariant.labelSmall,
                    color: AppColors.kSecondaryTextColor,
                  ),
                  Row(
                    children: [
                      const CustomText(
                        "AED",
                        variant: TextVariant.labelSmall,
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      space6W,
                      CustomText(
                        tier['price'],
                        variant: TextVariant.titleLarge,
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),

                      // space4W,
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CustomText(
                  AppStaticStrings.perDay,
                  variant: TextVariant.labelSmall,
                  color: AppColors.kSecondaryTextColor,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                    children: [
                      const TextSpan(text: "AED "),
                      TextSpan(text: tier['perDay']),
                    ],
                  ),
                ),
              ],
            ),
            space12W,
          ],
        ),
      ),
    );
  }
}
