import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/Charts/chart.dart';
import 'package:tradingapp/DashBoard/Screens/option_chain_screen/screen/option_chain_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/Technical_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/DashBoard/Screens/BuyOrSellScreen/buy_sell_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/instrument_details_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/model/instrumentbyid_model.dart';

class ViewMoreInstrumentDetailScreen extends StatefulWidget {
  final String exchangeInstrumentId;
  final String exchangeSegment;
  final String lastTradedPrice;
  final String close;
  final String displayName;

  const ViewMoreInstrumentDetailScreen({
    Key? key,
    required this.exchangeInstrumentId,
    required this.exchangeSegment,
    required this.lastTradedPrice,
    required this.close,
    required this.displayName,
  }) : super(key: key);

  @override
  State<ViewMoreInstrumentDetailScreen> createState() => _ViewMoreInstrumentDetailScreenState();
}

class _ViewMoreInstrumentDetailScreenState extends State<ViewMoreInstrumentDetailScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<MarketFeedSocket>(builder: (context, data, child) {
          if (data.getDataById(int.parse(widget.exchangeInstrumentId)) == null) {
            return Container();
          }
          final marketData = data.getDataById(int.parse(widget.exchangeInstrumentId));

          final priceChange = marketData != null ? double.parse(marketData.price) - double.parse(widget.close) : 0;
          final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;
          return Skeletonizer(
            enabled: data.getDataById(int.parse(widget.exchangeInstrumentId)) == null ? true : false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.exchangeSegment == '2'
                        ? Text(
                            widget.displayName,
                            style: TextStyle(fontSize: 11),
                          )
                        : Row(
                            children: [
                              Text(
                                widget.displayName,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryColorDark1),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                ExchangeConverter().getExchangeSegmentName(int.parse(widget.exchangeSegment)),
                                style: TextStyle(fontSize: 11, color: AppColors.primaryColorDark2),
                              ),
                            ],
                          ),
                    Row(
                      children: [
                        Text(
                          "₹" + marketData!.price.toString(),
                          style: TextStyle(color: AppColors.primaryColorDark, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)",
                          style: TextStyle(color: priceChangeColor, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        marketData.percentChange != null
                            ? (marketData.percentChange.toString().startsWith('-')
                                ? SvgPicture.asset("assets/AppIcon/triangleDown.svg")
                                : SvgPicture.asset("assets/AppIcon/triangleUp.svg"))
                            : SvgPicture.asset("assets/AppIcon/triangleDown.svg"),
                      ],
                    ),
                  ],
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Row(
                //       children: [
                //         Text(
                //           "₹" + marketData!.price.toString(),
                //           style: TextStyle(color: priceChangeColor, fontSize: 18),
                //         ),
                //         Icon(
                //           Icons.arrow_drop_up,
                //           color: priceChangeColor,
                //         ),
                //       ],
                //     ),
                //     Text(
                //       "${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)",
                //       style: TextStyle(color: priceChangeColor, fontSize: 1),
                //     )
                //   ],
                // ),
              ],
            ),
          );
        }),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                  ],
                  stops: [0.5, 1, 0.5],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(1)),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.primaryColor,
              controller: _tabController,
              isScrollable: true,
              splashFactory: InkRipple.splashFactory,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Technical'),
                Tab(text: 'Trendlyne'),
                Tab(text: 'Trading View'),
                Tab(text: 'Company Profile'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OverviewTab(
            exchangeInstrumentId: widget.exchangeInstrumentId,
            exchangeSegment: widget.exchangeSegment,
            lastTradedPrice: widget.lastTradedPrice,
            close: widget.close,
            displayName: widget.displayName,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 500, child: TechnicalAnalysisWidgetScreen(widget.displayName)),
                Container(height: 510, child: CheckBeforeBuyWidgetScreen(widget.displayName)),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Container(height: 500, child: TrendlyneWidgetScreen(widget.displayName)),
          Container(
            height: 810,
            child: TradingViewWidgetScreen(widget.displayName),
          ),
          Container(
            child: CompanyProfileWidgetScreen(widget.displayName),
          )
        ],
      ),
    );
  }
}

