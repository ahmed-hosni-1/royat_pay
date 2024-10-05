import 'package:flutter/material.dart';
import 'package:royat_pay/models/redirect_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RoyatIFrame extends StatefulWidget {
  RoyatIFrame({
    Key? key,
    required this.redirectResponse,
    required this.onSuccess,
  }) : super(key: key);
  RedirectResponse redirectResponse;
  Function onSuccess;

  static Future<RedirectResponse?> show(
          {required BuildContext context,
          required Function onSuccess,
          required RedirectResponse redirectResponse}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return RoyatIFrame(
              redirectResponse: redirectResponse,
              onSuccess: onSuccess,
            );
          },
        ),
      );

  @override
  State<RoyatIFrame> createState() => _RoyatIFrameState();
}

class _RoyatIFrameState extends State<RoyatIFrame> {
  WebViewController? controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://royat.sa')) {
              Navigator.pop(context);
              widget.onSuccess();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectResponse.url!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: WebViewWidget(
                controller: controller!,
              ),
            ),
    );
  }

  Map<String, dynamic> _getParamFromURL(String url) {
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {};
    uri.queryParameters.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}
