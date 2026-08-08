import 'package:intl/intl.dart';
import '../../../../src_export.dart';

class ShopOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const ShopOrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final customer = order.customerId is CustomerInfo
        ? (order.customerId as CustomerInfo)
        : null;
    final customerName = customer?.name ?? "Customer";
    final pickupType = order.pickupType == "carPickup"
        ? "Car Pickup - ${order.carPlates}"
        : "Walk-in";
    final time = order.createdAt != null
        ? DateFormat('h:mm a').format(DateTime.parse(order.createdAt!))
        : "";
    final isPaid = order.paymentStatus?.toLowerCase() == "paid";

    return ButtonTapWidget(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: AppPadding.getPadding12(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(appRadius),
        ),
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      order.orderId ?? order.id ?? "",
                      variant: TextVariant.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      time,
                      variant: TextVariant.labelSmall,
                      color: AppColors.kSecondaryTextColor,
                    ),
                  ],
                ),
                _buildStatusBanner(order.status ?? ""),
              ],
            ),

            CustomText(
              customerName,
              variant: TextVariant.titleMedium,
              fontWeight: FontWeight.bold,
            ),

            // CustomText(
            //   "0 ${AppStaticStrings.ordersCount} \u2022 0 ${AppStaticStrings.stampsCount}",
            //   variant: TextVariant.labelSmall,
            //   color: AppColors.kSecondaryTextColor,
            // ),
            const Divider(height: 1, color: AppColors.kAccentColor),

            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "${item.quantity}x ${item.menuName}",
                      variant: TextVariant.bodyMedium,
                    ),
                    CustomText(
                      "AED ${item.totalPrice?.toStringAsFixed(2)}",
                      variant: TextVariant.titleSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: AppColors.kAccentColor),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    if (!isPaid) // User said "right now it will be unpaid just"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const CustomText(
                          "Unpaid",
                          variant: TextVariant.labelSmall,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    // Commented out "Customer Arrived" as requested
                    /*
                    if (hasArrived)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kSecondaryColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustomText(
                          AppStaticStrings.customerArrived,
                          variant: TextVariant.labelSmall,
                          color: AppColors.kSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    */
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(appRadius),
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(
                            order.pickupType == "carPickup"
                                ? Icons.directions_car_filled_outlined
                                : Icons.person_outline,
                            size: 16,
                            color: AppColors.kPrimaryColor,
                          ),
                          CustomText(
                            pickupType,
                            variant: TextVariant.labelSmall,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomText(
                  "AED ${order.totalAmount.toStringAsFixed(2)}",
                  variant: TextVariant.titleLarge,
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            if ((order.cancelNote?.isNotEmpty ?? false) &&
                order.cancelStatus == "pending")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const Divider(height: 1, color: AppColors.kAccentColor),
                  CustomText(
                    AppStaticStrings.reasonOfCancel,
                    variant: TextVariant.titleMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    order.cancelNote ?? "Not provided",
                    variant: TextVariant.bodyMedium,
                    color: AppColors.kTextColor,
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: AppStaticStrings.accept,
                          onPressed: () {
                            context.read<OrderBloc>().add(
                                  RespondToCancelEvent(
                                    orderId: order.id ?? "",
                                    action: "accept",
                                  ),
                                );
                          },
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<OrderBloc>().add(
                                  RespondToCancelEvent(
                                    orderId: order.id ?? "",
                                    action: "decline",
                                  ),
                                );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.kPrimaryColor,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const CustomText(
                            AppStaticStrings.decline,
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "placed":
        color = Colors.orange;
        break;
      case "preparing":
        color = AppColors.kBlueColor;
        break;
      case "ready":
        color = AppColors.kGreenColor;
        break;
      case "completed":
        color = AppColors.kSecondaryTextColor;
        break;
      default:
        color = AppColors.kPrimaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        spacing: 4,
        children: [
          Icon(
            status.toLowerCase() == "ready"
                ? Icons.check_circle_outline
                : Icons.access_time,
            size: 16,
            color: color,
          ),
          CustomText(
            status.toUpperCase(),
            variant: TextVariant.labelMedium,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
