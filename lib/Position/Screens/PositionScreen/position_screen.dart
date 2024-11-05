import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingapp/DashBoard/Screens/BuyOrSellScreen/modify_order.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/Portfolio/Model/holding_model.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/order_status.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/viewmore_order_history.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Position/Models/TradeOrderModel/tradeOrder_model.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/market_screen.dart';
import 'package:tradingapp/ordersocketvalues_model.dart';

class PositionScreen extends StatefulWidget {
  const PositionScreen({super.key});

  @override
  State<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokend = prefs.getString('token');
    print('Tokens: $tokend');
    return tokend!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDashboard1(),
      endDrawer: DrawerDashboard2(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.read_more),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text('Position'),
        bottom: TabBar(
          indicatorColor: Colors.blue,
          isScrollable: true,
          labelColor: Colors.blue,
          tabAlignment: TabAlignment.start,
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Order'),
            Tab(text: 'Position'),
            Tab(text: 'Trade Book'),
            Tab(text: 'Order History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderProviderScreen(),
          //#################################################### below code is for Position content##################################
          PositionProviderScreen(),
          TradeProviderScreen(),
          OrderHistoryProviderScreen(),
        ],
      ),
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<OrderValues>? _ordervalues;
  List<OrderValues>? _filteredOrderValues;
  String _selectedFilter = 'ALL';

  String searchTerm = '';

  List<OrderValues>? get ordervalues => _ordervalues;
  List<OrderValues>? get filteredOrderValues => _filteredOrderValues;

  Future<void> GetOrder() async {
    final apiService = ApiService();
    final response = await apiService.GetOrder(); // Call your API function here
    _ordervalues = OrderValues.fromJsonList(response);
    _filteredOrderValues = _ordervalues; // Initialize filtered orders
    print(response);
    notifyListeners();
  }

  Future<void> refreshOrder() async {
    await GetOrder();
    notifyListeners();
  }

  void setSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }

  void filterOrders(String filter) {
    _selectedFilter = filter;
    if (filter == 'ALL') {
      _filteredOrderValues = _ordervalues;
    } else {
      _filteredOrderValues =
          _ordervalues?.where((order) => order.orderStatus == filter).toList();
    }
    notifyListeners();
  }

  String get selectedFilter => _selectedFilter;
}

class PositionProvider with ChangeNotifier {
  List<Positions>? _positions;

  String searchTerm = '';
  List<Positions>? get positions => _positions;

  List<Positions>? sortPositionsByAlphabet(
      bool ascending, List<Positions>? value) {
    if (value != null) {
      value.sort((a, b) {
        if (ascending) {
          return a.tradingSymbol.compareTo(b.tradingSymbol);
        } else {
          return b.tradingSymbol.compareTo(a.tradingSymbol);
        }
      });
      print(
          "Positions after sorting: ${value.map((e) => e.tradingSymbol).toList()}");
      _positions = value;
      notifyListeners();
    }
    return _positions;
  }

  // void sortByProfitAscending() {
  //   _positions?.sort((a, b) {
  //     double aProfit = (a.quantity ?? 0.0) * (double.parse(a.actualBuyAveragePrice.toString()));
  //     double bProfit = (b.quantity ?? 0.0) * (double.parse(b.actualBuyAveragePrice.toString()));
  //     return aProfit.compareTo(bProfit);
  //   });
  //   notifyListeners();
  // }

  Future<void> getPosition() async {
    final apiService = ApiService();
    final response = await apiService.GetPosition();
    _positions = Positions.fromJsonList(response);
    notifyListeners();
  }

  void setSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }

  List<Object> get filteredPositions {
    if (positions == null) {
      return [];
    } else {
      return positions!
          .where((position) => position.tradingSymbol.contains(searchTerm))
          .toList();
    }
  }
}

class HoldingProvider with ChangeNotifier {
  List<Holding>? _holdings;
  String searchTerm = '';

  List<Holding>? get holdings => _holdings;

