import '../../../../src_export.dart';

class ProfileMetricCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const ProfileMetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              icon,
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(value, fontSize: 18, fontWeight: FontWeight.bold),
              CustomText(
                label,
                fontSize: 12,
                color: AppColors.kSecondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
