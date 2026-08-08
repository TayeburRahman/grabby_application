import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';
import '../../../../src_export.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<OrderBloc>().add(FetchOrderDetailsEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStaticStrings.orderTracking)),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == OrderStatus.failure) {
            return Center(child: CustomText(state.errorMessage ?? "Error"));
          }
          final order = state.selectedOrder;
          if (order == null) {
            return const Center(child: CustomText("Order not found"));
          }

          final branch = order.branchId is BranchInfo
              ? (order.branchId as BranchInfo)
              : null;
          final shopName = branch?.branchName ?? "Brew & Co";
          final shopAddress = branch?.address ?? "";

          // Map status to stepper index
          int currentStep = 0;
          switch (order.status?.toLowerCase()) {
            case "placed":
              currentStep = 0;
              break;
            case "preparing":
              currentStep = 1;
              break;
            case "ready":
              currentStep = 2;
              break;
            case "completed":
              currentStep = 3;
              break;
            default:
              currentStep = 0;
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchDetails(),
            child: SingleChildScrollView(
              padding: AppPadding.getPadding12(context),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            const CustomText(
                              AppStaticStrings.orderNumber,
                              fontSize: 12,
                              color: AppColors.kSecondaryTextColor,
                            ),
                            CustomText(
                              shopName,
                              fontSize: 12,
                              color: AppColors.kSecondaryTextColor,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 4,
                          children: [
                            CustomText(
                              "#${order.orderId ?? order.id}",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              order.status?.toUpperCase() ?? "",
                              fontSize: 12,
                              color: order.status == "ready"
                                  ? Colors.green
                                  : AppColors.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Stepper
                  OrderTrackingStepper(currentStep: currentStep),

                  // Pickup Info
                  const PickupInfoWidget(),

                  // Live Location Sharing
                  const LiveLocationSharingWidget(),

                  // Action Buttons
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: AppStaticStrings.navigateToShop,
                          iconPath: ImagesConstant.kNavigationIcon,
                          onPressed: () {
                            context.pushNamed(
                              RoutesPath.orderTrackingMapViewPath,
                              extra: order.id,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          text: AppStaticStrings.callShop,
                          iconPath: ImagesConstant.kCallIcon,
                          backgroundColor: AppColors.kSecondaryColor,
                          onPressed: () async {
                            log("Calling ${branch!.phoneNumber}");
                            if (branch?.phoneNumber != null) {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: branch!.phoneNumber,
                              );
                              await launchUrl(launchUri);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // Order Items
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      const CustomText(
                        AppStaticStrings.orderItems,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Column(
                        children: order.items.map((item) {
                          return Column(
                            children: [
                              TrackingOrderItem(
                                quantity: "${item.quantity}x",
                                title: item.menuName,
                                price:
                                    "AED ${item.totalPrice?.toStringAsFixed(2)}",
                              ),
                              if (item.additionalItems != null &&
                                  item.additionalItems!.isNotEmpty)
                                ...(item.additionalItems!
                                    .map(
                                      (e) => TrackingOrderItem(
                                        quantity: "+",
                                        title: e.name,
                                        price: "",
                                      ),
                                    )
                                    .toList()),
                            ],
                          );
                        }).toList(),
                      ),
                      const Divider(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            AppStaticStrings.orderTotal,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            "AED ${order.totalAmount.toStringAsFixed(2)}",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                  space12H,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
