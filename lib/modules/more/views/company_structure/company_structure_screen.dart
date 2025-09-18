import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key});

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    final jsonString = CacheHelper.getString("USG");
    Map<String, dynamic>? gCache;
    if (jsonString != null && jsonString.isNotEmpty) {
      gCache = json.decode(jsonString) as Map<String, dynamic>;
    }

    final url = gCache?['company_structure_url'] ?? "https://www.google.com/";

    controller = WebViewController();

    if (!kIsWeb) {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted) // ✅ شغالة على موبايل بس
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => loadingPercentage = 0),
            onProgress: (progress) => setState(() => loadingPercentage = progress),
            onPageFinished: (_) => setState(() => loadingPercentage = 100),
          ),
        )
        ..addJavaScriptChannel(
          'SnackBar',
          onMessageReceived: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        );
    }

    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ✅ WebView supported via webview_flutter_web
      return Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (loadingPercentage < 100)
              LinearProgressIndicator(value: loadingPercentage / 100.0),
          ],
        ),
      );
    }

    // ✅ Mobile (Android/iOS)
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(value: loadingPercentage / 100.0),
        ],
      ),
    );
  }
}