  /// Sort holdings alphabetically based on ISIN
  List<Holding>? sortHoldingsByAlphabet(bool ascending, List<Holding>? value) {
    if (value != null) {
      value.sort((a, b) {
        if (ascending) {
          return a.DisplayName.compareTo(b.DisplayName);
        } else {
          return b.DisplayName.compareTo(a.DisplayName);
        }
      });
      print("Holdings after sorting: ${value.map((e) => e.isin).toList()}");
      _holdings = value;
      notifyListeners();
    }
    return _holdings;
  }

  /// Fetch holdings from API
  Future<void> GetHoldings() async {
    final apiService = ApiService(); // You need to define ApiService
    final response =
        await apiService.GetHoldings(); // Assume this method fetches holdings
    _holdings = Holding.fromJsonList(response);
    notifyListeners();
  }

  /// Set the search term and notify listeners
  void setSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }

  /// Filter holdings based on the search term (using ISIN here as an example)
  List<Holding> get filteredHoldings {
    if (_holdings == null) {
      return [];
    } else {
      return _holdings!
          .where((holding) => holding.DisplayName.contains(searchTerm))
          .toList();
    }
  }
}

class TradeProvider with ChangeNotifier {
  List<TradeOrder>? _positions;

  String searchTerm = '';

  List<TradeOrder>? get positions => _positions;

  Future<void> getTrades() async {
    final apiService = ApiService();
    final response =
        await apiService.GetTrades(); // Call your API function here
    _positions = TradeOrder.fromJsonList(response);
    notifyListeners();
  }

  void setSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }

  List<Object> get filteredPositions {
    if (positions == null) {
      return [];
    } else {
      return positions!
          .where((position) => position.tradingSymbol.contains(searchTerm))
          .toList();
    }
  }
}

class PositionProviderScreen extends StatefulWidget {
  @override
  _PositionProviderScreenState createState() => _PositionProviderScreenState();
}

