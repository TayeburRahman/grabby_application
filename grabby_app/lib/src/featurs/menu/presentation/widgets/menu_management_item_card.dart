import '../../../../src_export.dart';

class MenuManagementItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String image;
  final String category;
  final bool isAvailable;
  final String? outOfStockCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleVisibility;
  final bool isVisible;
  final bool isDiscount;
  final double? originalPrice;
  final double? discountParcent;
  final String? eventName;

  const MenuManagementItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.isAvailable = true,
    this.outOfStockCount,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleVisibility,
    this.isVisible = true,
    this.isDiscount = false,
    this.originalPrice,
    this.discountParcent,
    this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(
              imageUrl: "${ApiEndpoints.baseUrl}/$image",
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        title,
                        variant: TextVariant.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        if (isDiscount) ...[
                          CustomText(
                            "AED ${originalPrice?.toStringAsFixed(2)}",
                            variant: TextVariant.bodySmall,
                            fontWeight: FontWeight.normal,
                            color: AppColors.kTextColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                          CustomText(
                            price,
                            variant: TextVariant.titleMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryColor,
                          ),
                          
                          // CustomText(
                          //   "AED ${discountParcent?.toStringAsFixed(2)}%",
                          //   variant: TextVariant.titleMedium,
                          //   fontWeight: FontWeight.bold,
                          //   color: AppColors.kPrimaryColor,
                          // ),
                          // CustomText(
                          //   eventName ?? "",
                          //   variant: TextVariant.labelSmall,
                          //   color: AppColors.kSecondaryTextColor,
                          // ),
                        ] else
                          CustomText(
                            price,
                            variant: TextVariant.titleMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryColor,
                          ),
                      ],
                    ),
                  ],
                ),
                CustomText(
                  description,
                  variant: TextVariant.labelSmall,
                  color: AppColors.kSecondaryTextColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xffE8F5E9)
                            : const Color(0xffFFEBEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isAvailable ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            isAvailable
                                ? AppStaticStrings.availableStatus
                                : AppStaticStrings.outOfStock,
                            fontSize: 10,
                            color: isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category Badge
                    CustomText(
                      category,
                      variant: TextVariant.labelSmall,
                      color: AppColors.kSecondaryTextColor,
                    ),
                    // if (outOfStockCount != null) ...[
                    //   const Spacer(),
                    //   CustomText(
                    //     "${AppStaticStrings.outOfStock}: $outOfStockCount",
                    //     variant: TextVariant.labelSmall,
                    //     color: Colors.green,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ],
                  ],
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.edit_outlined,
                        label: AppStaticStrings.edit,
                        onTap: onEdit,
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.delete_outline,
                        label: AppStaticStrings.delete,
                        onTap: onDelete,
                        color: const Color(0xffFFEBEE),
                        textColor: Colors.red,
                        iconColor: Colors.red,
                      ),
                    ),
                    // Expanded(
                    //   child: _buildActionButton(
                    //     icon: isVisible
                    //         ? Icons.visibility_off_outlined
                    //         : Icons.visibility_outlined,
                    //     label: isVisible
                    //         ? AppStaticStrings.hide
                    //         : AppStaticStrings.show,
                    //     onTap: onToggleVisibility,
                    //     color: const Color(0xffF5F5F5),
                    //     textColor: AppColors.kSecondaryTextColor,
                    //     iconColor: AppColors.kSecondaryTextColor,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Color? textColor,
    Color? iconColor,
  }) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor ?? Colors.white),
            const SizedBox(width: 4),
            CustomText(
              label,
              fontSize: 12,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
