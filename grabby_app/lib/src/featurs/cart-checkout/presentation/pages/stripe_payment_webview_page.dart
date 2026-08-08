import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../src_export.dart';

class StripePaymentWebviewPage extends StatefulWidget {
  final OrderModel order;
  final String paymentUrl;

  const StripePaymentWebviewPage({
    super.key,
    required this.order,
    required this.paymentUrl,
  });

  @override
  State<StripePaymentWebviewPage> createState() =>
      _StripePaymentWebviewPageState();
}

class _StripePaymentWebviewPageState extends State<StripePaymentWebviewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            _handleUrlRedirection(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_handleUrlRedirection(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _handleUrlRedirection(String url) {
    if (url.contains('payment-success')) {
      _showPopup(true);
      return true;
    } else if (url.contains('payment-cancel')) {
      _showPopup(false);
      return true;
    }
    return false;
  }

  void _showPopup(bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Payment Successful' : 'Payment Failed'),
          content: Text(
            isSuccess
                ? 'Your payment was processed successfully.'
                : 'Your payment was cancelled or failed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (isSuccess) {
                  context.pushReplacementNamed(
                    RoutesPath.paymentSuccessPath,
                    extra: widget.order,
                  );
                } else {
                  context.pop(); // Go back to cart or previous page
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
