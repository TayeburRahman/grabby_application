import '../../../../src_export.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final String? discount;
  final VoidCallback onAdd;
  final bool hasDiscount;
  final String? originalPrice;

  const MenuItemWidget({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    this.discount,
    required this.onAdd,
    this.hasDiscount = false,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: () {
        onAdd();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Item Image with optional Discount Tag
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: image,
                  height: 80,
                  width: 80,
                  radius: 12,
                ),
                if (hasDiscount == true)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5C5C),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: CustomText(
                        discount ?? '',
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Title and Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                   Row(
                    children: [
                      if (hasDiscount && originalPrice != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CustomText(
                            originalPrice!,
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      CustomText(
                        price,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kPrimaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
