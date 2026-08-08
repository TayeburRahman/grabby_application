import '../../../../src_export.dart';

class LoyaltyRewardWidget extends StatelessWidget {
  final String label;
  final String reward;

  const LoyaltyRewardWidget({
    super.key,
    required this.label,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA59BF9),
          ),
          CustomText(
            reward,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA59BF9),
          ),
        ],
      ),
    );
  }
}
