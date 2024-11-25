// import 'package:flutter/material.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// class MainPages extends StatefulWidget {
//   const MainPages({super.key});

//   @override
//   State<MainPages> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPages> {
//   late WebViewControllerPlus _controler;
//   static const String symbolName = 'NPTC';
//   static const String ExchangeSegment = 'IDK';
//   static const String authToken =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDAzMV9mOWFiYjk0NjZmNTBhZTg0MTE5Mjg0IiwicHVibGljS2V5IjoiZjlhYmI5NDY2ZjUwYWU4NDExOTI4NCIsImlhdCI6MTczMTk5NjUwOSwiZXhwIjoxNzMyMDgyOTA5fQ.yQM1goADoMPeSN-HxwBo7uAADFPGuRNZLAT6tVJZ8OY';
//   @override
//   void initState() {
//     _controler = WebViewControllerPlus()
//       ..loadFlutterAssetServer(
//         'assets/charting_library/index.html',
//       ).then((value) {
//         _controler.addJavaScriptChannel(
//           'loadChart',
//           onMessageReceived: (message) {
//             print('Chart loaded successfully.');
//             _controler.runJavaScript("window.SetSymbolName('$symbolName');");
//             _controler.runJavaScript("window.setExchange('$ExchangeSegment');");
//             _controler
//                 .runJavaScript("window.setAuthToken('$authToken');");
//           },
//         );
//         print('Loaded charting library.');
//         _controler.setJavaScriptMode(JavaScriptMode.unrestricted);
//       });
//     _controler.setJavaScriptMode(JavaScriptMode.unrestricted);

//     _controler.runJavaScript("window.loadChart('$symbolName');");

//     print('Chart loaded successfully.');
//     _controler.runJavaScript("window.SetSymbolName('$symbolName');");
//     _controler.runJavaScript("window.setExchange('$ExchangeSegment');");
//     _controler.runJavaScript("window.setAuthToken('$ExchangeSegment');");

//     _controler.setJavaScriptMode(JavaScriptMode.unrestricted);
//     _controler.goBack();
//     _controler.enableZoom(false);
//     _controler.setBackgroundColor(const Color(0x00000000));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('ssMain Page'),
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: WebViewWidget(
//           controller: _controler,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controler.server.close();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartingFromTV extends StatefulWidget {
  ChartingFromTV(this.SymbolName);
  final String SymbolName;
  @override
  _ChartingFromTVState createState() => _ChartingFromTVState();
}

class _ChartingFromTVState extends State<ChartingFromTV> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("${widget.SymbolName}"),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        body: Stack(
          children: [
            WebView(
              onProgress: (int progress) {
                setState(() {
                  _isLoading = progress < 100;
                });
              },
              initialUrl:
                  'https://www.tradingview.com/chart/?symbol=${widget.SymbolName}',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }
}
