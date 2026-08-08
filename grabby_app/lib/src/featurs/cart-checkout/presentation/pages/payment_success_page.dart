
import '../../../../src_export.dart';

class PaymentSuccessPage extends StatelessWidget {
  final OrderModel order;
  const PaymentSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FF),
      body: Padding(
        padding: AppPadding.getPadding12(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            const Spacer(),
            // Success Icon
            Container(
              padding: AppPadding.getPadding12(context),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                ImagesConstant.kSuccesfullIcon,
                height: 80,
              ),
            ),
            Column(
              spacing: 8,
              children: [
                const CustomText(
                  AppStaticStrings.paymentSuccessful,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  "Your order has been placed successfully",
                  fontSize: 16,
                  color: AppColors.kSecondaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        AppStaticStrings.orderNumber,
                        color: AppColors.kSecondaryTextColor,
                      ),
                      CustomText("#${order.orderId ?? order.id}", fontWeight: FontWeight.bold),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        AppStaticStrings.totalPaid,
                        color: AppColors.kSecondaryTextColor,
                      ),
                      CustomText(
                        "${order.totalAmount.toStringAsFixed(2)} AED",
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA59BF9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Action Buttons
            Column(
              spacing: 12,
              children: [
                CustomButton(
                  text: AppStaticStrings.trackOrder,
                  onPressed: () {
                    context.pushNamed(RoutesPath.orderTrackingMapViewPath, extra: order.id);
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go(RoutesPath.navigationPath);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFA59BF9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const CustomText(
                      AppStaticStrings.backToHome,
                      color: Color(0xFFA59BF9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
