import '../../../../src_export.dart';

class ShopOrderItemWidget extends StatelessWidget {
  final String id;
  final String name;
  final String items;
  final String status;
  final String price;
  final String time;
  final Color statusColor;

  const ShopOrderItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.items,
    required this.status,
    required this.price,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  id,
                  variant: TextVariant.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  "$name \u2022 $items",
                  variant: TextVariant.bodyMedium,
                  color: AppColors.kSecondaryTextColor,
                ),
                const SizedBox(height: 8),
                _buildStatusChip(status, statusColor),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                price,
                variant: TextVariant.titleMedium,
                color: AppColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                time,
                variant: TextVariant.labelSmall,
                color: AppColors.kSecondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            label == AppStaticStrings.ready
                ? Icons.check_circle_outline
                : Icons.info_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          CustomText(
            label,
            variant: TextVariant.labelSmall,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
