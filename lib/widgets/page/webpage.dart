import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../button/icon_button.dart';
import '../headers/main.dart';

class WebPage extends StatefulWidget {
  final String title;
  final String url;

  const WebPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  bool isLoading = true;
  double loadingProgress = 0;
  late WebViewController myWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomAppBar(
              title: widget.title,
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          automaticallyImplyLeading: false),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onWebViewCreated: (controller) {
              myWebViewController = controller;
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            onProgress: (value) {
              setState(() {
                loadingProgress = value.toDouble();
              });
            },
          ),
          isLoading
              ? LinearProgressIndicator(
                  minHeight: 3,
                  valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                  value: (loadingProgress * 0.01),
                )
              : Stack(),
        ],
      ),
    );
  }
}
