import '../../../../src_export.dart';

class CartItemWithStepperCard extends StatelessWidget {
  final String title;
  final String description;
  final int quantity;
  final double price;
  final String? imageUrl;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemWithStepperCard({
    super.key,
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    this.imageUrl,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null
                ? CustomNetworkImage(
                    imageUrl: "${ApiEndpoints.baseUrl}/${imageUrl ?? ""}",
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.kBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_cafe_rounded,
                      color: AppColors.kPrimaryColor,
                      size: 30,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Middle: title + stepper
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                CustomText(title, fontSize: 15, fontWeight: FontWeight.bold),
                // Stepper row
                Row(
                  spacing: 10,
                  children: [
                    _StepBtn(icon: Icons.remove, onTap: onDecrement),
                    CustomText(
                      '$quantity',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    _StepBtn(icon: Icons.add, onTap: onIncrement, filled: true),
                  ],
                ),
              ],
            ),
          ),
          // Right: delete icon + price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 12,
            children: [
              ButtonTapWidget(
                onTap: onDelete,
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.kSecondaryTextColor,
                  size: 22,
                ),
              ),
              CustomText(
                '${AppStaticStrings.aedPrefix}${price.toStringAsFixed(2)}',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _StepBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? AppColors.kPrimaryColor : AppColors.kBackgroundColor,
          borderRadius: BorderRadius.circular(appRadius),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : AppColors.kSecondaryTextColor,
        ),
      ),
    );
  }
}
