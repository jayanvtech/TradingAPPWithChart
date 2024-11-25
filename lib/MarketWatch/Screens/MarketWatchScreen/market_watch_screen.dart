import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tradingapp/Charts/chart.dart';
import 'package:tradingapp/DashBoard/Screens/option_chain_screen/option_chain_screen.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/DashBoard/Screens/BuyOrSellScreen/buy_sell_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/InstrumentDetailScreen/instrument_details_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/SearchScreen/search_screen.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/MarketWatch/Screens/WishListInstrumentDetailScreen/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/sqlite_database/dbhelper.dart';
import 'package:tradingapp/master/nscm_database.dart';
import 'package:tradingapp/master/nscm_provider.dart';

class MarketWatchScreen extends StatefulWidget {
  @override
  _MarketWatchScreenState createState() => _MarketWatchScreenState();
}

class _MarketWatchScreenState extends State<MarketWatchScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  List<Map<String, dynamic>> _watchlistItems = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _watchlistItems.length, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    initializeDatabase();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initializeDatabase();
    }
  }

  Future<void> initializeDatabase() async {
    _watchlistItems = await DatabaseHelper.instance.fetchWatchlists();
    setState(() {
      _tabController =
          TabController(length: _watchlistItems.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController = TabController(length: _watchlistItems.length, vsync: this);
    // TODO: implement di
    // spose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<MarketFeedSocket>(builder: (context, feed, child) {
    //   return feed.bankmarketData.isEmpty
    //       ? Center(child: CircularProgressIndicator())
    return Scaffold(
      drawer: DrawerDashboard1(),
      endDrawer: DrawerDashboard2(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    onReturn: () => initializeDatabase(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.read_more),
            ),
          ),
        ],
        title: Text('Watchlist'),
        bottom: _tabController != null
            ? PreferredSize(
                preferredSize: Size.fromHeight(110),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: GestureDetector(
                            onDoubleTap: () async {},
                            child: TabBar(
                              dividerHeight: 3,
                              labelPadding: EdgeInsets.all(2),
                              padding: EdgeInsets.all(5),
                              tabAlignment: TabAlignment.start,
                              dividerColor: Colors.white,
                              controller: _tabController,
                              isScrollable: true,
                              tabs: _watchlistItems.map((item) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Delete'),
                                              onTap: () {
                                                _dbHelper
                                                    .deleteWatchlist(
                                                        _watchlistItems[
                                                                _tabController
                                                                    .index]
                                                            ['id'] as int)
                                                    .then((value) =>
                                                        initializeDatabase())
                                                    .catchError((error) =>
                                                        print(error));
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Delete'),
                                              onTap: () {
                                                // Handle delete
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                78, 128, 145, 177),
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Tab(
                                      height: 35,
                                      child: Text(
                                        item['name'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // text: item['name'].toString(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.88,
                          child: IconButton(
                            onPressed: () async {
                              String? itemName = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddWatchlistDialog();
                                },
                              );
                              initializeDatabase();

                              if (itemName != null) {
                                await DatabaseHelper.instance
                                    .addWatchlist(itemName);
                                initializeDatabase();
                                setState(() {
                                  // _tabController =
                                });
                              }
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    Consumer<MarketFeedSocket>(builder: (context, feed, child) {
                      return feed.bankmarketData.isEmpty
                          ? Skeletonizer(
                              enabled: true,
                              child: Container(
                                height: 80,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(5),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.white,
                                          ),
                                          // semanticContainer: true,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(10)),
                                          // borderOnForeground: true,
                                          // shadowColor: Colors.white,

                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'name',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        'price'.toString(),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "565",
                                                          ),
                                                          Text(
                                                            'percentage'
                                                                .toString(),
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
                                  },
                                ),
                              ),
                            )
                          : MarketDataWidget(feed.bankmarketData);
                    }),
                  ],
                ),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(),
              ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _watchlistItems
            .map(
              (item) => WatchlistTab(
                watchlistId: item['id'] as int,
              ),
            )
            .toList(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => SearchScreen(
      //           onReturn: () => initializeDatabase(),
      //         ),
      //       ),
      //     );
      //     // String? itemName = await showDialog(
      //     //   context: context,
      //     //   builder: (BuildContext context) {
      //     //     return AddWatchlistDialog();
      //     //   },
      //     // );
      //     // initializeDatabase();

      //     // if (itemName != null) {
      //     //   await DatabaseHelper.instance.addWatchlist(itemName);
      //     //   initializeDatabase();
      //     // }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class WatchlistTab extends StatefulWidget {
  final int watchlistId;

  const WatchlistTab({required this.watchlistId});

  @override
  _WatchlistTabState createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<WatchlistTab>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>> _instruments = [];
  String close = "";
  late Timer _timer;
  bool _isReordering = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
// void dispose() {
//     String exchangeSegments = _instruments.map((e) => e['exchangeSegment'].toString()).join(',');
//   String exchangeInstrumentIds = _instruments.map((e) => e['exchange_instrument_id'].toString()).join(',');
//     // Call your function here
//   ApiService().UnsubscribeMarketInstrument(exchangeSegments.toString(), exchangeInstrumentIds.toString());

//     super.dispose();
//   }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    fetchInstruments();
    SubscribedmarketData();

    DatabaseHelper.instance.updateAllCloseValues();
    _timer =
        Timer.periodic(Duration(seconds: 4), (timer) => fetchInstruments());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchInstruments();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    UnSubscribedmarketData();
    super.dispose();
  }

  @override
  void didUpdateWidget(WatchlistTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchInstruments();
  }

  Future<void> SubscribedmarketData() async {
    //final marketSocket = Provider.of<MarketFeedSocket>(context);
    final instruments = await DatabaseHelper.instance
        .fetchInstrumentsByWatchlist(widget.watchlistId);
    _instruments = List<Map<String, dynamic>>.from(instruments);
    for (var instrument in _instruments) {
      final exchangeInstrumentID =
          instrument['exchange_instrument_id'] as String;
      final exchangeSegment = instrument['exchangeSegment'].toString();

      ApiService().MarketInstrumentSubscribe(
          exchangeSegment.toString(), exchangeInstrumentID.toString());
    }
  }

  Future<void> UnSubscribedmarketData() async {
    //final marketSocket = Provider.of<MarketFeedSocket>(context);
    final instruments = await DatabaseHelper.instance
        .fetchInstrumentsByWatchlist(widget.watchlistId);
    _instruments = List<Map<String, dynamic>>.from(instruments);
    for (var instrument in _instruments) {
      final exchangeInstrumentID =
          instrument['exchange_instrument_id'] as String;
      final exchangeSegment = instrument['exchangeSegment'].toString();

      ApiService().UnsubscribeMarketInstrument(
          exchangeSegment.toString(), exchangeInstrumentID.toString());
    }
  }

  Future<void> fetchInstruments() async {
    final instruments = await DatabaseHelper.instance
        .fetchInstrumentsByWatchlist(widget.watchlistId);
    if (_instruments.length != instruments.length) {
      SubscribedmarketData();
    }

    if (mounted) {
      // Check if the widget is still in the tree
      setState(() {
        _instruments = List<Map<String, dynamic>>.from(instruments);
      });
    }
  }

  // Stream<String> streamInstrumentDetails(
  //     String exchangeInstrumentID, String ExchangeSegment) async* {
  //   while (true) {
  //     final instrumentDetails =
  //         await fetchInstrumentDetails(exchangeInstrumentID, ExchangeSegment);
  //     yield jsonEncode(instrumentDetails);
  //   }
  // }

  Future<List<String>> fetchAllCloseValues(
      List<Map<String, dynamic>> instruments) async {
    var closeValues = <String>[];
    for (var instrument in instruments) {
      var token = instrument['exchange_instrument_id'];
      var closeValue = await NscmDatabase().getCloseValue(token);
      closeValues.add(closeValue);
    }
    return closeValues;
  }

  String getExchangeSegmentName(int exchangeSegment) {
    switch (exchangeSegment) {
      case 1:
        return 'NSECM';
      case 2:
        return 'NSEFO';
      case 3:
        return 'NSECD';
      case 11:
        return 'BSECM';
      case 12:
        return 'BSEFO';
      case 13:
        return 'BSECD';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onDoubleTap: () async {
          showModalBottomSheet(

            context: context,
            builder: (context) {
              
              return Container(
                child: ReorderableListView.builder(
                  
                  itemCount: _instruments.length,
                  itemBuilder: (context, index) {
                    final instrument = _instruments[index];
                    return ListTile(
                      key: ValueKey(instrument['id']),
                      title: Text(instrument['display_name']),
                      leading: Icon(Icons.drag_handle),
                      subtitle: Text(instrument['exchangeSegment'].toString()),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Map<String, dynamic> item =
                          _instruments.removeAt(oldIndex);
                      _instruments.insert(newIndex, item);
                      _dbHelper.updateOrderIndex(item['id'], newIndex);
                    });
                  },
                ),
              );
            },
          );
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 20,
            color: Colors.grey.withOpacity(0.00),
          ),
          itemCount: _instruments.length,
          itemBuilder: (context, index) {
            final instrument = _instruments[index];
            final exchangeInstrumentID =
                instrument['exchange_instrument_id'] as String;

            final exchangeSegment = instrument['exchangeSegment'].toString();
            final displayName = instrument['display_name'] as String;
            final companyName = instrument['CompanyName'].toString();
            List<String> parts =
                displayName.split(" "); // Split at the first space

            String part1 = parts[0].toString(); // BANKNIFTY
            //String part2 = parts[1].toString(); // 21AUG2024 PE 61200
            final closevalue1 = instrument['close'].toString();
            return Consumer<MarketFeedSocket>(
              builder: (context, data, child) {
                final marketData =
                    data.getDataById(int.parse(exchangeInstrumentID));
                final priceChange = marketData != null
                    ? double.parse(marketData.price) - double.parse(closevalue1)
                    : 0;
                final priceChangeColor =
                    priceChange > 0 ? Colors.green : Colors.red;
                if (marketData != null) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => InstrumentDetailsScreen(

                      //     ),
                      //   ),
                      // );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BuySellScreen(
                      //       exchangeInstrumentId: exchangeInstrumentID,exchangeSegment: exchangeSegment,lastTradedPrice: marketData.price, close: closevalue1,displayName: displayName,
                      //     ),
                      //   ),
                      // );
                      showCupertinoModalBottomSheet(
                        animationCurve: Curves.fastEaseInToSlowEaseOut,
                        isDismissible: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        backgroundColor: Color.fromARGB(255, 242, 242, 242),
                        context: context,
                        // isScrollControlled: true,
                        builder: (context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Consumer<MarketFeedSocket>(
                                builder: (context, data, child) {
                                  final marketData = data.getDataById(
                                      int.parse(exchangeInstrumentID));
                                  final priceChange = marketData != null
                                      ? double.parse(marketData.price) -
                                          double.parse(closevalue1)
                                      : 0;
                                  final priceChangeColor = priceChange > 0
                                      ? Colors.green
                                      : Colors.red;
                                  String part1 = displayName;
                                  String displayname1 = part1.split(" ")[
                                      0]; // This splits the string by space and takes the first element
                                  if (marketData != null) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.85,
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        exchangeSegment == "1"
                                                            ? Text(displayName,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18))
                                                            : Text(displayname1,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    exchangeSegment == "1"
                                                        ? Text(
                                                            getExchangeSegmentName(
                                                                int.parse(
                                                                    exchangeSegment)),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : Text(displayName,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12)),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "₹${marketData.price.toString()}",
                                                          style: TextStyle(
                                                              color:
                                                                  priceChangeColor,
                                                              fontSize: 18),
                                                        ),
                                                        Icon(
                                                          priceChange > 0
                                                              ? Icons
                                                                  .arrow_drop_up
                                                              : Icons
                                                                  .arrow_drop_down,
                                                          color:
                                                              priceChangeColor,
                                                          size: 30,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          priceChange
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          "(${marketData.percentChange.toString()}%)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "OPEN",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          Text(marketData.Open),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "HIGH",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          Text(marketData.High),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "LOW",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          Text(marketData.Low),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "PREV. CLOSE",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          Text(marketData.close
                                                              .toString()),
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
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text('QTY',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black87,
                                                                      )),
                                                                  Text(
                                                                      'BUY PRICE',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black87,
                                                                          fontWeight:
                                                                              FontWeight.normal)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'BUY PRICE',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black87,
                                                                      )),
                                                                  Text('QTY',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black87,
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            height: 200,
                                                            width: 180,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  marketData
                                                                      .bids
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                var bid =
                                                                    marketData
                                                                            .bids[
                                                                        index];
                                                                return Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '${bid.size}'),
                                                                      Text(
                                                                        '${bid.price}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green),
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
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    marketData
                                                                        .asks
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  var asks =
                                                                      marketData
                                                                              .asks[
                                                                          index];
                                                                  return Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              '${asks.price}',
                                                                              style: TextStyle(color: Colors.red)),
                                                                          Text(
                                                                              '${asks.size}'),
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
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(marketData
                                                                .totalBuyQuantity),
                                                            Text(
                                                                "TOTAL QUANTITY"),
                                                            Text(marketData
                                                                .totalSellQuantity)
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
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OptionChainScreen(
                                                                          displayName:
                                                                              displayName,
                                                                          lastTradedPrice:
                                                                              marketData.price,
                                                                          exchangeInstrumentID:
                                                                              exchangeInstrumentID,
                                                                          exchangeSegment:
                                                                              exchangeSegment,
                                                                        )));
                                                      },
                                                      child:
                                                          Text("Option Chain")),
                                                ),
                                                VerticalDivider(),
                                                TextButton(
                                                    onPressed: () {
                                                     Get.to(() => ChartingFromTV(displayName));
                                                    },
                                                    child: Text("Charts")),
                                                VerticalDivider(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewMoreInstrumentDetailScreen(
                                                            exchangeInstrumentId:
                                                                exchangeInstrumentID,
                                                            exchangeSegment:
                                                                exchangeSegment,
                                                            lastTradedPrice:
                                                                marketData
                                                                    .price,
                                                            close: closevalue1,
                                                            displayName:
                                                                displayName,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        Text("Stock Details"))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 60,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.off(() =>
                                                          BuySellScreen(
                                                            exchangeInstrumentId:
                                                                exchangeInstrumentID,
                                                            exchangeSegment:
                                                                exchangeSegment,
                                                            lastTradedPrice:
                                                                marketData
                                                                    .price,
                                                            close: closevalue1,
                                                            displayName:
                                                                displayName,
                                                            isBuy: true,
                                                            lotSize: "1",
                                                          ));

                                                      // Navigator.pop(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         BuySellScreen(
                                                      //       exchangeInstrumentId:
                                                      //           exchangeInstrumentID,
                                                      //       exchangeSegment:
                                                      //           exchangeSegment,
                                                      //       lastTradedPrice:
                                                      //           marketData
                                                      //               .price,
                                                      //       close: closevalue1,
                                                      //       displayName:
                                                      //           displayName,
                                                      //       isBuy: true,
                                                      //       lotSize: "1",
                                                      //     ),
                                                      //   ),
                                                      // );
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.green,
                                                      ),
                                                      child: Center(
                                                          child: Text("BUY",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18))),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.off(() => BuySellScreen(
                                                          exchangeInstrumentId:
                                                              exchangeInstrumentID,
                                                          exchangeSegment:
                                                              exchangeSegment,
                                                          lastTradedPrice:
                                                              marketData.price,
                                                          close: closevalue1,
                                                          displayName:
                                                              displayName,
                                                          isBuy: false,
                                                          lotSize: "1"));
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) => BuySellScreen(
                                                      //         exchangeInstrumentId:
                                                      //             exchangeInstrumentID,
                                                      //         exchangeSegment:
                                                      //             exchangeSegment,
                                                      //         lastTradedPrice:
                                                      //             marketData
                                                      //                 .price,
                                                      //         close:
                                                      //             closevalue1,
                                                      //         displayName:
                                                      //             displayName,
                                                      //         isBuy: false,
                                                      //         lotSize: "1"),
                                                      //   ),
                                                      // );
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red,
                                                      ),
                                                      child: Center(
                                                          child: Text("SELL",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    onLongPress: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => Material(
                          type: MaterialType.card,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.9,
                            
                            child: ReorderableListView.builder(
                              itemCount: _instruments.length,
                              itemBuilder: (context, index) {
                                final instrument = _instruments[index];
                                return ListTile(
                                  key: ValueKey(instrument['id']),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(instrument['display_name']),
                                      IconButton(
                                        onPressed: () {
                                          _dbHelper
                                              .deleteInstrumentByExchangeInstrumentId(
                                                  widget.watchlistId,
                                                  exchangeInstrumentID);
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(CupertinoIcons.delete),
                                      ),
                                    ],
                                  ),
                                  leading:
                                      Icon(CupertinoIcons.line_horizontal_3),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final Map<String, dynamic> item =
                                      _instruments.removeAt(oldIndex);
                                  _instruments.insert(newIndex, item);
                                  _dbHelper.updateOrderIndex(
                                      item['id'], newIndex);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Skeletonizer(
                        enabled: marketData == null,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(displayName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          // fontSize: 14,
                                          color: Colors.black54)),
                                  Row(
                                    children: [
                                      Text(
                                        "${marketData.price.toString()}",
                                        style: TextStyle(
                                            color: priceChangeColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        priceChange > 0
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: priceChangeColor,
                                        size: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // exchangeSegment == "2"
                                      //     ? Text(
                                      //         '$part1 - ',
                                      //         style: TextStyle(
                                      //             fontSize: 10,
                                      //             fontWeight: FontWeight.w100,
                                      //             color: Colors.black54),
                                      //       )
                                      //     : Text(
                                      //         '$part1 - ',
                                      //         style: TextStyle(
                                      //             fontSize: 11,
                                      //             color: Colors.black54),
                                      //       ),
                                      Text(
                                        getExchangeSegmentName(int.parse(
                                          exchangeSegment,
                                        )),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(priceChange.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      Text(" (${marketData.percentChange}%)",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Skeletonizer(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("displayName",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(221, 60, 60, 60))),
                                Row(
                                  children: [
                                    Text(
                                      "shdsb",
                                      style: TextStyle(
                                          color: priceChangeColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_up,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // exchangeSegment == "2"
                                    //     ? Text(
                                    //         '$part1 - ',
                                    //         style: TextStyle(
                                    //             fontSize: 10,
                                    //             fontWeight: FontWeight.w100,
                                    //             color: Colors.black54),
                                    //       )
                                    //     : Text(
                                    //         '$part1 - ',
                                    //         style: TextStyle(
                                    //             fontSize: 11,
                                    //             color: Colors.black54),
                                    //       ),
                                    Text(
                                      "getExchangeS",
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black54),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("priceChange",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12)),
                                    Text("priceChange",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class AddWatchlistDialog extends StatefulWidget {
  @override
  _AddWatchlistDialogState createState() => _AddWatchlistDialogState();
}

class _AddWatchlistDialogState extends State<AddWatchlistDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white),
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create New Watchlist",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autofocus: true,
                  controller: _controller,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    hintText: 'Enter Watchlist Name',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      icon: Icon(Icons.delete_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, do something
                        Navigator.of(context).pop(_controller.text.trim());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchScreen(), // Replace this with your SearchScreen
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Create',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
