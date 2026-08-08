import 'package:intl/intl.dart';
import '../../../../src_export.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final branch = order.branchId is BranchInfo
        ? (order.branchId as BranchInfo)
        : null;
    final shopName = branch?.branchName ?? "Brew & Co";
    final isActive = [
      "placed",
      "preparing",
      "ready",
    ].contains(order.status?.toLowerCase());

    return Container(
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(shopName, fontSize: 16, fontWeight: FontWeight.bold),
              _buildStatusBadge(order.status ?? ""),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              CustomText(
                "${AppStaticStrings.order} ${order.orderId ?? order.id}",
                fontSize: 14,
                color: AppColors.kTextColor,
                fontWeight: FontWeight.w600,
              ),
              Row(
                spacing: 12,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        ImagesConstant.kCarIcon,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          AppColors.kSecondaryTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      CustomText(
                        "${order.pickupType == "carPickup" ? "Car" : "Walk-in"} - ${order.carPlates ?? ""}",
                        fontSize: 13,
                        color: AppColors.kSecondaryTextColor,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.kSecondaryTextColor,
                      ),
                      CustomText(
                        order.createdAt != null
                            ? DateFormat(
                                'MMM d, h:mm a',
                              ).format(DateTime.parse(order.createdAt!))
                            : "",
                        fontSize: 13,
                        color: AppColors.kSecondaryTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "${order.items.length} ${AppStaticStrings.itemsCount}",
                fontSize: 14,
                color: AppColors.kSecondaryTextColor,
              ),
              CustomText(
                "${order.totalAmount.toStringAsFixed(2)} AED",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          if (isActive)
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppStaticStrings.trackOrder,
                    onPressed: () {
                      context.pushNamed(
                        RoutesPath.orderTrackingPath,
                        extra: order.id,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pushNamed(
                        RoutesPath.orderCanceledPath,
                        extra: order.id,
                      );
                    },
                    // onPressed: () {

                    //   context.read<OrderBloc>().add(CancelOrderEvent(order.id ?? ""));
                    // },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.kPrimaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const CustomText(
                      AppStaticStrings.cancelOrder,
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isCompleted = status.toLowerCase() == "completed";
    bool isCancelled = status.toLowerCase() == "cancelled";

    Color bgColor = const Color(0xFFFFF3E0);
    Color textColor = Colors.orange;
    IconData icon = Icons.card_giftcard;

    if (isCompleted) {
      bgColor = const Color(0xFFE8F5E9);
      textColor = Colors.green;
      icon = Icons.check_circle_outline;
    } else if (isCancelled) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red;
      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 14, color: textColor),
          CustomText(
            status.toUpperCase(),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