class OverviewTab extends StatefulWidget {
  final String exchangeInstrumentId;
  final String exchangeSegment;
  final String lastTradedPrice;
  final String close;
  final String displayName;

  const OverviewTab({
    Key? key,
    required this.exchangeInstrumentId,
    required this.exchangeSegment,
    required this.lastTradedPrice,
    required this.close,
    required this.displayName,
  }) : super(key: key);

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  List<String> PerformanceTitles = ["Today's High", "Today's Low", "52W High", "52W Low", "Opening Price", "Prev. Price", "Volume", "Lower circuit", "Upper circuit"];

  List<String> PerformanceSubTitles = [
    "Today's high represents the peak trading price of the stock for the day.",
    "Today's low represents the lowest trading price of the stock for the day.",
    "The 52-week high is the peak trading price of the stock over the past 52 weeks.",
    "The 52-week low is the minimum trading price of the stock over the past 52 weeks.",
    "The opening price is the initial trading price of the stock when the exchange begins.",
    "The prev. price is the closing price of the stock when the exchange concludes trading. It reflects the previous session's closing value.",
    "Volume, or trading volume, is the aggregate number of shares traded, encompassing both purchases and sales, on the exchange throughout the day.",
    "A lower circuit is the minimum price level that a stock can decline to on a specific trading day.",
    "The upper circuit represents the highest price limit to which a stock can ascend during a particular trading session."
  ];

