import '../../../../src_export.dart';

class TrackingOrderItem extends StatelessWidget {
  final String quantity;
  final String title;
  final String price;

  const TrackingOrderItem({
    super.key,
    required this.quantity,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            "$quantity $title",
            fontSize: 14,
            color: AppColors.kSecondaryTextColor,
          ),
          CustomText(price, fontSize: 14, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
