import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/routes/app_routes.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final args = Get.arguments;
  String url = '';
  String title = '';
  @override
  void initState() {
    if (args != null && args is List) {
      url = args[0];
      title = args[1];
    }
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  var isLoading = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              userAgent: "mobile_device",
              navigationDelegate: (NavigationRequest request) {
                print(request.url);
                if (request.url.contains("xendit-payment-succes")) {
                  Get.back();
                  // do not navigate
                }

                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              onPageFinished: (finish) => isLoading.value = false,
            ),
          ),
          Obx(
            () => Visibility(
              visible: isLoading.value,
              child: Center(
                child: SpinKitFadingCircle(
                  color: mainColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
