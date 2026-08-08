import '../../../../src_export.dart';

class LoyaltyStampsWidget extends StatelessWidget {
  final int currentStamps;
  final int totalStamps;  
final int? remainingStamps;
final bool isFree;
  const LoyaltyStampsWidget({
    super.key,
    required this.currentStamps,
    this.totalStamps = 10, this.remainingStamps, this.isFree=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalStamps, (index) {
            final isFilled = index < currentStamps;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.kPrimaryColor : Colors.transparent,
                border: Border.all(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        CustomText(
          "${(remainingStamps??0)<0?0:remainingStamps} ${AppStaticStrings.moreStamps}",
          fontSize: 12,
          color: AppColors.kTextColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
