import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingapp/Authentication/Screens/login_screen.dart';
import 'package:tradingapp/DashBoard/Screens/Screeners/topgainers_screen.dart';
import 'package:tradingapp/DrawerScreens/stock_avg_calculator.dart';
import 'package:tradingapp/DashBoard/Screens/FII/DII/fii_dii_screen.dart';
import 'package:tradingapp/DashBoard/Screens/GlobalScreen/GlobalScreen.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/IPOsScreen.dart';
import 'package:tradingapp/DashBoard/Screens/HighestReturnScreens/Sectoral_themes_screen.dart';
import 'package:tradingapp/DashBoard/Screens/HighestReturnScreens/highest_return_screen.dart';
import 'package:tradingapp/DashBoard/Screens/NotificationScreen/NotificationScreen.dart';
import 'package:tradingapp/DashBoard/Screens/SectorScreen/SectorScreen.dart';
import 'package:tradingapp/DrawerScreens/equity_market_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/Technical_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/market_watch_screen.dart';
import 'package:tradingapp/MarketWatch/SearchOperations/screen/search_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/holding_screen.dart';
import 'package:tradingapp/Profile/UserProfile/screen/profilepage_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

late TabController _tabController;
final marketFeedSocket = MarketFeedSocket();

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late Stream<String> stream;
  @override
  void initState() {
    super.initState();
    // TopGainersScreen();
  }

  final marketFeedSocket = MarketFeedSocket();

  late final TabController _tabController = TabController(length: 3, vsync: this);
  final List<Map<String, dynamic>> mostBought = [
    {
      'name': 'YESBANK',
      'price': 26.13,
      'percentage': '(0.5%)',
      'change': '+90.42',
      'image': 'https://ekyc.arhamshare.com/img//trading_app_logos//YESBANK.svg',
    },
    {
      'name': 'IRFC',
      'price': 158,
      'percentage': '(7.5%)',
      'change': '+7.80',
      'image': 'https://ekyc.arhamshare.com/img//trading_app_logos//IRFC.svg',
    },
    {
      'name': 'TATASTEEL',
      'price': 165.80,
      'percentage': '(-1.5%)',
      'change': '-1.90',
      'image': 'https://ekyc.arhamshare.com/img//trading_app_logos//TATASTEEL.svg',
    },
    {
      'name': 'IDEA',
      'price': 14.00,
      'percentage': '(0.75%)',
      'change': '+14.42',
      'image': 'https://ekyc.arhamshare.com/img//trading_app_logos//IDEA.svg',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDashboard1(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        foregroundColor: Colors.black,
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Get.to(() => NotificationScreen());
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Center(
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.read_more),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
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
                Tab(text: 'Stocks'),
                Tab(text: 'F&O'),
                Tab(text: 'Mutual Funds'),
              ],
            ),
          ),
        ),
      ),
      endDrawer: DrawerDashboard2(), // Right drawer
      body: Container(
        // height: MediaQuery.of(context).size.height * 1.6,
        color: Colors.grey[200]!,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Consumer<MarketFeedSocket>(builder: (context, feed, child) {
                          return MarketDataWidget(feed.bankmarketData);
                        }),
                        // Container(
                        //   padding:
                        //       EdgeInsets.fromLTRB(5   , 5, 5, 5),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius:
                        //         BorderRadius.circular(5),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment:
                        //         CrossAxisAlignment.start,
                        //     children: [

                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(HugeIcons.strokeRoundedLockSync02, color: AppColors.primaryColor),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => FiiDiiScreen());
                                      },
                                      child: Text(
                                        "Fll/Dll",
                                        style: TextStyle(fontFamily: GoogleFonts.poppins().toString(), color: AppColors.primaryColor),
                                      ))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                indent: 10,
                                endIndent: 10,
                              ), // Add a vertical divider
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    HugeIcons.strokeRoundedGlobalEditing,
                                    color: AppColors.primaryColor,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(() => Globalscreen());
                                      },
                                      child: Text("Global", style: TextStyle(color: AppColors.primaryColor)))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                indent: 10,
                                endIndent: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    HugeIcons.strokeRoundedProjector,
                                    color: AppColors.primaryColor,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Get.to(Sectorscreen());
                                      },
                                      child: Text("Sectors", style: TextStyle(color: AppColors.primaryColor)))
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // Container(
                        //   height: 360,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment:
                        //         CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                        //         child: Text("Most Bought Stocks"),
                        //       ),
                        //       Expanded(child: MostBoughtTop4Screen()),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          height: 380,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTabController(
                            length: 2, // Number of tabs
                            child: Column(
                              children: [
                                TabBar(
                                  // isScrollable: true,
                                  dividerColor: Colors.grey[200],
                                  tabs: [
                                    Tab(text: 'Most Bought'),
                                    Tab(text: '52 Week High & Low'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      MostBoughtTop4Screen(),
                                      Week52HighNLowTop4Screen(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          height: 380,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTabController(
                            length: 2, // Number of tabs
                            child: Column(
                              children: [
                                TabBar(
                                  dividerColor: Colors.grey[200],
                                  // isScrollable: true,

                                  tabs: [
                                    Tab(text: 'Top Gainers'),
                                    Tab(text: 'Top Losers'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      TopGainersTop4Screen(),
                                      TopLoosersTop4Screen(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius:
                        //           BorderRadius.circular(10),
                        //     ),
                        //     height: 300,
                        //     child: TopGainersScreen()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => IpoDashboardScreen());
                                  },
                                  child: Card(
                                      color: AppColors.primaryBackgroundColor,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColors.primaryColor.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      Icon(
                                                        HugeIcons.strokeRoundedThreadsRectangle,
                                                        semanticLabel: 'Trxt',
                                                        color: AppColors.primaryColor,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Text("IPO"),
                                            ]),
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.primaryColor.withOpacity(0.1),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          HugeIcons.strokeRoundedLaurelWreathFirst02,
                                                          semanticLabel: 'Trxt',
                                                          color: AppColors.primaryColor,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text("Stock SIP"),
                                          ]),
                                    )),
                              ),
                              Expanded(
                                child: Card(
                                    color: Colors.white,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.primaryColor.withOpacity(0.1),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          HugeIcons.strokeRoundedTradeUp,
                                                          semanticLabel: 'Trxt',
                                                          color: AppColors.primaryColor,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text("MTF"),
                                          ]),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        // TopGainersLoosers(),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => HighestReturnScreen());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryColor.withOpacity(0.1),
                                              ),
                                            ),
                                            Icon(
                                              Icons.wallet_giftcard,
                                              color: AppColors.primaryColor,
                                            ),
                                          ],
                                        ),
                                        Text("Highest Return")
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => SectoralThemesScreen());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryColor.withOpacity(0.1),
                                              ),
                                            ),
                                            Icon(
                                              Icons.health_and_safety_rounded,
                                              color: AppColors.primaryColor,
                                            ),
                                          ],
                                        ),
                                        Text("Sectoral Themes")
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryColor.withOpacity(0.1),
                                            ),
                                          ),
                                          Icon(
                                            Icons.wallet_giftcard,
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                      Text("Offers & Rewards")
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryColor.withOpacity(0.1),
                                            ),
                                          ),
                                          Icon(
                                            Icons.health_and_safety_rounded,
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                      Text("Refer & Earn")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Text("data"),
                      ],
                    ),
                  ),

                  // TAB 2 .........................................................  ....  ... ... ... ... ... ....  ..  ...q..  . ..  ... ... ... ... ... ..  . ..  . . . .

                  Container(
                      child: Container(
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Consumer<MarketFeedSocket>(builder: (context, feed, child) {
                                return MarketDataWidget(feed.bankmarketData);
                              }))
                        ],
                      ),
                    ),
                  )),
                  Container(
                    height: 600,
                    child: Column(
                      children: [
                        Center(
                          child: Text('Tab 3'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Text('Welcome to Dashboard Screen'),
          ],
        ).paddingOnly(left: 10.w, right: 10.w, top: 10.h),
      ),
    ).paddingOnly(bottom: MediaQuery.of(context).padding.bottom);
  }
}

