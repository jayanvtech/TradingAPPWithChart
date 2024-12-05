import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/DrawerScreens/equity_market_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/master/MasterServices.dart';

class TopGainersTop4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<TopGainersProvider>(
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
                    children: sectors.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                    color: stockProvider.selectedSector ==
                                            entry.value
                                        ? Colors.blue
                                        : Colors.grey[300]!,
                                  )),
                              foregroundColor:
                                  stockProvider.selectedSector == entry.value
                                      ? Colors.blue
                                      : Colors.grey,
                              backgroundColor:
                                  stockProvider.selectedSector == entry.value
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.white!,
                              elevation: 0.0,
                              shadowColor: Colors.transparent),
                          onPressed: () { HapticFeedback.mediumImpact(
            
           );
                            stockProvider.setFilter(entry.value);
                          },
                          child: Text(entry.key),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<TopGainersProvider>(context, listen: false)
                  .fetchStocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Center(
                          child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () { HapticFeedback.mediumImpact(
            
           );
                                    // Get.to(
                                    //     () => ProfileScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text("mostBought"),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("mostBought"),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Consumer<TopGainersProvider>(
                  builder: (context, stockProvider, child) {
                    final filteredStocks = stockProvider.filteredStocks
                        .take(4)
                        .toList(); // Take only the top 4 elements
                    return GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 120,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        final masterServices = DatabaseHelperMaster();

                        return FutureBuilder(
                            future: masterServices
                                .getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Skeletonizer(
                                  child: ListTile(
                                    title: Text(stock.symbol),
                                    subtitle: Text("'LTP: ₹stockData.e}"),
                                    trailing: Text(
                                      '${double.parse(stock.perChange).toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        color:
                                            double.parse(stock.perChange) >= 0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data != null) {
                                final exchangeInstrumentID =
                                    snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment =
                                    snapshot.data!['exchangeSegment'];
                                ApiService().MarketInstrumentSubscribe(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID);
                                void dispose() {
                                  ApiService().UnsubscribeMarketInstrument(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID,
                                  );
                                }

                                // print(
                                // //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(onTap: () { HapticFeedback.mediumImpact(
            
           );
                                // print('Tapped on ${stock.symbol}'
                                //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                //     ' and name: ${snapshot.data!['name']}'
                                //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewMoreInstrumentDetailScreen(
                                      exchangeInstrumentId: snapshot
                                          .data!['exchangeInstrumentID'],
                                      exchangeSegment: 1.toString(),
                                      lastTradedPrice: stock.ltp,
                                      close: stock.prevPrice,
                                      displayName: stock.symbol,
                                    ),
                                  ),
                                );
                              }, child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                final marketData = data.getDataById(int.parse(
                                    snapshot.data!['exchangeInstrumentID']
                                        .toString()));
                                final priceChange = marketData != null
                                    ? double.parse(marketData.price) -
                                        double.parse(stock.prevPrice)
                                    : 0;
                                final priceChangeColor =
                                    priceChange > 0 ? Colors.green : Colors.red;
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: CircleAvatar(
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  "https://ekyc.arhamshare.com/img//trading_app_logos//${stock.symbol}.svg",
                                                  fit: BoxFit.fill,
                                                  height: 50,
                                                  semanticsLabel: 'Network SVG',
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                          Text(
                                            stock.symbol.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              marketData != null
                                                  ? marketData.price
                                                  : stock.ltp.toString(),
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    marketData != null
                                                        ? priceChange
                                                            .toStringAsFixed(2)
                                                        : "0",
                                                    style: TextStyle(
                                                        color:
                                                            priceChangeColor)),
                                                Text(
                                                  '(${marketData != null ? marketData.percentChange : double.parse(stock.perChange).toStringAsFixed(2)}%)',
                                                  style: TextStyle(
                                                      color: priceChangeColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                            });
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

class TopLoosersTop4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<TopLoosersProvider>(
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
                    children: sectors.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                    color: stockProvider.selectedSector ==
                                            entry.value
                                        ? Colors.blue
                                        : Colors.grey[300]!,
                                  )),
                              foregroundColor:
                                  stockProvider.selectedSector == entry.value
                                      ? Colors.blue
                                      : Colors.grey,
                              backgroundColor:
                                  stockProvider.selectedSector == entry.value
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.white!,
                              elevation: 0.0,
                              shadowColor: Colors.transparent),
                          onPressed: () { HapticFeedback.heavyImpact(
            
           );
                            stockProvider.setFilter(entry.value);
                          },
                          child: Text(entry.key),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<TopLoosersProvider>(context, listen: false)
                  .fetchStocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Center(
                          child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () { HapticFeedback.mediumImpact(
            
           );
                                    // Get.to(
                                    //     () => ProfileScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text("mostBought"),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("mostBought"),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Consumer<TopLoosersProvider>(
                  builder: (context, stockProvider, child) {
                    final filteredStocks = stockProvider.filteredStocks
                        .take(4)
                        .toList(); // Take only the top 4 elements
                    return GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 120,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        final masterServices = DatabaseHelperMaster();

                        return FutureBuilder(
                            future: masterServices
                                .getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Skeletonizer(
                                  child: ListTile(
                                    title: Text(stock.symbol),
                                    subtitle: Text("'LTP: ₹stockData.e}"),
                                    trailing: Text(
                                      '${double.parse(stock.perChange).toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        color:
                                            double.parse(stock.perChange) >= 0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data != null) {
                                final exchangeInstrumentID =
                                    snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment =
                                    snapshot.data!['exchangeSegment'];
                                ApiService().MarketInstrumentSubscribe(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID);
                                void dispose() {
                                  ApiService().UnsubscribeMarketInstrument(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID,
                                  );
                                }

                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(onTap: () { HapticFeedback.mediumImpact(
            
           );
                                // print('Tapped on ${stock.symbol}'
                                //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                //     ' and name: ${snapshot.data!['name']}'
                                //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewMoreInstrumentDetailScreen(
                                      exchangeInstrumentId: snapshot
                                          .data!['exchangeInstrumentID'],
                                      exchangeSegment: 1.toString(),
                                      lastTradedPrice: stock.ltp,
                                      close: stock.prevPrice,
                                      displayName: stock.symbol,
                                    ),
                                  ),
                                );
                              }, child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                final marketData = data.getDataById(int.parse(
                                    snapshot.data!['exchangeInstrumentID']
                                        .toString()));
                                final priceChange = marketData != null
                                    ? double.parse(marketData.price) -
                                        double.parse(stock.prevPrice)
                                    : 0;
                                final priceChangeColor =
                                    priceChange > 0 ? Colors.green : Colors.red;
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: CircleAvatar(
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  placeholderBuilder: (BuildContext
                                                          context) =>
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30.0),
                                                          child:
                                                              const CircularProgressIndicator()),
                                                  "https://ekyc.arhamshare.com/img//trading_app_logos//${stock.symbol}.svg",
                                                  fit: BoxFit.fill,
                                                  height: 50,
                                                  semanticsLabel: 'Network SVG',
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                          Text(
                                            stock.symbol.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              marketData != null
                                                  ? marketData.price
                                                  : stock.ltp.toString(),
                                              style: TextStyle(
                                                color: priceChangeColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    marketData != null
                                                        ? priceChange
                                                            .toStringAsFixed(2)
                                                        : "0",
                                                    style: TextStyle(
                                                        color:
                                                            priceChangeColor)),
                                                Text(
                                                  ' (${marketData != null ? marketData.percentChange : double.parse(stock.perChange).toStringAsFixed(2)}%)',
                                                  style: TextStyle(
                                                      color: priceChangeColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                            });
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

class MostBoughtTop4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<MostBoughtProvider>(
              builder: (context, stockProvider, child) {
                final Map<String, String> sectors = {
                  'volume': 'volume',
                  'value': 'value',
                };
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: sectors.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: stockProvider.selectedSector ==
                                              entry.value
                                          ? Colors.blue
                                          : Colors.grey[300]!,
                                    )),
                                foregroundColor:
                                    stockProvider.selectedSector == entry.value
                                        ? Colors.blue
                                        : Colors.grey,
                                backgroundColor:
                                    stockProvider.selectedSector == entry.value
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.white!,
                                elevation: 0.0,
                                shadowColor: Colors.transparent),
                            onPressed: () {HapticFeedback.heavyImpact(
            
           );
                              stockProvider.setFilter(entry.value);
                            },
                            child: Text(entry.key),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<MostBoughtProvider>(context, listen: false)
                  .fetchStocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () { HapticFeedback.mediumImpact(
            
           );
                                    // Get.to(
                                    //     () => ProfileScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text("mostBought"),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("mostBought"),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Consumer<MostBoughtProvider>(
                  builder: (context, stockProvider, child) {
                    final filteredStocks = stockProvider.filteredStocks
                        .take(4)
                        .toList(); // Take only the top 4 elements
                    return GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 120,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        final masterServices = DatabaseHelperMaster();

                        return FutureBuilder(
                            future: masterServices
                                .getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) { 
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Skeletonizer(
                                  child: ListTile(
                                    title: Text(stock.symbol),
                                    subtitle: Text("'LTP:₹stockD}"),
                                    trailing: Text(
                                      '${stock.lastPrice}%',
                                      style: TextStyle(
                                        color: double.parse(stock.pChange) >= 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data != null) {
                                final exchangeInstrumentID =
                                    snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment =
                                    snapshot.data!['exchangeSegment'];
                                ApiService().MarketInstrumentSubscribe(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID);
                             

                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(onTap: () { HapticFeedback.mediumImpact(
            
           );
                                print("=========================================================${snapshot
                                          .data!['exchangeInstrumentID']}");
                                print('Tapped on ${stock.symbol}'
                                    ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                    ' and name: ${snapshot.data!['name']}'
                                    ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewMoreInstrumentDetailScreen(
                                      exchangeInstrumentId: snapshot
                                          .data!['exchangeInstrumentID'],
                                      exchangeSegment: 1.toString(),
                                      lastTradedPrice: stock.lastPrice,
                                      close: stock.previousClose,
                                      displayName: stock.symbol,
                                    ),
                                  ),
                                );
                              }, child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                final marketData = data.getDataById(int.parse(
                                    snapshot.data!['exchangeInstrumentID']
                                        .toString()));
                                final priceChange = marketData != null
                                    ? double.parse(marketData.price) -
                                        double.parse(stock.previousClose)
                                    : 0;
                                final priceChangeColor =
                                    priceChange > 0 ? Colors.green : Colors.red;
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: CircleAvatar(
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  

                                                  "https://ekyc.arhamshare.com/img//trading_app_logos//${stock.symbol}.svg",
                                                  fit: BoxFit.fill,
                                                  height: 50,
                                                  semanticsLabel: 'Network SVG',

                                                  // errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                  //   return Icon(Icons.error, size: 50);
                                                  // },
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                          Text(
                                            stock.symbol.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              marketData != null
                                                  ? marketData.price
                                                  : stock.lastPrice.toString(),
                                              style: TextStyle(
                                                color: priceChangeColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    marketData != null
                                                        ? priceChange
                                                            .toStringAsFixed(2)
                                                        : "0",
                                                    style: TextStyle(
                                                        color:
                                                            priceChangeColor)),
                                                Text(
                                                  ' (${marketData != null ? marketData.percentChange : double.parse(stock.pChange).toStringAsFixed(2)}%)',
                                                  style: TextStyle(
                                                      color: priceChangeColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                            });
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

class Week52HighNLowTop4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<Week52HighLowProvider>(
              builder: (context, stockProvider, child) {
                final Map<String, String> sectors = {
                  '52 Week High': 'high',
                  '52 Week Low': 'low',
                };
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: sectors.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: stockProvider.selectedSector ==
                                              entry.value
                                          ? Colors.blue
                                          : Colors.grey[300]!,
                                    )),
                                foregroundColor:
                                    stockProvider.selectedSector == entry.value
                                        ? Colors.blue
                                        : Colors.grey,
                                backgroundColor:
                                    stockProvider.selectedSector == entry.value
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.white!,
                                elevation: 0.0,
                                shadowColor: Colors.transparent),
                            onPressed: () {HapticFeedback.heavyImpact(
            
           );
                              stockProvider.setFilter(entry.value);
                            },
                            child: Text(entry.key),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Week52HighLowProvider>(context, listen: false)
                  .fetchStocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Center(
                          child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () { HapticFeedback.mediumImpact(
            
           );
                                    // Get.to(
                                    //     () => ProfileScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text("mostBought"),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("mostBought"),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Consumer<Week52HighLowProvider>(
                  builder: (context, stockProvider, child) {
                    final filteredStocks = stockProvider.filteredStocks
                        .take(4)
                        .toList(); // Take only the top 4 elements
                    return GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 120,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        final masterServices = DatabaseHelperMaster();

                        return FutureBuilder(
                            future: masterServices
                                .getInstrumentsBySymbol(stock.symbol),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Skeletonizer(
                                  child: ListTile(
                                    title: Text(stock.symbol),
                                    subtitle: Text("'LTP: ₹stockData.e}"),
                                    trailing: Text(
                                      '${stock.ltp}%',
                                      style: TextStyle(
                                        color: double.parse(stock.pChange) >= 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.data != null) {
                                final exchangeInstrumentID =
                                    snapshot.data!['exchangeInstrumentID'];
                                final exchangeSegment =
                                    snapshot.data!['exchangeSegment'];
                                ApiService().MarketInstrumentSubscribe(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID);
                                void dispose() {
                                  ApiService().UnsubscribeMarketInstrument(
                                    ExchangeConverter()
                                        .getExchangeSegmentNumber(
                                            exchangeSegment)
                                        .toString(),
                                    exchangeInstrumentID,
                                  );
                                }

                                // print(
                                //     'Exchange Instrument ID: $exchangeInstrumentID');
                                // print('Exchange Segment: $exchangeSegment');
                              } else {
                                print('No data found for the given symbol.');
                              }

                              return GestureDetector(onTap: () { HapticFeedback.mediumImpact(
            
           );
                                // print('Tapped on ${stock.symbol}'
                                //     ' with exchangeInstrumentID: ${snapshot.data!['exchangeInstrumentID']}'
                                //     ' and name: ${snapshot.data!['name']}'
                                //     ' and exchangeSegment: ${snapshot.data!['exchangeSegment']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewMoreInstrumentDetailScreen(
                                      exchangeInstrumentId: snapshot
                                          .data!['exchangeInstrumentID'],
                                      exchangeSegment: 1.toString(),
                                      lastTradedPrice: stock.ltp,
                                      close: stock.prevClose,
                                      displayName: stock.symbol,
                                    ),
                                  ),
                                );
                              }, child: Consumer<MarketFeedSocket>(
                                  builder: (context, data, child) {
                                final marketData = data.getDataById(int.parse(
                                    snapshot.data!['exchangeInstrumentID']
                                        .toString()));
                                final priceChange = marketData != null
                                    ? double.parse(marketData.price) -
                                        double.parse(stock.prevClose)
                                    : 0;
                                final priceChangeColor =
                                    priceChange > 0 ? Colors.green : Colors.red;
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: CircleAvatar(
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  "https://ekyc.arhamshare.com/img//trading_app_logos//${stock.symbol}.svg",
                                                  fit: BoxFit.fill,
                                                  height: 50,
                                                  semanticsLabel: 'Network SVG',
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                          Text(
                                            stock.symbol.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              marketData != null
                                                  ? marketData.price
                                                  : stock.ltp.toString(),
                                              style: TextStyle(
                                                color: priceChangeColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    marketData != null
                                                        ? priceChange
                                                            .toStringAsFixed(2)
                                                        : "0",
                                                    style: TextStyle(
                                                        color:
                                                            priceChangeColor)),
                                                Text(
                                                  ' (${marketData != null ? marketData.percentChange : double.parse(stock.pChange).toStringAsFixed(2)}%)',
                                                  style: TextStyle(
                                                      color: priceChangeColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                            });
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
