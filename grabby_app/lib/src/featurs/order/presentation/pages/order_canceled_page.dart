import '../../../../src_export.dart';

class OrderCanceledPage extends StatefulWidget {
  final String orderId;
  const OrderCanceledPage({super.key, required this.orderId});

  @override
  State<OrderCanceledPage> createState() => _OrderCanceledPageState();
}

class _OrderCanceledPageState extends State<OrderCanceledPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderBloc>(),
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.success &&
              state.successMessage != null) {
            CustomSnackbar.show(context, state.successMessage!);
            context.go(RoutesPath.navigationPath);
          } else if (state.status == OrderStatus.failure &&
              state.errorMessage != null) {
            CustomSnackbar.show(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == OrderStatus.loading;

          return Scaffold(
            appBar: AppBar(title: Text(AppStaticStrings.orderCanceled)),
            body: Padding(
              padding: AppPadding.getPadding12(context),
              child: Column(
                spacing: 12,
                children: [
                  // Order Number Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        CustomText(
                          AppStaticStrings.orderNumber,
                          fontSize: 12,
                          color: AppColors.kSecondaryTextColor,
                        ),
                        CustomText(
                          widget.orderId,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  // Cancellation Status Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const CustomText(
                            AppStaticStrings.cancelled,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomTextField(
                            title: AppStaticStrings.reasonOfCancel,
                            textEditingController: reasonController,
                            maxLines: 3,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F2FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const CustomText(
                              AppStaticStrings.refundAsCredit,
                              textAlign: TextAlign.center,
                              fontSize: 12,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<OrderBloc>().add(
                                CancelOrderEvent(
                                  widget.orderId,
                                  cancelNote: reasonController.text,
                                ),
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.kPrimaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : const CustomText(
                              AppStaticStrings.cancelOrder,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                  // Back to Home Button
                  CustomButton(
                    text: AppStaticStrings.backToHome,
                    onPressed: () {
                      context.go(RoutesPath.navigationPath);
                    },
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
