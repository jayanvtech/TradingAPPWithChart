import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/InstrumentDetailScreen/instrument_details_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/SearchScreen/search_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/WishListInstrumentDetailScreen/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Portfolio/Model/holding_model.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';

class HoldingScreen extends StatefulWidget {
  const HoldingScreen({super.key});

  @override
  State<HoldingScreen> createState() => _HoldingScreenState();
}

class _HoldingScreenState extends State<HoldingScreen> {
  double totalInvestedValue = 0.0;
  double overallGain = 0.0;
  double mainBalance = 0.0;
  double todaysGain = 0.0;
  bool isSorted = false;
  dynamic marketData;
  double? totalBenefits;
  List<Holding>? _holdings;
  List<String> isAToZorZToA = [];
  List<String> isLowToHighOrHighToLow = [];
  List<String> daysPLIsLowToHighOrHighToLow = [];
  List<String> overAllPLIsLowToHighOrHighToLow = [];
  static String? displayName;
  @override
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDashboard1(),
      endDrawer: DrawerDashboard2(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Holdings'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.search_rounded,
                color: Colors.black,
              )),
          IconButton(
            onPressed: () {
              _showFilterBottomSheet(context);
            },
            icon: Icon(
              Icons.filter_list_alt,
              color: Colors.black,
            ),
          ),
          // IconButton(
          //     onPressed: () async {
          //       var token = await getToken();
          //       print(token);
          //     },
          //     icon: Icon(Icons.abc_rounded))
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.172,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Frame 6.png'), // Replace with your image
                  fit: BoxFit.fill,
                ),
                borderRadius:
                    BorderRadius.circular(5), // Rounded corners 51CE8F 239E70
              ),
              child: Stack(
                children: [
                  // Image.asset(
                  //   fit: BoxFit.fill,
                  //   'assets/1 (1).png',
                  //   opacity: AlwaysStoppedAnimation(.5),
                  //   height: 400,
                  //   width: 400,
                  // ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${mainBalance.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                            size: 15,
                          ),
                        ],
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                              overallGain.toString().startsWith('-')
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: overallGain.toString().startsWith('-')
                                  ? Colors.red
                                  : Colors.green,
                              size: 15,
                              weight: 600,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                )
                              ]),
                          Text(
                            "Overall Gain:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("₹${overallGain.toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white
                                  // color: overallGain.toString().startsWith('-')
                                  //     ? Colors.red
                                  //     : Colors.green),
                                  )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(${(totalInvestedValue != 0 ? (overallGain / totalInvestedValue) * 100 : 0).toStringAsFixed(2)}%)",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Invested Value",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹${totalInvestedValue.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    todaysGain.toString().startsWith('-')
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: todaysGain.toString().startsWith('-')
                                        ? Colors.red
                                        : Colors.green,
                                    size: 16,
                                  ),
                                  Text(
                                    "Today's Gain",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₹${todaysGain.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: todaysGain
                                                .toString()
                                                .startsWith('-')
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                  Text(
                                      "(${(totalInvestedValue != 0 ? (todaysGain / totalInvestedValue) * 100 : 0).toStringAsFixed(2)}%)",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  Provider.of<HoldingProvider>(context, listen: false)
                      .GetHoldings();
                },
                child: SingleChildScrollView(
                  child: ChangeNotifierProvider(
                    create: (context) => HoldingProvider()..GetHoldings(),
                    child: Consumer<HoldingProvider>(
                      builder: (context, HoldingProvider, child) {
                        if (HoldingProvider.holdings == null) {
                          return Center(child: CircularProgressIndicator());
                        } else if (HoldingProvider.holdings!.isEmpty) {
                          return Center(
                            child: Text(
                              "You have no positions. Place an order to open a new position",
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          if (HoldingProvider.holdings != null &&
                              HoldingProvider.holdings!.isNotEmpty) {
                            totalInvestedValue = 0.0;
                            overallGain = 0.0;
                            todaysGain = 0.0;

                            for (var holding in HoldingProvider.holdings!) {
                              var exchangeInstrumentID =
                                  holding.exchangeNSEInstrumentId;

                              if (AppVariables.isFirstTimeApiCalling <
                                  HoldingProvider.holdings!.length) {
                                AppVariables.isFirstTimeApiCalling++;

                                print(AppVariables.isFirstTimeApiCalling);

                                ApiService().MarketInstrumentSubscribe(
                                  1.toString(),
                                  exchangeInstrumentID.toString(),
                                );

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {});
                                });
                              }
                              double investedValue = double.parse(
                                      holding.holdingQuantity) *
                                  double.parse(holding.buyAvgPrice.toString());

                              marketData = context
                                  .read<MarketFeedSocket>()
                                  .getDataById(int.parse(
                                      exchangeInstrumentID.toString()));
                              var lastTradedPrice = marketData?.price ?? 0.0;

                              double previousClosePrice = double.tryParse(
                                      marketData?.close.toString() ??
                                          lastTradedPrice.toString()) ??
                                  0.0;

                              double lastTradedPriceDouble =
                                  lastTradedPrice is double
                                      ? lastTradedPrice
                                      : double.tryParse(
                                              lastTradedPrice.toString()) ??
                                          0.0;

                              double lastTradedPrice1 = double.tryParse(
                                      marketData?.price.toString() ?? '0') ??
                                  0.0;

                              double totalBenefits = (lastTradedPriceDouble -
                                      double.parse(
                                          holding.buyAvgPrice.toString())) *
                                  double.parse(holding.holdingQuantity);

                              double todaysPositionGain =
                                  (lastTradedPrice1 - previousClosePrice) *
                                      double.parse(holding.holdingQuantity);
                              todaysGain += todaysPositionGain;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  overallGain += totalBenefits;
                                  totalInvestedValue += investedValue;
                                  mainBalance =
                                      overallGain + totalInvestedValue;
                                });
                              });
                            }
                          }
                          return Consumer<MarketFeedSocket>(
                            builder: (context, marketFeedSocket, child) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // physics: BouncingScrollPhysics(),
                                itemCount: isSorted == true
                                    ? _holdings?.length
                                    : HoldingProvider.holdings!.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                itemBuilder: (context, index) {
                                  var holdings = isSorted == true
                                      ? _holdings![index]
                                      : HoldingProvider.holdings![index];
                                  // void fetchDisplayName() async {
                                  //   displayName = await ApiService()
                                  //       .GetDisplayName(
                                  //           holdings.exchangeNSEInstrumentId,
                                  //           "1");
                                  // }

// var displayname = await ApiService().GetDisplayName(holdings.exchangeNSEInstrumentId, "1");
                                  var quantity = holdings.holdingQuantity;
                                  var orderAvgLastTradedPrice =
                                      holdings.buyAvgPrice;

                                  var display = holdings.DisplayName;
                                  var exchangeSegment = 1;
                                  var exchangeInstrumentID =
                                      holdings.exchangeNSEInstrumentId;
                                  final marketData =
                                      marketFeedSocket.getDataById(int.parse(
                                          exchangeInstrumentID.toString()));
                                  var lastTradedPrice =
                                      marketData?.price.toString() ?? '0.0';
                                  if (lastTradedPrice != '0.0') {
                                    totalBenefits = (double.parse(
                                                lastTradedPrice) -
                                            double.parse(holdings.buyAvgPrice
                                                .toString())) *
                                        double.parse(holdings.holdingQuantity);
                                  }

                                  // double todaysPositionGain = (lastTradedPrice - previousClosePrice) *
                                  //     quantity;

                                  // double investedValue = quantity *
                                  //     (position.buyAveragePrice ?? 0.0);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewMoreInstrumentDetailScreen(
                                              exchangeInstrumentId:
                                                  exchangeInstrumentID,
                                              exchangeSegment: 1.toString(),
                                              lastTradedPrice:
                                                  marketData?.price ?? "0.0",
                                              close: marketData?.close ?? "0.0",
                                              displayName: holdings.DisplayName
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            // BoxShadow(
                                            //     color: Colors.grey,
                                            //     blurRadius: 0.5,
                                            //     spreadRadius: 0.005,
                                            //     offset: Offset(0, 1))
                                          ],
                                          // border: Border.all(
                                          //     color: Colors.grey[300]!,
                                          //     width: 0.5),
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    child: ClipOval(
                                                      child: SvgPicture.network(
                                                        "https://ekyc.arhamshare.com/img//trading_app_logos//${holdings.DisplayName}.svg",
                                                        fit: BoxFit.cover,
                                                        height: 100,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey[400],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              holdings
                                                                  .DisplayName,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  // fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            // DisplayNameValue(
                                                            //   exchangeInstrumentID:
                                                            //       holdings
                                                            //           .exchangeNSEInstrumentId
                                                            //           .toString(),
                                                            // ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              totalBenefits !=
                                                                      null
                                                                  ? totalBenefits!
                                                                      .toStringAsFixed(
                                                                          2)
                                                                  : '0.0',
                                                              style: TextStyle(
                                                                  color: totalBenefits
                                                                          .toString()
                                                                          .startsWith(
                                                                              '-')
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: []),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Avg: ${holdings.buyAvgPrice}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            Text(
                                                              " X ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                            Text(
                                                              // "Qty: ${positionProvider.positions![index].quantity.toString()}",
                                                              "${holdings.holdingQuantity.toString()}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              marketData != null
                                                                  ? marketData
                                                                      .price
                                                                      .toString()
                                                                  : '0.0',
                                                              style: TextStyle(
                                                                  color: marketData !=
                                                                          null
                                                                      ? (marketData.percentChange.toString().startsWith(
                                                                              '-')
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .green)
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                                '(${marketData != null ? marketData.percentChange.toString() : '0.0'}%)'),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Display Invested Value
                                              // Row(
                                              //   mainAxisAlignment:
                                              //   MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     Text(
                                              //       "Invested: ₹${investedValue.toStringAsFixed(2)}",
                                              //       style: TextStyle(
                                              //           fontSize: 15,
                                              //           fontWeight: FontWeight.w600),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  List<Holding>? sortByCMV(bool ascending, List<Holding>? value) {
    if (value != null) {
      value.sort((a, b) {
        var marketDataA = context
            .read<MarketFeedSocket>()
            .getDataById(int.parse(a.exchangeNSEInstrumentId.toString()));
        var marketDataB = context
            .read<MarketFeedSocket>()
            .getDataById(int.parse(b.exchangeNSEInstrumentId.toString()));

        double priceA = double.parse(marketDataA?.price ?? "0.0");
        double priceB = double.parse(marketDataB?.price ?? "0.0");

        if (ascending) {
          return priceA.compareTo(priceB);
        } else {
          return priceB.compareTo(priceA);
        }
      });
      _holdings = value.cast<Holding>();
    }
    return _holdings;
  }

  List<Holding>? sortByOverallPL(bool ascending, List<Holding>? value) {
    if (value != null) {
      value.sort((a, b) {
        var totalBenefitsA = getTotalBenefits(a);
        var totalBenefitsB = getTotalBenefits(b);

        if (ascending) {
          return totalBenefitsA.compareTo(totalBenefitsB);
        } else {
          return totalBenefitsB.compareTo(totalBenefitsA);
        }
      });
      _holdings = value;
    }
    return _holdings;
  }

  double getTotalBenefits(Holding holding) {
    var marketData = context
        .read<MarketFeedSocket>()
        .getDataById(int.parse(holding.exchangeNSEInstrumentId.toString()));
    var lastTradedPrice = double.tryParse(marketData?.price ?? '0.0') ?? 0.0;
    var buyAveragePrice =
        double.tryParse(holding.buyAvgPrice.toString()) ?? 0.0;
    var totalBenefits = (lastTradedPrice - buyAveragePrice) *
        double.parse(holding.holdingQuantity);
    return totalBenefits;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ChangeNotifierProvider<HoldingProvider>(
          create: (context) => HoldingProvider()..GetHoldings(),
          child: Consumer<HoldingProvider>(
            builder: (context, value, child) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double contentHeight = 500;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[400]!,
                              offset: const Offset(0, 20),
                              blurRadius: 30,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16.0),
                        constraints: BoxConstraints(
                          maxHeight: contentHeight > constraints.maxHeight
                              ? constraints.maxHeight
                              : contentHeight,
                        ),
                        child: contentHeight > constraints.maxHeight
                            ? SingleChildScrollView(
                                child: _buildBottomSheetContent(
                                    context, value, setState),
                              )
                            : _buildBottomSheetContent(
                                context, value, setState),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, HoldingProvider value, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Sort & Filter',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            Spacer(),
            InkWell(
              onTap: () {
                if (isAToZorZToA.contains('alphabeticalAZ')) {
                  setState(() {
                    isSorted = true;
                    _holdings = value.sortHoldingsByAlphabet(
                        true, value.holdings?.toList());
                  });
                }
                if (isAToZorZToA.contains('alphabeticalZA')) {
                  setState(() {
                    isSorted = true;
                    _holdings = value.sortHoldingsByAlphabet(
                        false, value.holdings?.toList());
                  });
                }
                if (isLowToHighOrHighToLow.contains('LowToHigh')) {
                  setState(() {
                    isSorted = true;
                    _holdings = sortByCMV(true, value.holdings?.toList());
                  });
                }
                if (isLowToHighOrHighToLow.contains('HighToLow')) {
                  setState(
                    () {
                      isSorted = true;
                      _holdings = sortByCMV(
                        false,
                        value.holdings?.toList(),
                      );
                    },
                  );
                }
                if (overAllPLIsLowToHighOrHighToLow
                    .contains("OverAllLowToHigh")) {
                  setState(() {
                    isSorted = true;
                    _holdings = sortByOverallPL(true, value.holdings?.toList());
                  });
                }
                if (overAllPLIsLowToHighOrHighToLow
                    .contains('OverAllHighToLow')) {
                  setState(
                    () {
                      isSorted = true;
                      _holdings = sortByOverallPL(
                        false,
                        value.holdings?.toList(),
                      );
                    },
                  );
                }
                Navigator.pop(context);
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(05),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Apply",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isAToZorZToA.clear();
                  isLowToHighOrHighToLow.clear();
                  daysPLIsLowToHighOrHighToLow.clear();
                  overAllPLIsLowToHighOrHighToLow.clear();
                });
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    border: Border.all(color: Colors.black),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Clear",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Alphabetically',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       if (selectedOptions.contains('alphabeticalAZ')) {
            //         selectedOptions.remove('alphabeticalAZ');
            //       } else {
            //         selectedOptions.add('alphabeticalAZ');
            //       }
            //     });
            //     // setState(() {
            //     //   isSorted = true;
            //     //   _positions = value.sortPositionsByAlphabet(true, value.positions?.toList());
            //     // });
            //     // Navigator.pop(context);
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: selectedOptions.contains('alphabeticalAZ')
            //         ? MaterialStateProperty.all(Colors.blue)
            //         : MaterialStateProperty.all(Colors.grey),
            //   ),
            //   child: Text('A-Z'),
            // ),
            InkWell(
              onTap: () {
                setState(() {
                  isAToZorZToA.clear();
                  isAToZorZToA.add('alphabeticalAZ');
                  isSorted = true;
                  _holdings = value.sortHoldingsByAlphabet(
                      true, value.holdings?.toList());
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: isAToZorZToA.contains('alphabeticalAZ')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'A-Z',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  isAToZorZToA.clear();
                  isAToZorZToA.add('alphabeticalZA');
                  isSorted = true;
                  _holdings = value.sortHoldingsByAlphabet(
                      false, value.holdings?.toList());
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: isAToZorZToA.contains('alphabeticalZA')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'Z-A',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // setState(() {
            //     //   isSorted = true;
            //     //   _positions = value.sortPositionsByAlphabet(false, value.positions?.toList());
            //     // });
            //     // Navigator.pop(context);
            //     setState(() {
            //       if (selectedOptions.contains('alphabeticalZA')) {
            //         selectedOptions.remove('alphabeticalZA');
            //       } else {
            //         selectedOptions.add('alphabeticalZA');
            //       }
            //     });
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: selectedOptions.contains('alphabeticalZA')
            //         ? MaterialStateProperty.all(Colors.blue)
            //         : MaterialStateProperty.all(Colors.grey),
            //   ),
            //   child: Text('Z-A'),
            // ),
          ],
        ),
        SizedBox(height: 20),
        Text('Current Market Value (CMV)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isLowToHighOrHighToLow.clear();
                  isLowToHighOrHighToLow.add('LowToHigh');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: isLowToHighOrHighToLow.contains('LowToHigh')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'Low to High',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       _positions = value.sortByCMV(true, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('Low to High'),
            // ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  isLowToHighOrHighToLow.clear();
                  isLowToHighOrHighToLow.add('HighToLow');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: isLowToHighOrHighToLow.contains('HighToLow')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'High to Low',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       _positions = value.sortByCMV(false, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('High to Low'),
            // ),
          ],
        ),
        SizedBox(height: 20), // Space between sections
        Text("Day's P/L",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  daysPLIsLowToHighOrHighToLow.clear();
                  daysPLIsLowToHighOrHighToLow.add('DaysLowToHigh');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color:
                        daysPLIsLowToHighOrHighToLow.contains('DaysLowToHigh')
                            ? Colors.grey[200]
                            : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'Low to High',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       // _positions = value.sortPositionsByDaysPL(true, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('Low to High'),
            // ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  daysPLIsLowToHighOrHighToLow.clear();
                  daysPLIsLowToHighOrHighToLow.add('DaysHighToLow');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color:
                        daysPLIsLowToHighOrHighToLow.contains('DaysHighToLow')
                            ? Colors.grey[200]
                            : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'High to Low',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       // _positions = value.sortPositionsByDaysPL(false, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('High to Low'),
            // ),
          ],
        ),
        SizedBox(height: 20), // Space between sections
        Text('Overall P/L',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       // _positions = value.sortPositionsByOverallPL(true, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('Low to High'),
            // ),
            InkWell(
              onTap: () {
                setState(() {
                  overAllPLIsLowToHighOrHighToLow.clear();
                  overAllPLIsLowToHighOrHighToLow.add('OverAllLowToHigh');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: overAllPLIsLowToHighOrHighToLow
                            .contains('OverAllLowToHigh')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'Low to High',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  overAllPLIsLowToHighOrHighToLow.clear();
                  overAllPLIsLowToHighOrHighToLow.add('OverAllHighToLow');
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: overAllPLIsLowToHighOrHighToLow
                            .contains('OverAllHighToLow')
                        ? Colors.grey[200]
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Text(
                      'High to Low',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isSorted = true;
            //       // _positions = value.sortPositionsByOverallPL(false, value.positions?.toList());
            //     });
            //     Navigator.pop(context);
            //   },
            //   child: Text('High to Low'),
            // ),
          ],
        ),
      ],
    );
  }
}

// class DisplayNameValue extends StatefulWidget {
//   final exchangeInstrumentID;

//   const DisplayNameValue({Key? key, required this.exchangeInstrumentID})
//       : super(key: key);
//   @override
//   _DisplayNameValueState createState() => _DisplayNameValueState();
// }

// class _DisplayNameValueState extends State<DisplayNameValue> {
//   Future? displayNameFuture;

//   @override
//   void initState() {
//     super.initState();
//     displayNameFuture = ApiService()
//         .GetDisplayName(int.parse(widget.exchangeInstrumentID), "1".toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: displayNameFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading...");
//         } else if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         } else {
//           // AppVariables.HodlingDisplayName.add(snapshot.data.toString());
//           // print(AppVariables.HodlingDisplayName);
//           return Text(
//             snapshot.data.toString(),
//             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//           );
//         }
//       },
//     );
//   }
// }