class MarketDataWidget extends StatefulWidget {
  final Map<int, MarketData> marketData;

  MarketDataWidget(this.marketData);

  @override
  _MarketDataWidgetState createState() => _MarketDataWidgetState();
}

class _MarketDataWidgetState extends State<MarketDataWidget> {
  List<Map<String, dynamic>> getFormattedMarketData() {
    return widget.marketData.entries.where((entry) {
      var name = IndexData.getIndexName(entry.key);

      return name != null && name != "Unknown Index";
    }).map((entry) {
      var name = IndexData.getIndexName(entry.key);
      var data = entry.value;
      return {
        'name': name,
        'price': data.price,
        'percentage': '(${data.percentChange}%)',
        'change': data.percentChange,
        'close': data.close,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stocks = getFormattedMarketData();
    final filteredStocks = stocks.where((stock) => stock != "Unknown Index").toList();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Market Data",
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredStocks.length,
                  itemBuilder: (context, index) {
                    if (stocks[index] != "Unknown Index") {
                      final priceChange =
                          stocks[index]['price'] != null ? double.parse(stocks[index]['price']) - double.parse(stocks[index]['close']) : 0;
                      final priceChangeColor = priceChange > 0 ? Colors.green : Colors.red;
                      return InkWell(
                        onTap: () {
                          Get.to(() => ProfileScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black12),
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white,
                            ),
                            // semanticContainer: true,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            // borderOnForeground: true,
                            // shadowColor: Colors.white,

                            child: Stack(alignment: Alignment.center, children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stocks[index]['name'],
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(stocks[index]['price'].toString(), style: TextStyle(color: priceChangeColor)),
                                    Row(
                                      children: [
                                        Text(priceChange.toStringAsFixed(2), style: TextStyle(color: priceChangeColor)),
                                        Text(
                                          stocks[index]['percentage'].toString(),
                                          style: TextStyle(color: priceChangeColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IndexData {
  static final Map<String, int> indexMap = {
    // Your mappings here
    "NIFTY MIDCAP 50": 26005,
    "NIFTY GS 11 15YR": 26006,
    "NIFTY 100": 26004,
    "NIFTY 50": 26000,
    "SENSEX": 26065, // ExchangeSegment - 2
    "BANKNIFTY": 26001,

    "NIFTY IT": 26003,
    // "INDIA VIX": 26002,

    // "NIFTY INFRA": 26007,
    // "NIFTY100 LIQ 15": 26008,
    // "NIFTY REALTY": 26009,
    // "NIFTY CPSE": 26010,
    // "NIFTY GS COMPSITE": 26011,
    // "NIFTY OIL AND GAS": 26012,
    // "NIFTY50 TR 1X INV": 26013,
    // "NIFTY PHARMA": 26014,
    // "NIFTY PSE": 26015,
    // "NIFTY MIDCAP 150": 26016,
    // "NIFTY MIDCAP 100": 26017,
    // "NIFTY SERV SECTOR": 26018,
    // "NIFTY 500": 26019,
    // "NIFTY ALPHA 50": 26020,
    // "NIFTY50 VALUE 20": 26021,
    // "NIFTY200 QUALTY30": 26022,
    // "NIFTY SMLCAP 250": 26023,
    // "NIFTY GROWSECT 15": 26024,
    // "NIFTY50 PR 1X INV": 26025,
    // "NIFTY50 EQL WGT": 26026,
    // "NIFTY PSU BANK": 26027,
    // "NIFTY SMLCAP 100": 26028,
    // "NIFTY LARGEMID250": 26029,
    // "NIFTY100 EQL WGT": 26030,
    // "NIFTY SMLCAP 50": 26031,
    // "NIFTY ENERGY": 26032,
    // "NIFTY GS 10YR": 26033,
    // "NIFTY FIN SERVICE": 26034,
    // "NIFTY MIDSML 400": 26035,
    // "NIFTY METAL": 26036,
    // "NIFTY CONSR DURBL": 26037,
    // "NIFTY DIV OPPS 50": 26038,
    // "NIFTY GS 15YRPLUS": 26039,
    // "NIFTY MEDIA": 26040,
    // "NIFTY FMCG": 26041,
    // "NIFTY PVT BANK": 26042,
    // "NIFTY200MOMENTM30": 26043,
    // "HANGSENG BEES-NAV": 26044,
    // "NIFTY100 LOWVOL30": 26045,
    // "NIFTY50 TR 2X LEV": 26046,
    // "NIFTY CONSUMPTION": 26047,
    // "NIFTY GS 8 13YR": 26048,
    // "NIFTY100ESGSECLDR": 26049,
    // "NIFTY GS 10YR CLN": 26050,
    // "NIFTY GS 4 8YR": 26051,
    // "NIFTY AUTO": 26052,
    // "NIFTY COMMODITIES": 26053,
    // "NIFTY NEXT 50": 26054,
    // "NIFTY MNC": 26055,
    // "NIFTY MID LIQ 15": 26056,
    // "NIFTY HEALTHCARE": 26057,
    // "NIFTY500 MULTICAP": 26058,
    // "NIFTY ALPHALOWVOL": 26059,
    // "NIFTY FINSRV25 50": 26060,
    // "NIFTY50 PR 2X LEV": 26061,
    // "NIFTY100 QUALTY30": 26062,
    // "NIFTY50 DIV POINT": 26063,
    // "NIFTY 200": 26064,
    // "NIFTY MID SELECT": 26121,

    // Add other indices as needed
  };

  // A static method to get index name by ID
  static String getIndexName(int id) {
    var entry = indexMap.entries.firstWhere((entry) => entry.value == id, orElse: () => MapEntry("Unknown Index", -1) // Provide a default MapEntry
        );

    return entry.key; // Return the name or "Unknown Index"
  }

  // Optionally, another static method if you need to find index by name
  static int getIndexValue(String indexName) {
    return indexMap[indexName]!; // Return -1 if index not found
  }
  // Existing code...
}

// class TopGainersScreen extends StatefulWidget {
//   @override
//   _TopGainersScreenState createState() => _TopGainersScreenState();
// }

// class _TopGainersScreenState extends State<TopGainersScreen> {
//   late TopGainersNLosers topGainers;
//   String selectedLegend = 'NIFTY'; // Default

//   @override
//   void initState() {
//     super.initState();
//     fetchTopGainers();
//   }

//   void fetchTopGainers() async {
//     final response = await http.get(Uri.parse(
//         'http://180.211.116.158:8080/mobile/api/v1/all-stocks-performance/top-gainers-loosers?index=loosers'));
//     if (response.statusCode == 200) {
//       setState(() {
//         topGainers = TopGainersNLosers.fromJson(jsonDecode(response.body)['data']);
//       });
//     } else {
//       throw Exception('Failed to load top gainers');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: topGainers == null
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: topGainers.gainersData.keys.length,
//                       itemBuilder: (context, index) {
//                         final legend =
//                             topGainers.gainersData.keys.elementAt(index);
//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               selectedLegend = legend;
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: selectedLegend == legend
//                                   ? Colors.blue
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               legend,
//                               style: TextStyle(
//                                 color: selectedLegend == legend
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (context, index) {
//                       return Divider();
//                     },
//                     itemCount:
//                         topGainers.gainersData[selectedLegend]!.length > 4
//                             ? 4
//                             : topGainers.gainersData[selectedLegend]!.length,
//                     itemBuilder: (context, index) {
//                       final stock =
//                           topGainers.gainersData[selectedLegend]![index];
//                       return Container(
//                         decoration: BoxDecoration(color: Colors.white),
//                         padding: EdgeInsets.all(10),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(stock.symbol),
//                               Row(
//                                 children: [
//                                   Text(stock.ltp.toString()),
//                                   Text(" (%${stock.perChange.toString()})"),
//                                 ],
//                               ),
//                             ]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

class DrawerDashboard1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.notification_important_outlined),
                    title: Text('Notification'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.grey[300],
                    childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                    leading: Icon(Icons.watch),
                    title: Text('Watch Market'),
                    // subtitle: Text(
                    //   'Equity, Derivatives, Commodity, Mutual Funds',
                    //   style: TextStyle(fontSize: 11),
                    // ),
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('Equity'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EquityMarketScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Derivatives'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Commodity'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('Mutual Funds'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.search_off_sharp),
                    title: Text('Screeners'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                    leading: Icon(Icons.bar_chart_outlined),
                    title: Text('Primary Market'),
                    subtitle: Text(
                      'IPO, NCD',
                      style: TextStyle(fontSize: 11),
                    ),
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('IPO'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IpoDashboardScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('NCD'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.search_sharp),
                    title: Text('Search Instruments'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.newspaper),
                    title: Text('News'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.newspaper),
                    title: Text('Economical Calandar'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EconomicalCalandarScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Watchlist'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarketWatchScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                    leading: Icon(Icons.screen_lock_rotation_outlined),
                    title: Text('Tools'),
                    subtitle: Text(
                      'Calculator, Finder, Margin Calculator',
                      style: TextStyle(fontSize: 11),
                    ),
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('Stock Average Calculator'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockAverageCalculator(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Margin Finder'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Margin Calculator'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('Mutual Funds'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.wallet_giftcard),
                    title: Text('Refer & Earn'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Implement logout logic here
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerDashboard2 extends StatelessWidget {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.notification_important_outlined),
                    title: Text('Trade IN'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.grey[300],
                    childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                    leading: Icon(Icons.watch),
                    title: Text('Order & Position'),
                    // subtitle: Text(
                    //   'Equity, Derivatives, Commodity, Mutual Funds',
                    //   style: TextStyle(fontSize: 11),
                    // ),
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('Order'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Position'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Tradebook'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.search_off_sharp),
                    title: Text('Holdings'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HoldingScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 0,
                  ),
                  ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                    leading: Icon(Icons.bar_chart_outlined),
                    title: Text('PNL & Reports'),
                    // subtitle: Text(
                    //   'IPO, NCD',
                    //   style: TextStyle(fontSize: 11),
                    // ),
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[200],
                        height: 0,
                      ),
                      ListTile(
                        title: Text('PNL'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IpoDashboardScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Ledger Balance'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Holding Statement'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 0.1,
                      ),
                      ListTile(
                        title: Text('Globle Summery'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketWatchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[00],
                    height: 0,
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.document_scanner),
                  //   title: Text('PNL & Reports'),
                  //   onTap: () {
                  //     Navigator.of(context).pop(); // Close the drawer
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => DashboardScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.layers_outlined),
                    title: Text('Offerings'),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.deblur_outlined),
                    title: Text('Debt'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarketWatchScreen(),
                        ),
                      );
                    },
                  ),
                  // Divider(
                  //   color: Colors.grey[200],
                  //   height: 1,
                  // ),

                  Divider(
                    color: Colors.grey[200],
                    height: 0.1,
                  ),
                  ListTile(
                    leading: Icon(Icons.sip),
                    title: Text('eSIP'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Implement logout logic here
                    },
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await logout();
                      Get.offAll(() => LoginScreen());
                      Navigator.of(context).pop();
                      // Implement logout logic here
                    },
                  ),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