  @override
  Widget build(BuildContext context) {
    final exchangeInstrumentId = widget.exchangeInstrumentId;
    final exchangeSegment = widget.exchangeSegment;
    final lastTradedPrice = widget.lastTradedPrice;
    final close = widget.close;
    final displayName = widget.displayName;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FutureBuilder<Result>(
              future: ApiService().GetInstrumentByID(exchangeInstrumentId, exchangeSegment),
              builder: (context, snapshot) {
                //  print("1111${snapshot.data?.bhavcopy?.close}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            'assets/error_illustrations/time_error.svg',
                            height: 200,
                            width: 200,
                            color: AppColors.RedColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Error: ${snapshot.error}",
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                  );
                }

                return Consumer<MarketFeedSocket>(
                  builder: (context, data, child) {
                    final marketData = data.getDataById(int.parse(exchangeInstrumentId));
                    final priceChange = marketData != null ? double.parse(marketData.price) - double.parse(close) : 0;
                    final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;

                    if (marketData != null) {
                      return Skeletonizer(
                        enabled: snapshot.connectionState == ConnectionState.waiting ? true : false,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 70,
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.57),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: Offset(0, 1), // changes position of shadow
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryBackgroundColor,
                                          AppColors.tertiaryGrediantColor3,
                                          AppColors.tertiaryGrediantColor1.withOpacity(1),
                                          AppColors.primaryBackgroundColor,
                                          AppColors.tertiaryGrediantColor3,
                                        ],
                                        stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "OPEN",
                                              style: TextStyle(color: AppColors.primaryColorDark2),
                                            ),
                                            Text(marketData.Open, style: TextStyle(color: AppColors.primaryColorDark)),
                                          ],
                                        ),
                                        Container(height: 30, child: VerticalDivider()),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "HIGH",
                                                style: TextStyle(color: AppColors.primaryColorDark2),
                                              ),
                                              Text(marketData.High, style: TextStyle(color: AppColors.primaryColorDark)),
                                            ],
                                          ),
                                        ),
                                        Container(height: 30, child: VerticalDivider()),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "LOW",
                                                style: TextStyle(color: AppColors.primaryColorDark2),
                                              ),
                                              Text(
                                                marketData.Low,
                                                style: TextStyle(color: AppColors.primaryColorDark),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(height: 30, child: VerticalDivider()),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "PREV. CLOSE",
                                                style: TextStyle(color: AppColors.primaryColorDark2),
                                              ),
                                              Text(marketData.close.toString(), style: TextStyle(color: AppColors.primaryColorDark)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primaryBackgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('Qty',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.primaryColorDark,
                                                              )),
                                                          Text('Buy Price', style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('Buy Price',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.primaryColorDark,
                                                              )),
                                                          Text('Qty',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.primaryColorDark,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 250,
                                                      child: ListView.separated(
                                                        separatorBuilder: (context, index) => SizedBox(
                                                          height: 10,
                                                        ),
                                                        shrinkWrap: false,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: marketData.bids.length,
                                                        itemBuilder: (context, index) {
                                                          var bid = marketData.bids[index];
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.37),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 1,
                                                                  offset: Offset(0, 1), // changes position of shadow
                                                                ),
                                                              ],
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  AppColors.GreenGredient1,
                                                                  AppColors.GreenGredient2,
                                                                ],
                                                                stops: [0.1, 0.9],
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                              ),
                                                            ),
                                                            padding: EdgeInsets.all(10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('${bid.size}'),
                                                                Text(
                                                                  '${bid.price}',
                                                                  style: TextStyle(color: AppColors.GreenColor),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 250,
                                                      // width: 180,
                                                      child: ListView.separated(
                                                        separatorBuilder: (context, index) => SizedBox(
                                                          height: 10,
                                                        ),
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: marketData.asks.length,
                                                        itemBuilder: (context, index) {
                                                          var asks = marketData.asks[index];
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.37),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 1,
                                                                  offset: Offset(0, 1), // changes position of shadow
                                                                ),
                                                              ],
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  AppColors.RedGredient1,
                                                                  AppColors.RedGredient2,
                                                                ],
                                                                stops: [0.1, 0.9],
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                              ),
                                                            ),
                                                            padding: EdgeInsets.all(10),
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                              Text('${asks.price}', style: TextStyle(color: AppColors.RedColor)),
                                                              Text('${asks.size}'),
                                                            ]),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      marketData.totalBuyQuantity,
                                                      style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text("Total Quantity", style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold)),
                                                    Text(marketData.totalSellQuantity, style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.57),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: Offset(0, 1), // changes position of shadow
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryBackgroundColor,
                                          AppColors.tertiaryGrediantColor3,
                                          AppColors.tertiaryGrediantColor1.withOpacity(1),
                                          AppColors.primaryBackgroundColor,
                                          AppColors.tertiaryGrediantColor3,
                                        ],
                                        stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Performance",
                                              style: GoogleFonts.inter(color: AppColors.primaryColorDark, fontSize: 15),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    backgroundColor: AppColors.primaryBackgroundColor,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 15.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor.withOpacity(1)),
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Icons.event_note_outlined,
                                                                        color: AppColors.primaryBackgroundColor,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "Performance",
                                                                  style: TextStyle(color: AppColors.primaryColorDark, fontSize: 14, fontWeight: FontWeight.w600),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    "Metrics provide data illustrating the company's stock performance, with these figures fluctuating daily.",
                                                                    style: GoogleFonts.inter(
                                                                      color: AppColors.primaryColorDark,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                              child: ListView.builder(
                                                                itemCount: PerformanceTitles.length,
                                                                itemBuilder: (context, index) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                    child: Container(
                                                                      child: ListTile(
                                                                        title: Text(
                                                                          PerformanceTitles[index],
                                                                          style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.w600),
                                                                        ),
                                                                        subtitle: Text(
                                                                          PerformanceSubTitles[index],
                                                                          style: TextStyle(
                                                                            color: AppColors.primaryColorDark,
                                                                          ),
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  HugeIcons.strokeRoundedAlertSquare,
                                                  color: AppColors.primaryColorDark2,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Today's Low",
                                                  style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 12),
                                                ),
                                                Text(marketData.Low)
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Today's High",
                                                  style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 12),
                                                ),
                                                Text(marketData.High)
                                              ],
                                            ),
                                          ],
                                        ),
                                        //       SizedBox(
                                        //   height: 10,
                                        // ),

                                        Container(
                                          height: 30,
                                          child: RangeChart(
                                            low: double.parse(marketData.Low),
                                            high: double.parse(marketData.High),
                                            current: double.parse(marketData.price),
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "52 Week's Low",
                                                      style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 12),
                                                    ),
                                                    Text(snapshot.data!.fiftyTwoWeekLow.toString())
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "52 week's High",
                                                  style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 12),
                                                ),
                                                Text(snapshot.data!.fiftyTwoWeekHigh.toString())
                                              ],
                                            ),
                                          ],
                                        ),

                                        Container(
                                          height: 20,
                                          child: RangeChart(
                                            low: double.parse(snapshot.data!.fiftyTwoWeekLow.toString()),
                                            high: double.parse(snapshot.data!.fiftyTwoWeekHigh.toString()),
                                            current: double.parse(marketData.price),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[200]!),
                                      borderRadius: BorderRadius.circular(7),
                                      gradient: LinearGradient(
                                        stops: [0.002, 0.7, 0.9],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.primaryBackgroundColor,
                                          AppColors.primaryColorUnselected,
                                          AppColors.primaryColorUnselected,
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => OptionChainScreen(
                                                            exchangeInstrumentID: exchangeInstrumentId,
                                                            exchangeSegment: exchangeSegment,
                                                            displayName: displayName,
                                                            lastTradedPrice: lastTradedPrice,
                                                          )));
                                            },
                                            child: Text(
                                              "Option Chain",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                            )),
                                        VerticalDivider(),
                                        TextButton(
                                            onPressed: () {
                                              Get.to(() => ChartingFromTV(displayName));
                                            },
                                            child: Text(
                                              "Charts",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                            )),
                                        VerticalDivider(),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => InstrumentDetailsScreen(
                                                          ExchangeInstrumentID: exchangeInstrumentId,
                                                          ExchangeInstrumentName: displayName,
                                                          displayname: displayName,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              "Stock Details",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  // Container(
                                  //   height: 300,

                                  //   child: MyChart(),),
                                  Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BuySellScreen(
                                                    exchangeInstrumentId: exchangeInstrumentId,
                                                    exchangeSegment: exchangeSegment,
                                                    lastTradedPrice: marketData.price,
                                                    close: close,
                                                    displayName: displayName,
                                                    isBuy: true,
                                                    lotSize: snapshot.data!.lotSize,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CustomBuySellnButton(
                                              isBuy: true,
                                              text: "BUY",
                                              onPressed: () {Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BuySellScreen(
                                                    exchangeInstrumentId: exchangeInstrumentId,
                                                    exchangeSegment: exchangeSegment,
                                                    lastTradedPrice: marketData.price,
                                                    close: close,
                                                    displayName: displayName,
                                                    isBuy: true,
                                                    lotSize: snapshot.data!.lotSize,
                                                  ),
                                                ),
                                              );},
                                            ),
                                            // child: Container(
                                            //   height: 50,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(10),
                                            //     color: AppColors.GreenColor,
                                            //   ),
                                            //   child: Center(child: Text("BUY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                                            // ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BuySellScreen(
                                                    exchangeInstrumentId: exchangeInstrumentId,
                                                    exchangeSegment: exchangeSegment,
                                                    lastTradedPrice: marketData.price,
                                                    close: close,
                                                    displayName: displayName,
                                                    isBuy: false,
                                                    lotSize: snapshot.data!.lotSize,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CustomBuySellnButton(
                                              isBuy: false,
                                              text: "SELL",
                                              onPressed: () {
                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BuySellScreen(
                                                    exchangeInstrumentId: exchangeInstrumentId,
                                                    exchangeSegment: exchangeSegment,
                                                    lastTradedPrice: marketData.price,
                                                    close: close,
                                                    displayName: displayName,
                                                    isBuy: false,
                                                    lotSize: snapshot.data!.lotSize,
                                                  ),
                                                ),
                                              );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "OPEN",
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                            Text("MarketData.Open"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "HIGH",
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                            Text("marketData.High"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "LOW",
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                            Text("marketData.Low"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "PREV. CLOSE",
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                            Text("marketData.close.toString("),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('QTY',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black87,
                                                        )),
                                                    Text('BUY PRICE', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('BUY PRICE',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black87,
                                                        )),
                                                    Text('QTY',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black87,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 200,
                                              width: 180,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: 5,
                                                itemBuilder: (context, index) {
                                                  var bid = "marketData.bids[index]";
                                                  return Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('${"bid.size"}'),
                                                        Text(
                                                          '${"bid.price"}',
                                                          style: TextStyle(color: Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 200,
                                                // width: 180,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: 5,
                                                  itemBuilder: (context, index) {
                                                    var asks = " marketData.asks[index]";
                                                    return Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Text('${"asks.price"}', style: TextStyle(color: Colors.red)),
                                                        Text('${"asks.size"}'),
                                                      ]),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text("marketData.totalBuyQuantity"), Text("TOTAL QUANTITY"), Text("marketData.totalSellQuantity")],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              });
        },
      ),
    );
  }
}

