import '../../../../src_export.dart';

class GrabbyCreditWidget extends StatelessWidget {
  final double availableAmount;
  final int availablePoints;
  final VoidCallback onApplyCredit;

  const GrabbyCreditWidget({
    super.key,
    required this.availableAmount,
    required this.availablePoints,
    required this.onApplyCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          // Title row
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.kPrimaryColor,
                size: 20,
              ),
              CustomText(
                AppStaticStrings.grabbyCreditRewards,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.kPrimaryColor,
              ),
            ],
          ),
          // Available label
          CustomText(
            'Available: ${AppStaticStrings.aedPrefix}${availableAmount.toStringAsFixed(2)} (${availablePoints}pts)',
            fontSize: 13,
            color: AppColors.kSecondaryTextColor,
          ),
          // Apply Credit pill button
          ButtonTapWidget(
            onTap: onApplyCredit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                AppStaticStrings.applyCredit,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
