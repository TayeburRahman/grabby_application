import 'dart:async';
import 'dart:convert';

import 'package:foloosi_plugins/foloosi_plugins.dart';
import '../../../../src_export.dart';

class PaymentPage extends StatefulWidget {
  final OrderModel order;
  const PaymentPage({super.key, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  // ⚠️ Dollar sign ($) গুলো escape করা হয়েছে \$ দিয়ে
  // Production-এ backend থেকে load করুন
  static const String _merchantKey =
      'test_\$2y\$10\$yoK80pKrWVZTc-knSG9.7eYT98X4efBTa.N7sFgToeSPXXRnlgrCG';
  // static const String _merchantKey =
  //     'live_\$2y\$10\$6O0mhc6Iq.KtV2xyGFLaw.FEdhsn64OR7a9jV9zxvJ9ugSjck14IS';
  Future<void> _startFoloosiPayment() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // Step 1: Init SDK with merchantKey + custom color
      final initData = {
        "merchantKey": _merchantKey,
        "customColor": "#A59BF9", // তোমার app-এর primary color
      };
      await FoloosiPlugins.init(json.encode(initData));

      FoloosiPlugins.setLogVisible(true); // debug-এ true, production-এ false

      final profileState = context.read<ProfileBloc>().state;
      final profile = profileState is ProfileLoaded ? profileState.profileData : null;

      // Step 2: Payment payload
      final paymentData = {
        "orderId":
            widget.order.orderId ??
            "ORD${DateTime.now().millisecondsSinceEpoch}",
        "orderDescription": "Grabby Order Payment",
        "orderAmount": widget.order.totalAmount,
        "state": "",
        "postalCode": "000000", // UAE
        "country": "ARE", // ISO 3-digit
        "currencyCode": "AED",
        "customerUniqueReference": widget.order.orderId ?? "",
        "customer": {
          "name": profile?.name ?? "Customer",
          "email": profile?.email ?? "",
          "mobile": profile?.phoneNumber ?? "",
          "code": "+971",
          "address": profile?.addressName ?? "",
          "city": "Dubai",
        },
      };

      // Step 3: Launch Foloosi payment screen
      final result = await FoloosiPlugins.makePayment(json.encode(paymentData));

      if (!mounted) return;
      setState(() => _isProcessing = false);

      if (result != null) {
        _handlePaymentResult(result);
      } else {
        _showError("Payment was cancelled.");
      }
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      _showError("Payment failed: ${e.toString()}");
    }
  }

  void _handlePaymentResult(dynamic result) {
    debugPrint("Foloosi Payment Result: $result");

    try {
      final data = result is String ? json.decode(result) : result;
      final status = data['status']?.toString().toLowerCase();

      if (status == 'success' ||
          status == '1' ||
          data['transaction_no'] != null) {
        final transactionNo =
            data['transaction_no'] ?? data['data']?['transaction_no'] ?? '';

        context.pushReplacementNamed(
          RoutesPath.paymentSuccessPath,
          extra: widget.order,
        );
      } else {
        _showError("Payment not completed. Status: $status");
      }
    } catch (_) {
      // result string-ই success message হতে পারে
      context.pushReplacementNamed(
        RoutesPath.paymentSuccessPath,
        extra: widget.order,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStaticStrings.payment)),
      body: SingleChildScrollView(
        padding: AppPadding.getPadding12(context),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup Details
            _buildSection(
              title: AppStaticStrings.pickupDetails,
              child: PickupDetailItem(
                icon: ImagesConstant.kCarIcon,
                title: widget.order.pickupType == "carPickup"
                    ? AppStaticStrings.carPickup
                    : AppStaticStrings.counterPickup,
                subtitle: widget.order.carPlates ?? "",
                iconColor: Colors.white,
                backgroundColor: AppColors.kPrimaryColor,
              ),
            ),

            // Payment Method — Foloosi
            _buildSection(
              title: AppStaticStrings.paymentMethod,
              child: _buildFoloosiCard(),
            ),

            // Order Summary
            Column(
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      AppStaticStrings.orderNumber,
                      fontSize: 14,
                      color: AppColors.kSecondaryTextColor,
                    ),
                    CustomText(
                      widget.order.orderId ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      AppStaticStrings.orderTotal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      "${widget.order.totalAmount.toStringAsFixed(2)} AED",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFA59BF9),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppPadding.getPadding12(context).copyWith(bottom: 24),
        child: CustomButton(
          text: _isProcessing ? "Processing..." : "Pay with Foloosi",
          onPressed: () {
            _isProcessing ? null : _startFoloosiPayment();
          },
        ),
      ),
    );
  }

  Widget _buildFoloosiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kPrimaryColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'F',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Foloosi',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 2),
                CustomText(
                  'Credit / Debit Card · Apple Pay · Samsung Pay',
                  fontSize: 11,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.kPrimaryColor,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        CustomText(title, fontSize: 16, fontWeight: FontWeight.bold),
        child,
      ],
    );
  }
}