class _PositionProviderScreenState extends State<PositionProviderScreen> {
  String search = '';
  String selectedFilter = 'ALL';
  String selectedExchangeSegment = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ChangeNotifierProvider(
        create: (context) => PositionProvider()..getPosition(),
        child: Consumer<PositionProvider>(
          builder: (context, positionProvider, child) {
            if (positionProvider.positions == null) {
              return Center(child: CircularProgressIndicator());
            } else if (positionProvider.positions!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/error_illustrations/order_error.svg',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "You have no positions. Place an order to open a new position",
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else {
              if (positionProvider.positions != null &&
                  positionProvider.positions!.isNotEmpty) {
                for (var position in positionProvider.positions!) {
                  var exchangeSegment = position.exchangeSegment;
                  var exchangeInstrumentID = position.exchangeInstrumentId;

                  ApiService().MarketInstrumentSubscribe(
                    ExchangeConverter()
                        .getExchangeSegmentNumber(exchangeSegment)
                        .toString(),
                    exchangeInstrumentID.toString(),
                  );
                }
              }

              // Apply both CNC/NRML/MIS and ExchangeSegment filters
              List<Positions> filteredPositions = positionProvider.positions!;

              // Filter based on product type
              if (selectedFilter != 'ALL') {
                filteredPositions = filteredPositions
                    .where((position) => position.productType == selectedFilter)
                    .toList();
              }

              // Filter based on exchange segment
              if (selectedExchangeSegment != 'ALL') {
                filteredPositions = filteredPositions
                    .where((position) =>
                        position.exchangeSegment == selectedExchangeSegment)
                    .toList();
              }

              return Consumer<MarketFeedSocket>(
                builder: (context, marketFeedSocket, child) {
                  return Column(
                    children: [
                      // Filters row for product type and exchange segment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterButtonPosition(
                            text: 'ALL',
                            isSelected: selectedFilter == 'ALL',
                            onPressed: () {
                              setState(() {
                                selectedFilter = 'ALL';
                              });
                            },
                          ),
                          FilterButtonPosition(
                            text: 'CNC',
                            isSelected: selectedFilter == 'CNC',
                            onPressed: () {
                              setState(() {
                                selectedFilter = 'CNC';
                              });
                            },
                          ),
                          FilterButtonPosition(
                            text: 'NRML',
                            isSelected: selectedFilter == 'NRML',
                            onPressed: () {
                              setState(() {
                                selectedFilter = 'NRML';
                              });
                            },
                          ),
                          FilterButtonPosition(
                            text: 'MIS',
                            isSelected: selectedFilter == 'MIS',
                            onPressed: () {
                              setState(() {
                                selectedFilter = 'MIS';
                              });
                            },
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: PopupMenuButton<String>(
                                color: Colors.white,
                                onSelected: (String value) {
                                  setState(() {
                                    selectedExchangeSegment = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    'ALL',
                                    'BSECM',
                                    'NSECM',
                                    'NSEFO',
                                    'BSEFO'
                                  ].map((String value) {
                                    return PopupMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color:
                                              selectedExchangeSegment == value
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        selectedExchangeSegment,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredPositions.length,
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          itemBuilder: (context, index) {
                            var position = filteredPositions[index];

                            var quentity = position.quantity;
                            var exchangeInstrumentID =
                                position.exchangeInstrumentId;
                            final marketData = marketFeedSocket.getDataById(
                                int.parse(exchangeInstrumentID.toString()));
                            var lastTradedPrice =
                                marketData?.price.toString() ?? 'Loading...';
                            double? totalBenefits;
                            if (lastTradedPrice != 'Loading...') {
                              totalBenefits = (double.parse(lastTradedPrice) -
                                      double.parse(position.buyAveragePrice
                                          .toString())) *
                                  quentity;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              position.tradingSymbol,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            totalBenefits != null
                                                ? totalBenefits
                                                    .toStringAsFixed(2)
                                                : 'Loading...',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(position.marketLot),
                                              SizedBox(width: 10),
                                              Text(position.productType),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                marketData != null
                                                    ? marketData.price
                                                        .toString()
                                                    : 'Loading...',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                  '(${marketData != null ? marketData.percentChange.toString() : 'Loading...'}%)'),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Qty: ${position.quantity.toString()}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(position.exchangeSegment),
                                            ],
                                          ),
                                          Text(
                                            "Avg: ${position.buyAveragePrice.toStringAsFixed(2)}",
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class TradeProviderScreen extends StatefulWidget {
  @override
  _TradeProviderScreenState createState() => _TradeProviderScreenState();
}

class _TradeProviderScreenState extends State<TradeProviderScreen> {
  String search = '';
  int getExchangeSegmentNumber(String exchangeSegment) {
    switch (exchangeSegment) {
      case 'NSECM':
        return 1;
      case 'NSEFO':
        return 2;
      case 'NSECD':
        return 3;
      case 'BSECM':
        return 11;
      case 'BSEFO':
        return 12;
      case 'BSECD':
        return 13;
      default:
        return 0; // Return 0 or any other number for 'Unknown'
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ChangeNotifierProvider(
        create: (context) => TradeProvider()..getTrades(),
        child: Consumer<TradeProvider>(
          builder: (context, positionProvider, child) {
            if (positionProvider.positions == null) {
              return Center(child: CircularProgressIndicator());
            } else if (positionProvider.positions!.isEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/error_illustrations/time_error.svg',
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "You have no Trade. Place an order to open a new Trade",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ]);
            } else {
              if (positionProvider.positions != null &&
                  positionProvider.positions!.isNotEmpty) {
                for (var position in positionProvider.positions!) {
                  print(
                      "=========================${positionProvider.positions!.length}");
                  var exchangeSegment = position.exchangeSegment;
                  var exchangeInstrumentID = position.exchangeInstrumentID;

                  ApiService().MarketInstrumentSubscribe(
                      getExchangeSegmentNumber(exchangeSegment).toString(),
                      exchangeInstrumentID.toString());
                }
              }
              return Consumer<MarketFeedSocket>(
                  builder: (context, marketFeedSocket, child) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: positionProvider.positions!.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Add this line
                        itemBuilder: (context, index) {
                          var position = positionProvider.positions![index];
                          var quentity = position.lastTradedQuantity;
                          var orderAvglastTradedPrice =
                              position.orderAverageTradedPrice;

                          var exchangeInstrumentID =
                              position.exchangeInstrumentID;
                          final marketData = marketFeedSocket.getDataById(
                              int.parse(exchangeInstrumentID.toString()));
                          var lastTradedPrice =
                              marketData?.price.toString() ?? 'Loading...';
                          double? TotalBenifits;
                          if (lastTradedPrice != 'Loading...') {
                            TotalBenifits = (double.parse(lastTradedPrice) -
                                    double.parse(orderAvglastTradedPrice)) *
                                (quentity);
                          }
                          // print(positionProvider.positions![index].exchangeInstrumentID);
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.grey,
                                //       blurRadius: 0.5,
                                //       spreadRadius: 0.05,
                                //       offset: Offset(0, 1))
                                // ],
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: position.orderSide == 'BUY'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                      ),
                                      width: 30,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          position.orderSide == 'BUY'
                                              ? "B"
                                              : "S",
                                          style: TextStyle(
                                            color: position.orderSide == 'BUY'
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      positionProvider
                                                          .positions![index]
                                                          .tradingSymbol,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Text(
                                                    positionProvider
                                                        .positions![index]
                                                        .orderStatus
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: positionProvider
                                                                  .positions![
                                                                      index]
                                                                  .orderStatus
                                                                  .toString() ==
                                                              'Filled'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   TotalBenifits != null
                                                  //       ? TotalBenifits.toStringAsFixed(2)
                                                  //       : 'Loading...',
                                                  //   style: TextStyle(color: Colors.red),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
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
                                                      positionProvider
                                                          .positions![index]
                                                          .productType,
                                                      style: TextStyle(
                                                        color: positionProvider
                                                                    .positions![
                                                                        index]
                                                                    .orderSide
                                                                    .toString() ==
                                                                'BUY'
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "OrderID : ${positionProvider.positions![index].appOrderID.toString()}"),
                                                    // Text(
                                                    //   marketData != null
                                                    //       ? marketData.price
                                                    //           .toString()
                                                    //       : 'Loading...',
                                                    //   style: TextStyle(
                                                    //       color: Colors.red),
                                                    // ),
                                                    // Text(
                                                    //     '(${marketData != null ? marketData.percentChange.toString() : 'Loading...'}%)'),
                                                  ],
                                                )
                                              ]),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Avg ${positionProvider.positions![index].orderAverageTradedPrice.toString()} X ",
                                                    style: TextStyle(),
                                                  ),
                                                  Text(positionProvider
                                                      .positions![index]
                                                      .lastTradedQuantity
                                                      .toString())
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  // Text("Order ID: "),
                                                  Text(
                                                    positionProvider
                                                        .positions![index]
                                                        .orderGeneratedDateTime
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: positionProvider
                                                                  .positions![
                                                                      index]
                                                                  .orderSide
                                                                  .toString() ==
                                                              'BUY'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    )
                  ]),
                );
              });
            }
          },
        ),
      ),
    );
  }
}

class OrderProviderScreen extends StatefulWidget {
  @override
  _OrderProviderScreenState createState() => _OrderProviderScreenState();
}

class _OrderProviderScreenState extends State<OrderProviderScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final orderProvider = OrderProvider();

        orderProvider.GetOrder();
        return orderProvider;
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            if (orderProvider.ordervalues == null) {
              return Center(child: CircularProgressIndicator());
            } else if (orderProvider.ordervalues!.isEmpty) {
              return Center(
                  child: Text(
                      style: TextStyle(),
                      "No Orders found. Place an order to view here."));
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await orderProvider.refreshOrder();
                },
                child: Column(
                  children: [
                    FilterButtons(
                      selectedFilter: orderProvider.selectedFilter,
                      onFilterChanged: (filter) {
                        orderProvider.filterOrders(filter);
                      },
                    ),
                    Expanded(
                      child: Consumer<MarketFeedSocket>(
                        builder: (context, marketFeedSocket, child) {
                          var reversedOrderValues =
                              orderProvider.filteredOrderValues!.toList();
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: reversedOrderValues.length,
                            padding: const EdgeInsets.symmetric(vertical: 8.0)
                                .copyWith(bottom: 100.0),
                            itemBuilder: (context, index) {
                              var orderValues = reversedOrderValues[index];

                              var exchangeInstrumentID =
                                  orderValues.exchangeInstrumentID;
                              final marketData = marketFeedSocket.getDataById(
                                  int.parse(exchangeInstrumentID.toString()));

                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Colors.grey,
                                    //       blurRadius: 0.5,
                                    //       spreadRadius: 0.05,
                                    //       offset: Offset(0, 1))
                                    // ],
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                orderValues.tradingSymbol,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    // fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    orderValues.orderStatus ==
                                                            'New'
                                                        ? 'Pending'
                                                        : orderValues
                                                            .orderStatus,
                                                    style: TextStyle(
                                                      color: orderValues
                                                                  .orderStatus ==
                                                              'Rejected'
                                                          ? Colors.red
                                                          : orderValues
                                                                      .orderStatus ==
                                                                  'New'
                                                              ? Colors.blue
                                                              : Colors.green,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                if (orderValues.orderStatus ==
                                                    'Rejected')
                                                  GestureDetector(
                                                    child: Icon(
                                                      Icons.info_outline,
                                                      color: Colors.black,
                                                      size: 17,
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(orderValues
                                                                        .orderStatus ==
                                                                    'New'
                                                                ? 'Pending'
                                                                : "Rejected"),
                                                            content: Text(
                                                              orderValues
                                                                  .cancelRejectReason,
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                    'Close'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                if (orderValues.orderStatus ==
                                                    'New')
                                                  GestureDetector(
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.black,
                                                      size: 17,
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ModifyOrderScreen(
                                                          orderValues:
                                                              orderValues,
                                                        );
                                                      }));
                                                    },
                                                  ),
                                                if (orderValues.orderStatus ==
                                                    'New')
                                                  GestureDetector(
                                                    onTap: () async {
                                                      bool confirm =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title:
                                                              Text('Confirm'),
                                                          content: Text(
                                                              'Are you sure you want to cancel this order?'),
                                                          actions: [
                                                            ElevatedButton(
                                                              child: Text('No'),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                            ),
                                                            ElevatedButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true),
                                                            ),
                                                          ],
                                                        ),
                                                      );

                                                      if (confirm) {
                                                        print(
                                                            'Cancelling order...');
                                                        // Call the cancelOrder function with the appOrderID
                                                        await ApiService()
                                                            .cancelOrder(
                                                                orderValues
                                                                    .appOrderID
                                                                    .toString());
                                                        await orderProvider
                                                            .refreshOrder();
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.cancel_outlined,
                                                      size: 17,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    orderValues.orderSide,
                                                    style: TextStyle(
                                                      color: orderValues
                                                                  .orderSide ==
                                                              'BUY'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(orderValues.productType),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(orderValues
                                                      .exchangeSegment
                                                      .toString())
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    marketData != null
                                                        ? marketData.price
                                                            .toString()
                                                        : 'Loading...',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                      '(${marketData != null ? marketData.percentChange.toString() : 'Loading...'}%)'),
                                                ],
                                              )
                                            ]),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Qty: ${orderValues.orderQuantity.toString()}",
                                                  style: TextStyle(
                                                      // fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(orderValues
                                                    .exchangeTransactTime
                                                    .toString())
                                              ],
                                            ),
                                            Text(
                                              "Avg: ${orderValues.orderPrice.toString()}",
                                              style: TextStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  FilterButtons({required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterButton(
            text: 'ALL',
            isSelected: selectedFilter == 'ALL',
            onPressed: () => onFilterChanged('ALL'),
          ),
          FilterButton(
            text: 'Pending',
            isSelected: selectedFilter == 'New',
            onPressed: () => onFilterChanged('New'),
          ),
          FilterButton(
            text: 'Success',
            isSelected: selectedFilter == 'Filled',
            onPressed: () => onFilterChanged('Filled'),
          ),
          FilterButton(
            text: 'Rejected',
            isSelected: selectedFilter == 'Rejected',
            onPressed: () => onFilterChanged('Rejected'),
          ),
          FilterButton(
            text: 'Cancelled',
            isSelected: selectedFilter == 'Cancelled',
            onPressed: () => onFilterChanged('Cancelled'),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  FilterButton(
      {required this.text, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: badges.Badge(
        showBadge: isSelected,
        position: badges.BadgePosition.topStart(top: 0, start: 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: isSelected
                      ? BorderSide(color: Colors.blue)
                      : BorderSide(color: Colors.grey[300]!)),
              elevation: 0,
              shadowColor: Colors.transparent,
             
              foregroundColor: isSelected ? Colors.blue : Colors.grey,
              backgroundColor:
                  isSelected ? Colors.blue.withOpacity(0.1) : Colors.white),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}

class FilterButtonPosition extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  FilterButtonPosition(
      {required this.text, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
      child: badges.Badge(
        showBadge: isSelected,
        position: badges.BadgePosition.topStart(top: 0, start: 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: isSelected
                      ? BorderSide(color: Colors.blue)
                      : BorderSide(color: Colors.grey[300]!)),
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              foregroundColor: isSelected ? Colors.blue : Colors.grey,
              backgroundColor:
                  isSelected ? Colors.blue.withOpacity(0.1) : Colors.white),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderSocketValues order;

  const OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ModifyOrderScreen(
        //       orderValues: order,
        //     ),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.5,
                  spreadRadius: 0.05,
                  offset: Offset(0, 1))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: order.orderSide == 'Buy'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                      ),
                      width: 30,
                      height: 30,
                      child: Center(
                        child: Text(
                          order.orderSide == 'Buy' ? "B" : "S",
                          style: TextStyle(
                            color: order.orderSide == 'Buy'
                                ? Colors.green
                                : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        order.TradingSymbol,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          order.orderStatus == 'New'
                              ? 'Pending'
                              : order.orderStatus,
                          style: TextStyle(
                            color: order.orderStatus == 'Rejected'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Icon(Icons.info_outline,
                              color: Colors.black, size: 17),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(order.orderStatus),
                                  content: Text(order.cancelRejectReason),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.orderQuantity.toString(),
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 10),
                        Text("DEL"),
                        SizedBox(width: 10),
                        Text(order.exchangeSegment.toString()),
                      ],
                    ),
                    Consumer<MarketFeedSocket>(
                        builder: (context, marketFeedSocket, child) {
                      var marketData = marketFeedSocket.getDataById(
                          int.parse(order.exchangeInstrumentID.toString()));
                      return Row(
                        children: [
                          Text(
                            marketData != null
                                ? marketData.price.toString()
                                : 'Loading...',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                              '(${marketData != null ? marketData.percentChange.toString() : 'Loading...'}%)'),
                        ],
                      );
                    }),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Qty: ${order.orderQuantity.toString()}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 10),
                        Text(order.orderSide.toString()),
                      ],
                    ),
                    Text(
                      "Order Price: ${order.orderPrice.toString()}",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class OrderHistoryProvider with ChangeNotifier {
//   List<OrderHistory>? _orderHistory;
//   bool _disposed = false;

//   @override
//   void dispose() {
//     _disposed = true;
//     super.dispose();
//   }

//   List<OrderHistory>? get orderhistory => _orderHistory;

//   Future<void> GetOrderHistroy() async {
//     try {
//       final apiService = ApiService();
//       final response =
//           await apiService.GetOrderHistroy(); // Call your API function here
//       print("4567u8iuytfgh${response}");
//       // Assuming response is a list of OrderHistory objects
//       _orderHistory =
//           OrderHistory.fromJsonList(response); // Update the order history list

//       if (!_disposed) {
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error fetching order history: $e');
//       if (!_disposed) {
//         notifyListeners();
//       }
//     }
//   }

//   void setSearchTerm(String term) {
//     // Optionally implement search functionality
//     notifyListeners();
//   }
// }
class OrderHistoryProvider with ChangeNotifier {
  static List<OrderHistory>?
      _staticOrderHistory; // Static variable to hold data
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  List<OrderHistory>? get orderhistory =>
      _staticOrderHistory; // Return static data

  Future<void> GetOrderHistroy() async {
    try {
      final apiService = ApiService();
      final response = await apiService.GetOrderHistroy("NSECM", "2024-04-21",
          DateTime.now().toString()); // Call your API function here
      print("API Response: $response");
      // Assuming response is a list of OrderHistory objects
      _staticOrderHistory = OrderHistory.fromJsonList(
          response); // Update the static order history list

      if (!_disposed) {
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching order history: $e');
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  void setSearchTerm(String term) {
    // Optionally implement search functionality
    notifyListeners();
  }
}

class OrderHistoryProviderScreen extends StatefulWidget {
  @override
  _OrderHistoryProviderScreenState createState() =>
      _OrderHistoryProviderScreenState();
}

class _OrderHistoryProviderScreenState
    extends State<OrderHistoryProviderScreen> {
  String search = '';
  String datePickedValue = "";
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedOptionType;
  List<String> optionTypes = [
    'NSECM',
    'NSEFO',
    'Other'
  ]; // Example option types

  List<OrderHistory> filteredPositions = [];

  Future<void> _showDateTimePicker(BuildContext context,
      {required bool isFromDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFromDate ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      // Implement your logic to fetch and display filtered data based on the new date range.
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<OrderHistoryProvider>(context, listen: false)
              .GetOrderHistroy();
        },
        child: ChangeNotifierProvider(
          create: (context) => OrderHistoryProvider()..GetOrderHistroy(),
          child: Consumer<OrderHistoryProvider>(
            builder: (context, orderHistoryProvider, child) {
              var orderHistoryProvider =
                  Provider.of<OrderHistoryProvider>(context);

              if (orderHistoryProvider.orderhistory == null) {
                return Center(child: CircularProgressIndicator());
              } else if (orderHistoryProvider.orderhistory!.isEmpty) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/order.png',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            style: TextStyle(),
                            "No Orders found. Place an order to view here."),
                        SizedBox(
                          height: 150,
                        )
                      ]),
                );
              } else {
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              alignment: Alignment.center,
                              value: _selectedOptionType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOptionType = newValue;
                                });
                                // Implement your logic to fetch and display filtered data based on the new selection.
                              },
                              borderRadius: BorderRadius.circular(10),
                              items: optionTypes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  enabled: true,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            TextButton(
                              onPressed: () {
                                _showDateTimePicker(context,
                                    isFromDate:
                                        true); // Assuming you want to pick the "from" date first
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.grey)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                elevation: MaterialStateProperty.all(0.0),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              child: Text(_fromDate == null
                                  ? 'Select From Date'
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_fromDate!)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Add another TextButton for the "to" date selection.
                            TextButton(
                              onPressed: () {
                                _showDateTimePicker(context, isFromDate: false);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.grey)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                elevation: MaterialStateProperty.all(0.0),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              child: Text(_toDate == null
                                  ? 'Select To Date'
                                  : DateFormat('yyyy-MM-dd').format(_toDate!)),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            // TextButton(
                            //     onPressed: () {
                            //       _showDateTimePicker(context, isFromDate: true);
                            //     },
                            //     child: Text(DateTime.now().toString())),
                            Text(
                              "Total Orders: ${orderHistoryProvider.orderhistory?.length ?? 0}",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<MarketFeedSocket>(
                        builder: (context, marketFeedSocket, child) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount:
                              orderHistoryProvider.orderhistory?.length ?? 0,

                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Add this line
                          itemBuilder: (context, index) {
                            var orderhistory =
                                orderHistoryProvider.orderhistory?[index];

                            var orderAvglastTradedPrice =
                                orderhistory?.averagePrice ?? 'Default Value';
                            var exchangeSegment =
                                orderhistory?.exchangeSegment ??
                                    'Default Value';
                            var buySell =
                                orderhistory?.buySell ?? 'Default Value';
                            var TotalQty =
                                orderhistory?.totalQty ?? 'Default Value';
                            var validity =
                                orderhistory?.validity ?? 'Default Value';
                            DateTime dateTime =
                                DateTime.parse(orderhistory!.tradeTime);
                            String formattedDate =
                                DateFormat("dd-MMM-yyyy").format(dateTime);

                            // print(positionProvider.positions![index].exchangeInstrumentID);
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewmoreOrderHistory(
                                        orderValues: orderhistory,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 0.5,
                                          spreadRadius: 0.05,
                                          offset: Offset(0, 1))
                                    ],
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                orderhistory?.tradingSymbol ??
                                                    'Default Value',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              orderhistory?.status ??
                                                  'Default Value',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    buySell,
                                                    style: TextStyle(
                                                      color: orderhistory
                                                                  ?.buySell
                                                                  .toString() ==
                                                              'Buy'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(validity),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(exchangeSegment),
                                                ],
                                              ),
                                              Text(formattedDate.toString()),
                                            ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Qty: ${TotalQty}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(orderhistory.optionType),
                                              ],
                                            ),
                                            Text(
                                              "Avg: ${orderAvglastTradedPrice}",
                                              style: TextStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class OrderStorage {
  Future<void> saveOrderStatus(List<OrderSocketValues> orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        orders.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList('orders', jsonList);
  }

  Future<List<OrderSocketValues>> loadOrderStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('orders');
    if (jsonList != null) {
      return jsonList
          .map((json) => OrderSocketValues.fromJson(jsonDecode(json)))
          .toList();
    }
    return [];
  }
}

class OrderSocketScreen extends StatefulWidget {
  @override
  _OrderSocketScreenState createState() => _OrderSocketScreenState();
}

class _OrderSocketScreenState extends State<OrderSocketScreen> {
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(''),
        actions: [
          PopupMenuButton<OrderStatus>(
            onSelected: (OrderStatus result) {
              setState(() {
                _selectedStatus = result;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OrderStatus>>[
              const PopupMenuItem<OrderStatus>(
                value: OrderStatus.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem<OrderStatus>(
                value: OrderStatus.successful,
                child: Text('Successful'),
              ),
              const PopupMenuItem<OrderStatus>(
                value: OrderStatus.rejected,
                child: Text('Rejected'),
              ),
              const PopupMenuItem<OrderStatus>(
                value: OrderStatus.cancelled,
                child: Text('Cancelled'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<InteractiveSocketFeed>(
        builder: (context, interactiveSocketFeed, child) {
          return StreamBuilder<List<OrderSocketValues>>(
            stream: interactiveSocketFeed.dataListStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                List<OrderSocketValues> filteredList = snapshot.data!;
                if (_selectedStatus != null) {
                  filteredList = filteredList
                      .where((order) => order.orderStatus == _selectedStatus)
                      .toList();
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    OrderSocketValues data = filteredList[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data.boLegDetails),
                              Text(data.orderStatus.toString().split('.').last),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(data.exchangeInstrumentID),
                              Text(data.appOrderID),
                              Text(data.orderSide),
                              Text(data.orderType),
                              Text(data.productType),
                            ],
                          ),
                          trailing: Text(data.cumulativeQuantity.toString()),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
