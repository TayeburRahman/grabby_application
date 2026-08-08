import '../../../../src_export.dart';

class DeleteDiscountDialog extends StatelessWidget {
  final String discountName;

  const DeleteDiscountDialog({super.key, required this.discountName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: AppPadding.getPadding24(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kRedColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.kRedColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            CustomText(
              AppStaticStrings.deleteDiscount,
              variant: TextVariant.headlineSmall,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.kSecondaryTextColor,
                  fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
                ),
                children: [
                  const TextSpan(
                    text: "${AppStaticStrings.areYouSureDeleteDiscount} ",
                  ),
                  TextSpan(
                    text: discountName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.kTextColor,
                    ),
                  ),
                  const TextSpan(text: "?\n"),
                  const TextSpan(
                    text: AppStaticStrings.thisActionCannotBeUndone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: AppStaticStrings.yesDelete,
              onPressed: () => context.pop(true),
              backgroundColor: AppColors.kRedColor,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: AppStaticStrings.cancel,
              onPressed: () => context.pop(false),
              // backgroundColor: Colors.grey,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
