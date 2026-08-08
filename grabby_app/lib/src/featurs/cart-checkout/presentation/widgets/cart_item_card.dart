import '../../../../src_export.dart';

class CartItemCard extends StatelessWidget {
  final String quantity;
  final String title;
  final String description;
  final String price;

  const CartItemCard({
    super.key,
    required this.quantity,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(quantity, fontSize: 18, fontWeight: FontWeight.bold),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, fontSize: 18, fontWeight: FontWeight.bold),
                CustomText(
                  description,
                  fontSize: 14,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ),
          ),
          CustomText(price, fontSize: 16, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
