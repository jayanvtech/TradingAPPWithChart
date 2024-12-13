import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/DrawerScreens/topgainers_model.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:tradingapp/DrawerScreens/topgainers_model.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_config.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/master/MasterServices.dart';

class EquityMarketScreen extends StatefulWidget {
  const EquityMarketScreen({super.key});

  @override
  State<EquityMarketScreen> createState() => _EquityMarketScreenState();
}

class _EquityMarketScreenState extends State<EquityMarketScreen> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    // TODO: implement dispose
    UnsubscribeData();

    super.dispose();
  }

  void UnsubscribeData() {
    for (var data in AppVariables.exchangeData) {
      ApiService().UnsubscribeMarketInstrument(
        ExchangeConverter().getExchangeSegmentNumber(data['exchangeSegment']!).toString(),
        data['exchangeInstrumentID']!,
      );
    }
    AppVariables.exchangeData.clear();
  }

  @override
  late final TabController _tabController = TabController(length: 4, vsync: this);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                Tab(text: 'Top Gainers'),
                Tab(text: 'Top Losers'),
                Tab(text: 'Most Active'),
                Tab(text: '52 Week High/Low'),
              ],
            ),
          ),
        ),
        title: CommonText(text: 'Equity Market'),
        backgroundColor: AppColors.primaryBackgroundColor,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [TopGainersFullScreen(), TopLoosersFullScreen(), MostBoughtFullScreen(), Week52HighNLowFullScreen()],
      ),
    );
  }
}

class TopGainersFullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: Column(
        children: [
          Consumer<TopGainersProvider>(
            builder: (context, stockProvider, child) {
              final Map<String, String> sectors = {
                'All Securities': 'allSec',
                'NIFTY': 'NIFTY',
                'BANK NIFTY': 'BANKNIFTY',
                'NIFTY NEXT 50': 'NIFTYNEXT50',
                'Securities < Rs 20': 'SecGtr20',
                'Securities > Rs 20': 'SecLwr20',
                'F&O Securities': 'FOSec',
              };

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: sectors.entries.map(
                    (entry) {
                      return CustomSelectionButton(
                        isSelected: stockProvider.selectedSector == entry.value,
                        text: entry.key,
                        onPressed: () {
                          stockProvider.setFilter(entry.value); // Update filter value
                        },
                      ).paddingSymmetric(horizontal: 5.0, vertical: 5.0);
                    },
                  ).toList(),
                ),
              );
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<TopGainersProvider>(context, listen: false).fetchStocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Skeletonizer(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: CommonText(text: 'title' * 2),
                            subtitle: CommonText(text: 'subtitle'),
                            trailing: CommonText(text: 'trailing'),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                }

                return Consumer<TopGainersProvider>(
                  builder: (context, stockProvider, child) {
                    final filteredStocks = stockProvider.filteredStocks;
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(height: 0, color: AppColors.greyColor300).paddingSymmetric(horizontal: 16),
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        final masterServices = DatabaseHelperMaster();

                        return FutureBuilder(
                          future: masterServices.getInstrumentsBySymbol(stock.symbol),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Skeletonizer(
                                  child: ListTile(
                                    title: CommonText(text: stock.symbol),
                                    subtitle: CommonText(text: "'LTP: ₹stockData.e}"),
                                    trailing: CommonText(
                                      text: '${stock.perChange}%',
                                      color: double.parse(stock.perChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                            }
                            // print(snapshot.data!['exchangeInstrumentID']);
                            if (snapshot.data != null) {
                              final exchangeInstrumentID = snapshot.data!['exchangeInstrumentID'];
                              final exchangeSegment = snapshot.data!['exchangeSegment'];
                              AppVariables.exchangeData.add({
                                'exchangeInstrumentID': exchangeInstrumentID,
                                'exchangeSegment': ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                              });
                              ApiService().MarketInstrumentSubscribe(
                                ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                exchangeInstrumentID,
                              );
                              AppVariables.topGainers.addAll({stock.symbol: exchangeInstrumentID});
                              void dispose() {
                                ApiService().UnsubscribeMarketInstrument(
                                  ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                  exchangeInstrumentID,
                                );
                                // Call the superclass dispose method if this is a StatefulWidget
                                // super.dispose();
                              }

                              // print(
                              //     'Exchange Instrument ID: $exchangeInstrumentID');
                              // print('Exchange Segment: $exchangeSegment');
                            } else {
                              print('No data found for the given symbol.');
                            }

                            return GestureDetector(
                              onTap: () {
                                // print('Tapped on ${stock.symbol}'
                                //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                //     ' and name: ${snapshot.data!['name']}'
                                //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewMoreInstrumentDetailScreen(
                                      exchangeInstrumentId: snapshot.data!['exchangeInstrumentID'],
                                      exchangeSegment: 1.toString(),
                                      lastTradedPrice: stock.ltp,
                                      close: stock.prevPrice,
                                      displayName: stock.symbol, // snapshot.data!['DisplayName'],
                                    ),
                                  ),
                                );
                              },
                              child: Consumer<MarketFeedSocket>(
                                builder: (context, data, child) {
                                  final marketData = data.getDataById(int.parse(snapshot.data?['exchangeInstrumentID'].toString() ?? ''));
                                  final priceChange = marketData != null ? double.parse(marketData.price) - double.parse(stock.prevPrice) : 0;
                                  final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;
                                  // log('marketData :: ${marketData}');
                                  // log('priceChange :: ${priceChange}');
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText(text: stock.symbol),
                                        CommonText(
                                          text: marketData != null ? '${marketData.price}' : '${stock.ltp}',
                                          color: double.parse(stock.perChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CommonText(text: "Low: ", color: AppColors.greyColor),
                                            CommonText(text: stock.lowPrice, color: AppColors.greyColor),
                                            SizedBox(width: 5),
                                            CommonText(text: "High: ", color: AppColors.greyColor),
                                            CommonText(text: stock.highPrice, color: AppColors.greyColor),
                                          ],
                                        ),
                                        CommonText(
                                          text: marketData != null
                                              ? '${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)'
                                              : '(${stock.perChange}%)',
                                          color: priceChangeColor,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
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
}

class TopGainersProvider with ChangeNotifier {
  List<TopGainersNLosers> _stocks = [];
  List<TopGainersNLosers> _filteredStocks = [];
  String _selectedSector = 'allSec'; // Default sector
  bool _isLoading = false;

  List<TopGainersNLosers> get stocks => _stocks;

  List<TopGainersNLosers> get filteredStocks => _filteredStocks;

  String get selectedSector => _selectedSector;

  bool get isLoading => _isLoading;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _stocks.clear(); // Clear the stocks list
    notifyListeners();

    final url = '${AppConfig.localVasu}/api/v1/all-stocks-performance/top-gainers-loosers?index=gainers';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _stocks = (data['data'] as List).map((item) => TopGainersNLosers.fromJson(item)).toList();
        filterStocks(); // Filter based on selected sector
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  void filterStocks() {
    // Filter stocks by the selected sector
    if (_selectedSector == 'allSec') {
      _filteredStocks = _stocks.where((stock) => stock.sector == 'allSec').toList();
    } else {
      _filteredStocks = _stocks.where((stock) => stock.sector == _selectedSector).toList();
    }
    notifyListeners();
  }

  // Set the selected sector and filter stocks accordingly
  void setFilter(String sector) {
    _selectedSector = sector;
    filterStocks();
  }

  Future<void> refreshStocks() async {
    _stocks.clear();
    await fetchStocks();
  }
}

class MostBoughtProvider with ChangeNotifier {
  List<MostBought> _stocks = [];
  List<MostBought> _filteredStocks = [];
  String _selectedSector = 'value'; // Default sector
  bool _isLoading = false;

  List<MostBought> get stocks => _stocks;

  List<MostBought> get filteredStocks => _filteredStocks;

  String get selectedSector => _selectedSector;

  bool get isLoading => _isLoading;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _stocks.clear(); // Clear the stocks list
    notifyListeners();

    final url = '${AppConfig.localVasu}/api/v1/all-stocks-performance/most-bought-sold?entity=mainboard';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _stocks = (data['data'] as List).map((item) => MostBought.fromJson(item)).toList();

        // Schedule the state modification after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          filterStocks(); // Filter based on selected sector
        });
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (e) {
      // Handle error
      _isLoading = false;
      notifyListeners();
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterStocks() {
    if (_selectedSector == 'value') {
      _filteredStocks = _stocks.where((stock) => stock.subCategory == 'value').toList();
    } else {
      _filteredStocks = _stocks.where((stock) => stock.subCategory == _selectedSector).toList();
    }
    notifyListeners();
  }

  // Set the selected sector and filter stocks accordingly
  void setFilter(String sector) {
    _selectedSector = sector;

    filterStocks();
  }

  Future<void> refreshStocks() async {
    _stocks.clear();
    await fetchStocks();
  }
}

class Week52HighLowProvider with ChangeNotifier {
  List<Week52HighLowModel> _stocks = [];
  List<Week52HighLowModel> _filteredStocks = [];
  String _selectedSector = 'high'; // Default sector
  bool _isLoading = false;

  List<Week52HighLowModel> get stocks => _stocks;

  List<Week52HighLowModel> get filteredStocks => _filteredStocks;

  String get selectedSector => _selectedSector;

  bool get isLoading => _isLoading;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _stocks.clear(); // Clear the stocks list
    notifyListeners();

    final url = '${AppConfig.localVasu}/api/v1/all-stocks-performance/last-52week?filter=all';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _stocks = (data['data'] as List).map((item) => Week52HighLowModel.fromJson(item)).toList();
        filterStocks(); // Filter based on selected sector
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  void filterStocks() {
    if (_selectedSector == 'high') {
      _filteredStocks = _stocks.where((stock) => stock.filter == 'high').toList();
    } else if (_selectedSector == 'low') {
      _filteredStocks = _stocks.where((stock) => stock.filter == 'low').toList();
    } else {
      _filteredStocks = _stocks;
    }
    notifyListeners();
  }

  // Set the selected sector and filter stocks accordingly
  void setFilter(String sector) {
    _selectedSector = sector;

    filterStocks();
  }

  Future<void> refreshStocks() async {
    _stocks.clear();
    await fetchStocks();
  }
}

class TopLoosersFullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => Provider.of<TopLoosersProvider>(context, listen: false).refreshStocks(),
        child: Column(
          children: [
            Consumer<TopLoosersProvider>(
              builder: (context, stockProvider, child) {
                final Map<String, String> sectors = {
                  'All Securities': 'allSec',
                  'NIFTY': 'NIFTY',
                  'BANK NIFTY': 'BANKNIFTY',
                  'NIFTY NEXT 50': 'NIFTYNEXT50',
                  'Securities < Rs 20': 'SecGtr20',
                  'Securities > Rs 20': 'SecLwr20',
                  'F&O Securities': 'FOSec',
                };

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sectors.entries.map(
                      (entry) {
                        return CustomSelectionButton(
                          isSelected: stockProvider.selectedSector == entry.value,
                          text: entry.key,
                          onPressed: () {
                            stockProvider.setFilter(entry.value); // Update filter value
                          },
                        ).paddingSymmetric(horizontal: 5, vertical: 5);
                      },
                    ).toList(),
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<TopLoosersProvider>(context, listen: false).fetchStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Skeletonizer(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: CommonText(text: 'title' * 2),
                              subtitle: CommonText(text: 'subtitle'),
                              trailing: CommonText(text: 'trailing'),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                  }

                  return Consumer<TopLoosersProvider>(
                    builder: (context, stockProvider, child) {
                      final filteredStocks = stockProvider.filteredStocks;
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(height: 0, color: AppColors.greyColor300).paddingSymmetric(horizontal: 16),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStocks[index];
                          final masterServices = DatabaseHelperMaster();
                          return FutureBuilder(
                            future: masterServices.getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Skeletonizer(
                                    child: ListTile(
                                      title: CommonText(text: stock.symbol),
                                      subtitle: CommonText(text: "'LTP: ₹stockData.e}"),
                                      trailing: CommonText(
                                        text: '${stock.perChange}%',
                                        color: double.parse(stock.perChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                              }
                              // print(snapshot.data!['exchangeInstrumentID']);
                              if (snapshot.data != null) {
                                final exchangeInstrumentID = snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment = snapshot.data!['exchangeSegment'];
                                AppVariables.exchangeData.add({
                                  'exchangeInstrumentID': exchangeInstrumentID,
                                  'exchangeSegment': ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                });
                                ApiService().MarketInstrumentSubscribe(
                                    ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(), exchangeInstrumentID);
                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(
                                onTap: () {
                                  // print('Tapped on ${stock.symbol}'
                                  //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                  //     ' and name: ${snapshot.data!['name']}'
                                  //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewMoreInstrumentDetailScreen(
                                        exchangeInstrumentId: snapshot.data!['exchangeInstrumentID'],
                                        exchangeSegment: 1.toString(),
                                        lastTradedPrice: stock.ltp,
                                        close: stock.prevPrice,
                                        displayName: stock.symbol, // snapshot.data!['DisplayName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                    final marketData = data.getDataById(int.parse(snapshot.data!['exchangeInstrumentID'].toString()));
                                    final priceChange = marketData != null ? double.parse(marketData.price) - double.parse(stock.prevPrice) : 0;
                                    final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(text: stock.symbol),
                                          CommonText(
                                            text: marketData != null ? '${marketData.price}' : '${stock.ltp}',
                                            color: double.parse(stock.perChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                          )
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CommonText(text: "Low: ", color: AppColors.greyColor),
                                              CommonText(text: stock.lowPrice, color: AppColors.greyColor),
                                              SizedBox(width: 5),
                                              CommonText(text: "High: ", color: AppColors.greyColor),
                                              CommonText(text: stock.highPrice, color: AppColors.greyColor),
                                            ],
                                          ),
                                          CommonText(
                                            text: marketData != null
                                                ? '${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)'
                                                : '(${stock.perChange}%)',
                                            color: priceChangeColor,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopLoosersProvider with ChangeNotifier {
  List<TopGainersNLosers> _stocks = [];
  List<TopGainersNLosers> _filteredStocks = [];
  String _selectedSector = 'allSec'; // Default sector
  bool _isLoading = false;

  List<TopGainersNLosers> get stocks => _stocks;

  List<TopGainersNLosers> get filteredStocks => _filteredStocks;

  String get selectedSector => _selectedSector;

  bool get isLoading => _isLoading;

  Future<void> fetchStocks() async {
    _isLoading = true;
    _stocks.clear(); // Clear the stocks list
    notifyListeners();

    final url = '${AppConfig.localVasu}/api/v1/all-stocks-performance/top-gainers-loosers?index=loosers';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _stocks = (data['data'] as List).map((item) => TopGainersNLosers.fromJson(item)).toList();
        filterStocks(); // Filter based on selected sector
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  void filterStocks() {
    // Filter stocks by the selected sector
    if (_selectedSector == 'allSec') {
      _filteredStocks = _stocks.where((stock) => stock.sector == 'allSec').toList();
    } else {
      _filteredStocks = _stocks.where((stock) => stock.sector == _selectedSector).toList();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set the selected sector and filter stocks accordingly
  void setFilter(String sector) {
    _selectedSector = sector;
    filterStocks();
  }

  Future<void> refreshStocks() async {
    _stocks.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    await fetchStocks();
  }
}

class MostBoughtFullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => Provider.of<MostBoughtProvider>(context, listen: false).refreshStocks(),
        child: Column(
          children: [
            Consumer<MostBoughtProvider>(
              builder: (context, stockProvider, child) {
                final Map<String, String> sectors = {
                  'Volume': 'volume',
                  'Value': 'value',
                };

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: sectors.entries.map(
                      (entry) {
                        return CustomSelectionButton(
                          isSelected: stockProvider.selectedSector == entry.value,
                          text: entry.key,
                          onPressed: () {
                            stockProvider.setFilter(entry.value); // Update filter value
                          },
                        ).paddingSymmetric(horizontal: 5.0, vertical: 5.0);
                      },
                    ).toList(),
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<MostBoughtProvider>(context, listen: false).fetchStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Skeletonizer(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: CommonText(text: 'title'),
                              subtitle: CommonText(text: 'subtitle'),
                              trailing: CommonText(text: 'trailing'),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                  }

                  return Consumer<MostBoughtProvider>(
                    builder: (context, stockProvider, child) {
                      final filteredStocks = stockProvider.filteredStocks;

                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(height: 0, color: AppColors.greyColor300).paddingSymmetric(horizontal: 16),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStocks[index];
                          final masterServices = DatabaseHelperMaster();

                          return FutureBuilder(
                            future: masterServices.getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Skeletonizer(
                                    child: ListTile(
                                      title: CommonText(text: stock.symbol),
                                      subtitle: CommonText(text: "'LTP: ₹stockData.e}"),
                                      trailing: CommonText(
                                        text: '${stock.createdAt}%',
                                        color: double.parse(stock.change) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                              }
                              // print(snapshot.data!['exchangeInstrumentID']);
                              if (snapshot.data != null) {
                                final exchangeInstrumentID = snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment = snapshot.data!['exchangeSegment'];
                                AppVariables.exchangeData.add({
                                  'exchangeInstrumentID': exchangeInstrumentID,
                                  'exchangeSegment': ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                });
                                ApiService().MarketInstrumentSubscribe(
                                  ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                  exchangeInstrumentID,
                                );
                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(
                                onTap: () {
                                  // print('Tapped on ${stock.symbol}'
                                  //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                  //     ' and name: ${snapshot.data!['name']}'
                                  //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewMoreInstrumentDetailScreen(
                                        exchangeInstrumentId: snapshot.data!['exchangeInstrumentID'],
                                        exchangeSegment: 1.toString(),
                                        lastTradedPrice: stock.lastPrice,
                                        close: stock.closePrice,
                                        displayName: stock.symbol, // snapshot.data!['DisplayName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                    final marketData = data.getDataById(int.parse(snapshot.data!['exchangeInstrumentID'].toString()));
                                    final priceChange = marketData != null ? double.parse(marketData.price) - double.parse((marketData.close)) : 0;
                                    final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;

                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(text: stock.symbol),
                                          CommonText(
                                            text: marketData != null ? '${marketData.price}' : '${stock.lastPrice}',
                                            color: double.parse(stock.pChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                          )
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  CommonText(text: "Low: ", color: AppColors.greyColor),
                                                  CommonText(text: stock.dayLow, color: AppColors.greyColor),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              Row(
                                                children: [
                                                  CommonText(text: "High: ", color: AppColors.greyColor),
                                                  CommonText(text: stock.dayHigh, color: AppColors.greyColor),
                                                ],
                                              ),
                                            ],
                                          ),
                                          CommonText(
                                            text: marketData != null
                                                ? '${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)'
                                                : '(${double.parse(stock.pChange).toStringAsFixed(2)}%)',
                                            color: priceChangeColor,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Week52HighNLowFullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Week52HighLowProvider>(context, listen: false).refreshStocks(),
        child: Column(
          children: [
            Consumer<Week52HighLowProvider>(
              builder: (context, stockProvider, child) {
                final Map<String, String> sectors = {
                  'High': 'high',
                  'Low': 'low',
                };

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: sectors.entries.map(
                      (entry) {
                        return CustomSelectionButton(
                          isSelected: stockProvider.selectedSector == entry.value,
                          text: entry.key,
                          onPressed: () {
                            stockProvider.setFilter(entry.value); // Update filter value
                          },
                        ).paddingSymmetric(horizontal: 5.0, vertical: 5.0);
                      },
                    ).toList(),
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Week52HighLowProvider>(context, listen: false).fetchStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Skeletonizer(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: CommonText(text: 'title'),
                              subtitle: CommonText(text: 'subtitle'),
                              trailing: CommonText(text: 'trailing'),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                  }

                  return Consumer<Week52HighLowProvider>(
                    builder: (context, stockProvider, child) {
                      final filteredStocks = stockProvider.filteredStocks;

                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(height: 0, color: AppColors.greyColor300).paddingSymmetric(horizontal: 16),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStocks[index];
                          final masterServices = DatabaseHelperMaster();

                          return FutureBuilder(
                            future: masterServices.getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Skeletonizer(
                                    child: ListTile(
                                      title: CommonText(text: stock.symbol),
                                      subtitle: CommonText(text: "'LTP: ₹stockData.e}"),
                                      trailing: CommonText(
                                        text: '${stock.createdAt}%',
                                        color: double.parse(stock.change) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                              }
                              // print(snapshot.data!['exchangeInstrumentID']);
                              if (snapshot.data != null) {
                                final exchangeInstrumentID = snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment = snapshot.data!['exchangeSegment'];
                                AppVariables.exchangeData.add({
                                  'exchangeInstrumentID': exchangeInstrumentID,
                                  'exchangeSegment': ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                });
                                log('exchangeInstrumentID :: ${exchangeInstrumentID}');
                                ApiService().MarketInstrumentSubscribe(
                                  ExchangeConverter().getExchangeSegmentNumber(exchangeSegment).toString(),
                                  exchangeInstrumentID,
                                );
                                log('exchangeInstrumentID :: ${exchangeInstrumentID}');
                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(
                                onTap: () {
                                  // print('Tapped on ${stock.symbol}'
                                  //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                  //     ' and name: ${snapshot.data!['name']}'
                                  //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewMoreInstrumentDetailScreen(
                                        exchangeInstrumentId: snapshot.data!['exchangeInstrumentID'],
                                        exchangeSegment: 1.toString(),
                                        lastTradedPrice: stock.ltp,
                                        close: stock.prevClose,
                                        displayName: stock.symbol, // snapshot.data!['DisplayName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                    final marketData = data.getDataById(int.parse(snapshot.data!['exchangeInstrumentID'].toString()));
                                    final priceChange = marketData != null ? double.parse(marketData.price) - double.parse(stock.prevClose) : 0;
                                    final priceChangeColor = priceChange > 0 ? AppColors.GreenColor : AppColors.RedColor;
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(text: stock.symbol),
                                          CommonText(
                                            text: marketData != null ? '${marketData.price}' : '${stock.ltp}',
                                            color: double.parse(stock.pChange) >= 0 ? AppColors.GreenColor : AppColors.RedColor,
                                          )
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CommonText(text: "Low: ", color: AppColors.greyColor),
                                              CommonText(text: stock.prev52WHL, color: AppColors.greyColor),
                                              SizedBox(width: 5),
                                              CommonText(text: "High: ", color: AppColors.greyColor),
                                              CommonText(text: stock.new52WHL, color: AppColors.greyColor),
                                            ],
                                          ),
                                          CommonText(
                                            text: marketData != null
                                                ? '${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)'
                                                : '(${double.parse(stock.pChange).toStringAsFixed(2)}%)',
                                            color: priceChangeColor,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
