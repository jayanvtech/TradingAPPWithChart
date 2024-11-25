

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrendlyneWidgetScreen extends StatefulWidget {
  TrendlyneWidgetScreen(this.SymbolName);
  final String SymbolName;
  @override
  _TrendlyneWidgetScreenState createState() => _TrendlyneWidgetScreenState();
}

class _TrendlyneWidgetScreenState extends State<TrendlyneWidgetScreen> {
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
        body: Stack(
      children: [
        WebView(
       
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets(widget.SymbolName);
          },
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ));
  }

  void _loadHtmlFromAssets(String SymbolName) async {
    String htmlContent = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Trendlyne Widget</title>
    </head>
    <body>
      <blockquote class="trendlyne-widgets" data-get-url="https://trendlyne.com/web-widget/swot-widget/Poppins/$SymbolName/?posCol=00A25B&primaryCol=006AFF&negCol=EB3B00&neuCol=F7941E" data-theme="light"></blockquote>
      <script async src="https://cdn-static.trendlyne.com/static/js/webwidgets/tl-widgets.js" charset="utf-8"></script>
    </body>
    </html>
    ''';

    _controller.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}


class TechnicalAnalysisWidgetScreen extends StatefulWidget {
  TechnicalAnalysisWidgetScreen(this.SymbolName);
  final String SymbolName;

  @override
  _TechnicalAnalysisWidgetScreenState createState() =>
      _TechnicalAnalysisWidgetScreenState();
}

class _TechnicalAnalysisWidgetScreenState
    extends State<TechnicalAnalysisWidgetScreen> {
  late WebViewController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WebViewController _controller;
    String htmlContent = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Trendlyne Widget</title>
    </head>
    <body>
      <blockquote class="trendlyne-widgets" data-get-url="https://trendlyne.com/web-widget/technical-widget/Inter/${widget.SymbolName}?posCol=00A25B&primaryCol=006AFF&negCol=EB3B00&neuCol=F7941E" data-theme="light"></blockquote>
      <script async src="https://cdn-static.trendlyne.com/static/js/webwidgets/tl-widgets.js" charset="utf-8"></script>
    </body>
    </html>
    ''';
    // _controller.loadHtmlString(htmlContent);
    // Initialize WebView controller
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          WebView(
            initialUrl: '',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets(widget.SymbolName);
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
        
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _loadHtmlFromAssets(String SymbolName) async {
    String htmlContent = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Trendlyne Widget</title>
    </head>
    <body>
      <blockquote class="trendlyne-widgets" data-get-url="https://trendlyne.com/web-widget/technical-widget/Inter/$SymbolName?posCol=00A25B&primaryCol=006AFF&negCol=EB3B00&neuCol=F7941E" data-theme="light"></blockquote>
      <script async src="https://cdn-static.trendlyne.com/static/js/webwidgets/tl-widgets.js" charset="utf-8"></script>
    </body>
    </html>
    ''';

    // Loading the HTML content using the controller.
   _controller.loadHtmlString(htmlContent);
  }
  
}

class CheckBeforeBuyWidgetScreen extends StatefulWidget {
  CheckBeforeBuyWidgetScreen(this.SymbolName);
  final String SymbolName;
  @override
  _CheckBeforeBuyWidgetScreenState createState() =>
      _CheckBeforeBuyWidgetScreenState();
}

class _CheckBeforeBuyWidgetScreenState
    extends State<CheckBeforeBuyWidgetScreen> {
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
        body: Stack(
      children: [
        WebView(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets(widget.SymbolName);
          },
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ));
  }

  void _loadHtmlFromAssets(String SymbolName) async {
    String htmlContent = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Trendlyne Widget</title>
    </head>
    <body>
      <blockquote class="trendlyne-widgets" data-get-url="https://trendlyne.com/web-widget/checklist-widget/Inter/$SymbolName/?posCol=00A25B&primaryCol=006AFF&negCol=EB3B00&neuCol=F7941E" data-theme="light"></blockquote>
      <script async src="https://cdn-static.trendlyne.com/static/js/webwidgets/tl-widgets.js" charset="utf-8"></script>
    </body>
    </html>
    ''';
    _controller.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class TradingViewWidgetScreen extends StatefulWidget {
  TradingViewWidgetScreen(this.SymbolName);
  final String SymbolName;
  @override
  _TradingViewWidgetScreenState createState() =>
      _TradingViewWidgetScreenState();
}

class _TradingViewWidgetScreenState extends State<TradingViewWidgetScreen> {
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
        body: Row(
      children: [
        WebView(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets(widget.SymbolName);
          },
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ));
  }

  void _loadHtmlFromAssets(String SymbolName) async {
    final String tradingViewHtml = '''
       <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body, html {
              margin: 0;
              padding: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
            }
          </style>
        </head>
        <body>
          <div class="tradingview-widget-container">
            <div id="tradingview_finanicals"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-financials.js" async>
            {
              "isTransparent": true,
              "largeChartUrl": "",
              "displayMode": "regular",
              "width": "100%",
              "height": "100%",
              "colorTheme": "light",
              "symbol": "NSE:$SymbolName",
              "locale": "en"
            }
            </script>
          </div>
        </body>
      </html>
    ''';
    _controller.loadUrl(Uri.dataFromString(tradingViewHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class CompanyProfileWidgetScreen extends StatefulWidget {
  CompanyProfileWidgetScreen(this.SymbolName);
  final String SymbolName;
  @override
  _CompanyProfileWidgetScreenState createState() =>
      _CompanyProfileWidgetScreenState();
}

class _CompanyProfileWidgetScreenState
    extends State<CompanyProfileWidgetScreen> {
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
        body: Stack(
      children: [
        WebView(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets(widget.SymbolName);
          },
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ));
  }

  void _loadHtmlFromAssets(String SymbolName) async {
    final String tradingViewHtml = '''
    
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>
<div class="tradingview-widget-container">
<div id="tradingview_4418d">
</div>
<div class="tradingview-widget-copyright">
<a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank">
<span class="blue-text">Track all markets on TradingView
</span>
</a>
</div>
<script type="text/javascript" src="https://s3.tradingview.com/tv.js">
</script>
<script type="text/javascript">
new TradingView.widget({
  "width": "100%",
  "height": 1180,
  "symbol": "NSE:$SymbolName",
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "dark",
  "style": "1",
  "locale": "en",
  "toolbar_bg": "#121536",

  "backgroundColor": "rgba(18, 21, 54, 1)",
  "enable_publishing": false,
  "save_image": false,
  "container_id": "tradingview_4418d"
  });
</script>
</div>
</body>
</html>
    ''';
    _controller.loadUrl(Uri.dataFromString(tradingViewHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class GLobleIndicesWidgetScreen extends StatefulWidget {
  @override
  _GLobleIndicesWidgetScreenState createState() =>
      _GLobleIndicesWidgetScreenState();
}

class _GLobleIndicesWidgetScreenState extends State<GLobleIndicesWidgetScreen> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print("==========================${height}");
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: WebView(
                onProgress: (int progress) {
                  setState(() {
                    _isLoading = progress < 100;
                  });
                },
                zoomEnabled: false,
                initialUrl: '',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  _loadHtmlFromAssets(width.toInt(), height.toInt());
                },
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }

  void _loadHtmlFromAssets(int width, int hight) async {
    String htmlContent = '''
 <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
     <!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-market-overview.js" async>
  {
  "colorTheme": "light",
  "dateRange": "1D",
  "showChart": true,
  "locale": "en",
  "width": "100%",
  "height": "800",
  "largeChartUrl": "",
  "isTransparent": true,
  "showSymbolLogo": true,
  "showFloatingTooltip": true,
  "plotLineColorGrowing": "rgba(41, 98, 255, 1)",
  "plotLineColorFalling": "rgba(41, 98, 255, 1)",
  "gridLineColor": "rgba(42, 46, 57, 0)",
  "scaleFontColor": "rgba(209, 212, 220, 1)",
  "belowLineFillColorGrowing": "rgba(41, 98, 255, 0.12)",
  "belowLineFillColorFalling": "rgba(41, 98, 255, 0.12)",
  "belowLineFillColorGrowingBottom": "rgba(41, 98, 255, 0)",
  "belowLineFillColorFallingBottom": "rgba(41, 98, 255, 0)",
  "symbolActiveColor": "rgba(41, 98, 255, 0.12)",
  "tabs": [
    {
      "title": "Indices",
      "symbols": [
        {
          "s": "FOREXCOM:SPXUSD",
          "d": "S&P 500 Index"
        },
        {
          "s": "FOREXCOM:NSXUSD",
          "d": "US 100 Cash CFD"
        },
        {
          "s": "FOREXCOM:DJI",
          "d": "Dow Jones Industrial Average Index"
        },
        {
          "s": "INDEX:NKY",
          "d": "Nikkei 225"
        },
        {
          "s": "INDEX:DEU40",
          "d": "DAX Index"
        },
        {
          "s": "FOREXCOM:UKXGBP",
          "d": "FTSE 100 Index"
        },
        {
          "s": "BSE:SENSEX",
          "d": "SENSEX INDIA"
        },
        {
          "s": "NASDAQ:NDX",
          "d": "NASDAQ 100"
        }
      ],
      "originalTitle": "Indices"
    },
    {
      "title": "Futures",
      "symbols": [
        {
          "s": "CME_MINI:ES1!",
          "d": "S&P 500"
        },
        {
          "s": "CME:6E1!",
          "d": "Euro"
        },
        {
          "s": "COMEX:GC1!",
          "d": "Gold"
        },
        {
          "s": "NYMEX:CL1!",
          "d": "WTI Crude Oil"
        },
        {
          "s": "NYMEX:NG1!",
          "d": "Gas"
        },
        {
          "s": "CBOT:ZC1!",
          "d": "Corn"
        }
      ],
      "originalTitle": "Futures"
    },
    {
      "title": "Bonds",
      "symbols": [
        {
          "s": "CBOT:ZB1!",
          "d": "T-Bond"
        },
        {
          "s": "CBOT:UB1!",
          "d": "Ultra T-Bond"
        },
        {
          "s": "EUREX:FGBL1!",
          "d": "Euro Bund"
        },
        {
          "s": "EUREX:FBTP1!",
          "d": "Euro BTP"
        },
        {
          "s": "EUREX:FGBM1!",
          "d": "Euro BOBL"
        }
      ],
      "originalTitle": "Bonds"
    },
    {
      "title": "Forex",
      "symbols": [
        {
          "s": "FX:EURUSD",
          "d": "EUR to USD"
        },
        {
          "s": "FX:GBPUSD",
          "d": "GBP to USD"
        },
        {
          "s": "FX:USDJPY",
          "d": "USD to JPY"
        },
        {
          "s": "FX:USDCHF",
          "d": "USD to CHF"
        },
        {
          "s": "FX:AUDUSD",
          "d": "AUD to USD"
        },
        {
          "s": "FX:USDCAD",
          "d": "USD to CAD"
        }
      ],
      "originalTitle": "Forex"
    },
    {
      "title": "Commodities",
      "symbols": [
        {
          "s": "CME_MINI:ES1!",
          "d": "S&P 500"
        },
        {
          "s": "CME:6E1!",
          "d": "Euro"
        },
        {
          "s": "COMEX:GC1!",
          "d": "Gold"
        },
        {
          "s": "NYMEX:CL1!",
          "d": "WTI Crude Oil"
        },
        {
          "s": "NYMEX:NG1!",
          "d": "Natural Gas"
        },
        {
          "s": "CBOT:ZC1!",
          "d": "Corn"
        }
      ],
      "originalTitle": "Commodities"
    }
  ]
}
  </script>
</div>
<!-- TradingView Widget END -->
      <!-- TradingView Widget END -->
    </body>
    </html>
    ''';

    _controller.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class GlobalTopNewsAllScreen extends StatefulWidget {
  @override
  _GlobalTopNewsAllScreenState createState() => _GlobalTopNewsAllScreenState();
}

class _GlobalTopNewsAllScreenState extends State<GlobalTopNewsAllScreen> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print("==========================${height}");
    return Scaffold(
        appBar: AppBar(
          title: Text("TOP Global News"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: WebView(
                onProgress: (int progress) {
                  setState(() {
                    _isLoading = progress < 100;
                  });
                },
                zoomEnabled: false,
                initialUrl: '',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  _loadHtmlFromAssets(width.toInt(), height.toInt());
                },
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }

  void _loadHtmlFromAssets(int width, int hight) async {
    String htmlContent = '''
 <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
    <!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-timeline.js" async>
  {
  "feedMode": "all_symbols",
  "isTransparent": true,
  "displayMode": "adaptive",
  "width": "100%",
  "height": "800",
  "colorTheme": "light",
  "locale": "en"
}
  </script>
</div>
<!-- TradingView Widget END -->
      <!-- TradingView Widget END -->
    </body>
    </html>
    ''';

    _controller.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class EconomicalCalandarScreen extends StatefulWidget {
  @override
  _EconomicalCalandarScreenState createState() =>
      _EconomicalCalandarScreenState();
}

class _EconomicalCalandarScreenState extends State<EconomicalCalandarScreen> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print("==========================${height}");
    return Scaffold(
        appBar: AppBar(
          title: Text("Economical Calandar"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: WebView(
                onProgress: (int progress) {
                  setState(() {
                    _isLoading = progress < 100;
                  });
                },
                zoomEnabled: false,
                initialUrl: '',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  _loadHtmlFromAssets(width.toInt(), height.toInt());
                },
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }

  void _loadHtmlFromAssets(int width, int hight) async {
    String htmlContent = '''
 <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
  <!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-events.js" async>
  {
  "colorTheme": "light",
  "isTransparent": false,
  "width": "100%",
  "height": "800",
  "locale": "en",
  "importanceFilter": "-1,0,1",
  "countryFilter": "in"
}
  </script>
</div>
<!-- TradingView Widget END -->
    </body>
    </html>
    ''';

    _controller.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
