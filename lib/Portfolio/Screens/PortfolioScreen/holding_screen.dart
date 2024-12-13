import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/instrument_details_screen.dart';
import 'package:tradingapp/MarketWatch/SearchOperations/screen/search_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Portfolio/Model/holding_model.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';

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
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.primaryBackgroundColor,
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
                HugeIcons.strokeRoundedSearch01,
                color: AppColors.primaryColorDark,
              )),
          IconButton(
            onPressed: () {
              _showFilterBottomSheet(context);
            },
            icon: Icon(
              HugeIcons.strokeRoundedFilter,
              color: AppColors.primaryColorDark,
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedMoveTo,
                color: AppColors.primaryColorDark,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.182,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondaryGrediantColor2.withOpacity(.6), width: 1),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryBackgroundColor,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.57),
                //     spreadRadius: 0,
                //     blurRadius: 1,
                //     offset: Offset(0, 1), // changes position of shadow
                //   ),
                // ],
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor3.withOpacity(0.7),
                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                    AppColors.primaryBackgroundColor.withOpacity(0.11),
                    AppColors.tertiaryGrediantColor3.withOpacity(0.11),
                  ],
                  stops: [0.04, 1.9, 0.69, 0.01, 0.31],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColorDark),
                          ),
                        ],
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          overallGain.toString().startsWith('-')
                              ? SvgPicture.asset(
                                  "assets/AppIcon/triangleDown.svg",
                                  height: 15,
                                  width: 15,
                                )
                              : SvgPicture.asset("assets/AppIcon/triangleUp.svg"),
                          Text(
                            "Overall Gain:",
                            style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("₹${overallGain.toStringAsFixed(2)}",
                              style: TextStyle(color: AppColors.primaryColorDark
                                  // color: overallGain.toString().startsWith('-')
                                  //     ? Colors.red
                                  //     : Colors.green),
                                  )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(${(totalInvestedValue != 0 ? (overallGain / totalInvestedValue) * 100 : 0).toStringAsFixed(2)}%)",
                            style: TextStyle(color: AppColors.primaryColorDark),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.ImageOrangeBackgroundColor, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Invested Value", style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "₹${totalInvestedValue.toStringAsFixed(2)}",
                                  style: TextStyle(color: AppColors.primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  todaysGain.toString().startsWith('-') ? SvgPicture.asset("assets/AppIcon/triangleDown.svg") : SvgPicture.asset("assets/AppIcon/triangleUp.svg"),
                                  Text(textAlign: TextAlign.end,
                                    "Today's Gain",
                                    style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₹${todaysGain.toStringAsFixed(2)}",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: todaysGain.toString().startsWith('-') ? AppColors.RedColor : AppColors.GreenColor),
                                  ),
                                  Text(
                                    "(${(totalInvestedValue != 0 ? (todaysGain / totalInvestedValue) * 100 : 0).toStringAsFixed(2)}%)",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: todaysGain.toString().startsWith('-') ? AppColors.RedColor : AppColors.GreenColor),
                                  )
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
                  Provider.of<HoldingProvider>(context, listen: false).GetHoldings();
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
                          if (HoldingProvider.holdings != null && HoldingProvider.holdings!.isNotEmpty) {
                            totalInvestedValue = 0.0;
                            overallGain = 0.0;
                            todaysGain = 0.0;

                            for (var holding in HoldingProvider.holdings!) {
                              var exchangeInstrumentID = holding.exchangeNSEInstrumentId;

                              if (AppVariables.isFirstTimeApiCalling < HoldingProvider.holdings!.length) {
                                AppVariables.isFirstTimeApiCalling++;

                                print(AppVariables.isFirstTimeApiCalling);

                                ApiService().MarketInstrumentSubscribe(
                                  1.toString(),
                                  exchangeInstrumentID.toString(),
                                );

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {});
                                });
                              }
                              double investedValue = double.parse(holding.holdingQuantity) * double.parse(holding.buyAvgPrice.toString());

                              marketData = context.read<MarketFeedSocket>().getDataById(int.parse(exchangeInstrumentID.toString()));
                              var lastTradedPrice = marketData?.price ?? 0.0;

                              double previousClosePrice = double.tryParse(marketData?.close.toString() ?? lastTradedPrice.toString()) ?? 0.0;

                              double lastTradedPriceDouble = lastTradedPrice is double ? lastTradedPrice : double.tryParse(lastTradedPrice.toString()) ?? 0.0;

                              double lastTradedPrice1 = double.tryParse(marketData?.price.toString() ?? '0') ?? 0.0;

                              double totalBenefits = (lastTradedPriceDouble - double.parse(holding.buyAvgPrice.toString())) * double.parse(holding.holdingQuantity);

                              double todaysPositionGain = (lastTradedPrice1 - previousClosePrice) * double.parse(holding.holdingQuantity);
                              todaysGain += todaysPositionGain;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  overallGain += totalBenefits;
                                  totalInvestedValue += investedValue;
                                  mainBalance = overallGain + totalInvestedValue;
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
                                itemCount: isSorted == true ? _holdings?.length ?? 0 : HoldingProvider.holdings!.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                itemBuilder: (context, index) {
                                  var holdings = isSorted == true ? _holdings![index] : HoldingProvider.holdings![index];
                                  // void fetchDisplayName() async {
                                  //   displayName = await ApiService()
                                  //       .GetDisplayName(
                                  //           holdings.exchangeNSEInstrumentId,
                                  //           "1");
                                  // }

// var displayname = await ApiService().GetDisplayName(holdings.exchangeNSEInstrumentId, "1");
                                  var quantity = holdings.holdingQuantity;
                                  var orderAvgLastTradedPrice = holdings.buyAvgPrice;

                                  var display = holdings.DisplayName;
                                  var exchangeSegment = 1;
                                  var exchangeInstrumentID = holdings.exchangeNSEInstrumentId;
                                  final marketData = marketFeedSocket.getDataById(int.parse(exchangeInstrumentID.toString()));
                                  var lastTradedPrice = marketData?.price.toString() ?? '0.0';
                                  if (lastTradedPrice != '0.0') {
                                    totalBenefits = (double.parse(lastTradedPrice) - double.parse(holdings.buyAvgPrice.toString())) * double.parse(holdings.holdingQuantity);
                                  }

                                  // double todaysPositionGain = (lastTradedPrice - previousClosePrice) *
                                  //     quantity;

                                  // double investedValue = quantity *
                                  //     (position.buyAveragePrice ?? 0.0);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewMoreInstrumentDetailScreen(
                                              exchangeInstrumentId: exchangeInstrumentID,
                                              exchangeSegment: 1.toString(),
                                              lastTradedPrice: marketData?.price ?? "0.0",
                                              close: marketData?.close ?? "0.0",
                                              displayName: holdings.DisplayName.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: AppColors.secondaryGrediantColor2.withOpacity(.1), width: 1),
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryBackgroundColor,
                                              AppColors.tertiaryGrediantColor3.withOpacity(0.7),
                                              AppColors.tertiaryGrediantColor1.withOpacity(1),
                                              AppColors.primaryBackgroundColor.withOpacity(0.11),
                                              AppColors.tertiaryGrediantColor3.withOpacity(0.11),
                                            ],
                                            stops: [0.04, 1.9, 0.69, 0.01, 0.31],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(color: AppColors.ImageOrangeBackgroundColor, borderRadius: BorderRadius.circular(5)),
                                                  child: Transform.scale(
                                                    scale: 0.6,
                                                    child: SvgPicture.network(
                                                      "https://ekyc.arhamshare.com/img//trading_app_logos//${holdings.DisplayName}.svg",
                                                      // fit: BoxFit.fill,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            holdings.DisplayName,
                                                            style: TextStyle(
                                                                color: AppColors.primaryColorDark,
                                                                // fontSize: 16,
                                                                fontWeight: FontWeight.w600),
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
                                                            totalBenefits != null ? totalBenefits!.toStringAsFixed(2) : '0.0',
                                                            style: TextStyle(color: AppColors.primaryColorDark, fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Avg: ${holdings.buyAvgPrice}",
                                                            style: TextStyle(fontSize: 13, color: AppColors.primaryColorDark1, fontWeight: FontWeight.w400),
                                                          ),
                                                          Text(
                                                            " X ",
                                                            style: TextStyle(color: AppColors.primaryColorDark1),
                                                          ),
                                                          Text(
                                                            // "Qty: ${positionProvider.positions![index].quantity.toString()}",
                                                            "${holdings.holdingQuantity.toString()}",
                                                            style: TextStyle(fontSize: 13, color: AppColors.primaryColorDark, fontWeight: FontWeight.w400),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            marketData != null ? marketData.price.toString() : '0.0',
                                                            style: TextStyle(
                                                                color: marketData != null
                                                                    ? (marketData.percentChange.toString().startsWith('-') ? AppColors.RedColor : AppColors.GreenColor)
                                                                    : AppColors.primaryColorDark),
                                                          ),
                                                          Text('(${marketData != null ? marketData.percentChange.toString() : '0.0'}%)',
                                                              style: TextStyle(
                                                                  color: marketData != null
                                                                      ? (marketData.percentChange.toString().startsWith('-') ? AppColors.RedColor : AppColors.GreenColor)
                                                                      : AppColors.primaryColorDark1)),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          marketData != null
                                                              ? (marketData.percentChange.toString().startsWith('-')
                                                                  ? SvgPicture.asset("assets/AppIcon/triangleDown.svg")
                                                                  : SvgPicture.asset("assets/AppIcon/triangleUp.svg"))
                                                              : SvgPicture.asset("assets/AppIcon/triangleDown.svg"),
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
        var marketDataA = context.read<MarketFeedSocket>().getDataById(int.parse(a.exchangeNSEInstrumentId.toString()));
        var marketDataB = context.read<MarketFeedSocket>().getDataById(int.parse(b.exchangeNSEInstrumentId.toString()));

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
    var marketData = context.read<MarketFeedSocket>().getDataById(int.parse(holding.exchangeNSEInstrumentId.toString()));
    var lastTradedPrice = double.tryParse(marketData?.price ?? '0.0') ?? 0.0;
    var buyAveragePrice = double.tryParse(holding.buyAvgPrice.toString()) ?? 0.0;
    var totalBenefits = (lastTradedPrice - buyAveragePrice) * double.parse(holding.holdingQuantity);
    return totalBenefits;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .6241,
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
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
                          color: AppColors.primaryBackgroundColor,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                            // maxHeight: contentHeight > constraints.maxHeight ? constraints.maxHeight : contentHeight,
                            ),
                        child: contentHeight > constraints.maxHeight
                            ? SingleChildScrollView(
                                child: _buildBottomSheetContent(context, value, setState),
                              )
                            : _buildBottomSheetContent(context, value, setState),
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

  Widget _buildBottomSheetContent(BuildContext context, HoldingProvider value, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Sort & Filter', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            Spacer(),
            // InkWell(
            //   onTap: () {
            //     if (isAToZorZToA.contains('alphabeticalAZ')) {
            //       setState(() {
            //         isSorted = true;
            //         _holdings = value.sortHoldingsByAlphabet(
            //             true, value.holdings?.toList());
            //       });
            //     }
            //     if (isAToZorZToA.contains('alphabeticalZA')) {
            //       setState(() {
            //         isSorted = true;
            //         _holdings = value.sortHoldingsByAlphabet(
            //             false, value.holdings?.toList());
            //       });
            //     }
            //     if (isLowToHighOrHighToLow.contains('LowToHigh')) {
            //       setState(() {
            //         isSorted = true;
            //         _holdings = sortByCMV(true, value.holdings?.toList());
            //       });
            //     }
            //     if (isLowToHighOrHighToLow.contains('HighToLow')) {
            //       setState(
            //         () {
            //           isSorted = true;
            //           _holdings = sortByCMV(
            //             false,
            //             value.holdings?.toList(),
            //           );
            //         },
            //       );
            //     }
            //     if (overAllPLIsLowToHighOrHighToLow
            //         .contains("OverAllLowToHigh")) {
            //       setState(() {
            //         isSorted = true;
            //         _holdings = sortByOverallPL(true, value.holdings?.toList());
            //       });
            //     }
            //     if (overAllPLIsLowToHighOrHighToLow
            //         .contains('OverAllHighToLow')) {
            //       setState(
            //         () {
            //           isSorted = true;
            //           _holdings = sortByOverallPL(
            //             false,
            //             value.holdings?.toList(),
            //           );
            //         },
            //       );
            //     }
            //     Navigator.pop(context);
            //   },
            //   child: Container(
            //     height: 35,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(05),
            //       border: Border.all(color: Colors.black),
            //       color: AppColors.primaryColor,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //       child: Center(
            //         child: Text(
            //           "Apply",
            //           style: GoogleFonts.inter(
            //             color: Colors.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              width: 70,
              height: 35,
              child: CustomButton(
                  isLoading: false,
                  text: "Apply",
                  onPressed: () {
                    if (isAToZorZToA.contains('alphabeticalAZ')) {
                      setState(() {
                        isSorted = true;
                        _holdings = value.sortHoldingsByAlphabet(true, value.holdings?.toList());
                      });
                    }
                    if (isAToZorZToA.contains('alphabeticalZA')) {
                      setState(() {
                        isSorted = true;
                        _holdings = value.sortHoldingsByAlphabet(false, value.holdings?.toList());
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
                    if (overAllPLIsLowToHighOrHighToLow.contains("OverAllLowToHigh")) {
                      setState(() {
                        isSorted = true;
                        _holdings = sortByOverallPL(true, value.holdings?.toList());
                      });
                    }
                    if (overAllPLIsLowToHighOrHighToLow.contains('OverAllHighToLow')) {
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
                  }),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 70,
              height: 40,
              child: CustomSelectionButton(
                  isSelected: false,
                  text: "Clear",
                  onPressed: () {
                    setState(() {
                      isAToZorZToA.clear();
                      isLowToHighOrHighToLow.clear();
                      daysPLIsLowToHighOrHighToLow.clear();
                      overAllPLIsLowToHighOrHighToLow.clear();
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Alphabetically', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
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
            CustomSelectionButton(
              isSelected: isAToZorZToA.contains('alphabeticalAZ'),
              text: "A-Z",
              onPressed: () {
                setState(() {
                  isAToZorZToA.clear();
                  isAToZorZToA.add('alphabeticalAZ');
                  isSorted = true;
                  _holdings = value.sortHoldingsByAlphabet(true, value.holdings?.toList());
                });
              },
            ),

            SizedBox(width: 10),
            CustomSelectionButton(
              isSelected: isAToZorZToA.contains('alphabeticalZA'),
              text: "Z-A",
              onPressed: () {
                setState(() {
                  isAToZorZToA.clear();
                  isAToZorZToA.add('alphabeticalZA');
                  isSorted = true;
                  _holdings = value.sortHoldingsByAlphabet(false, value.holdings?.toList());
                });
              },
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
        Text('Current Market Value (CMV)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),

        SizedBox(height: 10),
        Row(
          children: [
            CustomSelectionButton(
              width: 130,
              isSelected: isLowToHighOrHighToLow.contains('LowToHigh'),
              text: "Low to High",
              onPressed: () {
                setState(() {
                  isLowToHighOrHighToLow.clear();
                  isLowToHighOrHighToLow.add('LowToHigh');
                });
              },
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
            CustomSelectionButton(
              width: 130,
              isSelected: isLowToHighOrHighToLow.contains('HighToLow'),
              text: "High to Low",
              onPressed: () {
                setState(() {
                  isLowToHighOrHighToLow.clear();
                  isLowToHighOrHighToLow.add('HighToLow');
                });
              },
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
        Text("Day's P/L", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            CustomSelectionButton(
              width: 130,
              isSelected: daysPLIsLowToHighOrHighToLow.contains('DaysLowToHigh'),
              text: "Low to High",
              onPressed: () {
                setState(() {
                  daysPLIsLowToHighOrHighToLow.clear();
                  daysPLIsLowToHighOrHighToLow.add('DaysLowToHigh');
                });
              },
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
            CustomSelectionButton(
              width: 130,
              isSelected: daysPLIsLowToHighOrHighToLow.contains('DaysHighToLow'),
              text: "High to Low",
              onPressed: () {
                setState(() {
                  daysPLIsLowToHighOrHighToLow.clear();
                  daysPLIsLowToHighOrHighToLow.add('DaysHighToLow');
                });
              },
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
        Text('Overall P/L', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(height: 10),
        Row(
          children: [
            CustomSelectionButton(
              width: 130,
              isSelected: overAllPLIsLowToHighOrHighToLow.contains('OverAllLowToHigh'),
              text: "Low to High",
              onPressed: () {
                setState(() {
                  overAllPLIsLowToHighOrHighToLow.clear();
                  overAllPLIsLowToHighOrHighToLow.add('OverAllLowToHigh');
                });
              },
            ),
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

            SizedBox(width: 10),
            CustomSelectionButton(
              width: 130,
              isSelected: overAllPLIsLowToHighOrHighToLow.contains('OverAllHighToLow'),
              text: "High to Low",
              onPressed: () {
                setState(() {
                  overAllPLIsLowToHighOrHighToLow.clear();
                  overAllPLIsLowToHighOrHighToLow.add('OverAllHighToLow');
                });
              },
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
    ).paddingOnly(
      bottom: MediaQuery.of(context).padding.bottom,
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
