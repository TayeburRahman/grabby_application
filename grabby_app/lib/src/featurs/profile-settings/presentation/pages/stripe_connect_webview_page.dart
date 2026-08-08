import 'package:webview_flutter/webview_flutter.dart';
import '../../../../src_export.dart';


class StripeConnectWebviewPage extends StatefulWidget {
  final String onboardingUrl;

  const StripeConnectWebviewPage({
    super.key,
    required this.onboardingUrl,
  });

  @override
  State<StripeConnectWebviewPage> createState() =>
      _StripeConnectWebviewPageState();
}

class _StripeConnectWebviewPageState extends State<StripeConnectWebviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Stripe Connect page started loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            _handleUrlRedirection(url);
          },
          onPageFinished: (String url) {
            debugPrint('Stripe Connect page finished loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_handleUrlRedirection(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.onboardingUrl));
  }

  bool _handleUrlRedirection(String url) {
    if (url.contains('stripe-connect/return') || url.contains('return_url')) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          'Stripe Connect onboarding completed successfully!',
          isError: false,
        );
        Navigator.pop(context, true);
      }
      return true;
    } else if (url.contains('stripe-connect/refresh')) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          'Onboarding link expired or cancelled. Please try again.',
          isError: true,
        );
        Navigator.pop(context, false);
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          AppStaticStrings.connectBankAccount,
          variant: TextVariant.titleMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
