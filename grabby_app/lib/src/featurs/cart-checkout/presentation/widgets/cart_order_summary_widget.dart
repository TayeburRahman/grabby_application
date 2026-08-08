import '../../../../src_export.dart';

class CartOrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double total;
  final double? discount;
  final double? credit;

  const CartOrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.total,
    this.discount,
    this.credit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        spacing: 10,
        children: [
          // Subtotal row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                AppStaticStrings.subtotal,
                fontSize: 14,
                color: AppColors.kSecondaryTextColor,
              ),
              CustomText(
                '${AppStaticStrings.aedPrefix}${subtotal.toStringAsFixed(2)}',
                fontSize: 14,
                color: AppColors.kSecondaryTextColor,
              ),
            ],
          ),
          if (discount != null && discount! > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  AppStaticStrings.discountAmount,
                  fontSize: 14,
                  color: AppColors.kSecondaryTextColor,
                ),
                CustomText(
                  '- ${AppStaticStrings.aedPrefix}${discount?.toStringAsFixed(2)}',
                  fontSize: 14,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ),
          if (credit != null && credit! > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  AppStaticStrings.credit,
                  fontSize: 14,
                  color: AppColors.kSecondaryTextColor,
                ),
                CustomText(
                  '- ${AppStaticStrings.aedPrefix}${credit?.toStringAsFixed(2)}',
                  fontSize: 14,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ),
          const Divider(height: 1),
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                AppStaticStrings.total,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextColor,
              ),
              CustomText(
                '${AppStaticStrings.aedPrefix}${total.toStringAsFixed(2)}',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