class RangeChart extends StatelessWidget {
  final double low;
  final double high;
  final double current;

  const RangeChart({
    Key? key,
    required this.low,
    required this.high,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 60),
      painter: RangeChartPainter(
        low: low,
        high: high,
        current: current,
      ),
    );
  }
}

class RangeChartPainter extends CustomPainter {
  final double low;
  final double high;
  final double current;

  RangeChartPainter({
    required this.low,
    required this.high,
    required this.current,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = AppColors.PaintBackgroundColor!
      ..style = PaintingStyle.fill;

    // Gradient for the range fill
    final Paint rangePaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.PaintBackgroundColor!, Colors.green],
        stops: [0.01, .3],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final Paint markerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double rangeWidth = size.width;
    final double rangeHeight = 5.0;
    final double rangeTop = size.height / 5 - rangeHeight / 5;

    // Draw the full range background
    canvas.drawRect(
      Rect.fromLTWH(0, rangeTop, rangeWidth, rangeHeight),
      backgroundPaint,
    );

    // Calculate current position as a percentage
    final double markerPosition = ((current - low) / (high - low)) * rangeWidth;

    // Draw the gradient-filled range up to the current position
    canvas.drawRect(
      Rect.fromLTWH(0, rangeTop, markerPosition, rangeHeight),
      rangePaint,
    );

    // Draw the marker
    const double markerWidth = 2.0;
    const double markerHeight = 13.0;
    canvas.drawRect(
      Rect.fromLTWH(
        markerPosition - markerWidth / 2,
        rangeTop - markerHeight / 2 + rangeHeight / 2,
        markerWidth,
        markerHeight,
      ),
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyChart extends StatelessWidget {
  //final Map<String, dynamic> instrumentData;

  const MyChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double openPrice = 50;

    double highPrice = 60;
    double lowPrice = 40;
    double closePrice = 55;

    // double openPrice = instrumentData['Bhavcopy']['Open'];
    // double highPrice = instrumentData['Bhavcopy']['High'];
    // double lowPrice = instrumentData['Bhavcopy']['Low'];
    // double closePrice = instrumentData['Bhavcopy']['Close'];

    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, titleMeta) {
                return const Text('Day');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, titleMeta) {
                return Text('${value.toInt()}');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xff727070)),
            left: BorderSide(color: Color(0xff727070)),
            right: BorderSide(color: Color(0xff727070)),
            top: BorderSide(color: Color(0xff727070)),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: openPrice,
                color: AppColors.GreenColor,
                width: 16,
              ),
              BarChartRodData(
                toY: highPrice,
                color: Colors.blue,
                width: 16,
              ),
              BarChartRodData(
                toY: lowPrice,
                color: Colors.red,
                width: 16,
              ),
              BarChartRodData(
                toY: closePrice,
                color: Colors.purple,
                width: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
