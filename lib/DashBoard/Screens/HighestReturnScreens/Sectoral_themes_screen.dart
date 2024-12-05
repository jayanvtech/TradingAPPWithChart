import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/DashBoard/Screens/HighestReturnScreens/Model/sector_theme_model.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/const.dart/app_config.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/master/MasterServices.dart';

import '../../../MarketWatch/Screens/wishlist_instrument_details_screen.dart';

class SectoralThemesScreen extends StatefulWidget {
  @override
  _SectoralThemesScreenState createState() => _SectoralThemesScreenState();
}

class _SectoralThemesScreenState extends State<SectoralThemesScreen> {
  final Map<String, String> sectorTitles = {
    "bank": "Banks",
    "fmcg": "FMCG",
    "engineering": "Engineering",
    "finance": "Finance",
    "pharms": "Pharmaceuticals",
    "cement": "Cement",
    "it": "IT",
    "refineries": "Refineries",
    "chemicals": "Chemicals",
    "automobile": "Automobile",
    "power": "Power"
  };

  String? selectedSector = "Banks";

  @override
  void dispose() {
    // TODO: implement dispose
    UnsubscribeData();

    super.dispose();
  }

  void UnsubscribeData() {
    for (var data in AppVariables.exchangeData) {
      ApiService().UnsubscribeMarketInstrument(
        ExchangeConverter()
            .getExchangeSegmentNumber(data['exchangeSegment']!)
            .toString(),
        data['exchangeInstrumentID']!,
      );
    }
    AppVariables.exchangeData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Sectoral Themes'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sectorTitles.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSector = entry.key;
                      });
                    },
                    child: Text(entry.value),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: selectedSector == entry.value
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      foregroundColor: selectedSector == entry.key
                          ? Colors.blue
                          : Colors.grey,
                      backgroundColor: selectedSector == entry.key
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SectorThemeModel>>(
              future: ApiService().fetchSectorStock(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No data available'));
                } else {
                  final allSectors = snapshot.data!;
                  final filteredSectors = selectedSector == null
                      ? allSectors
                      : allSectors
                          .where((stock) => stock.sector == selectedSector)
                          .toList();

                  return ListView.builder(
                    itemCount: filteredSectors.length,
                    itemBuilder: (context, index) {
                      var stock = filteredSectors[index];
                      final masterServices = DatabaseHelperMaster();
                      return FutureBuilder(
                          future:
                              masterServices.getInstrumentsBySymbol(stock.sym),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Skeletonizer(
                                child: ListTile(
                                  title: Text(stock.sym),
                                  subtitle: Text("'LTP: ₹stockData.e}"),
                                  trailing: Text(
                                    '(s9)}%',
                                    style: TextStyle(
                                      color: double.parse(stock.pPerchange
                                                  .toString()) >=
                                              0
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
                              AppVariables.exchangeData.add({
                                'exchangeInstrumentID': exchangeInstrumentID,
                                'exchangeSegment': ExchangeConverter()
                                    .getExchangeSegmentNumber(exchangeSegment)
                                    .toString(),
                              });
                              ApiService().MarketInstrumentSubscribe(
                                  ExchangeConverter()
                                      .getExchangeSegmentNumber(exchangeSegment)
                                      .toString(),
                                  exchangeInstrumentID);
                              print(AppVariables.exchangeData);
                            } else {
                              print('No data found for the given symbol.');
                            }

                            return Consumer<MarketFeedSocket>(
                              builder: (context, data, child) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: Skeletonizer(
                                    child: ListTile(
                                      title: Text(stock.sym),
                                      subtitle: Text("'LTP: ₹stockData.e}"),
                                      trailing: Text(
                                        '(s9)}%',
                                        style: TextStyle(
                                          color: double.parse(stock.pPerchange
                                                      .toString()) >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                                void UnsubscribeData() {
                                  ApiService().UnsubscribeMarketInstrument(
                                      ExchangeConverter()
                                          .getExchangeSegmentNumber(
                                              snapshot.data!['exchangeSegment'])
                                          .toString(),
                                      snapshot.data!['exchangeInstrumentID']);
                                }

                                final marketData = data.getDataById(int.parse(
                                    snapshot.data!['exchangeInstrumentID']
                                        .toString()));

                                final priceChange = marketData != null
                                    ? double.parse(marketData.price) -
                                        double.parse(
                                            marketData.close.toString())
                                    : 0;
                                final priceChangeColor =
                                    priceChange > 0 ? Colors.green : Colors.red;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewMoreInstrumentDetailScreen(
                                          exchangeInstrumentId: snapshot
                                              .data!['exchangeInstrumentID'],
                                          exchangeSegment: 1.toString(),
                                          lastTradedPrice: stock.ltp.toString(),
                                          close: marketData!.close.toString(),
                                          displayName: stock
                                              .sym, // snapshot.data!['DisplayName'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(stock.sym),
                                        Text(
                                          marketData != null
                                              ? '${marketData.price}'
                                              : '${stock.ltp}',
                                          style: TextStyle(
                                            color: double.parse(stock.pPerchange
                                                        .toString()) >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "1 YLow: ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  stock.low1Yr.toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "1 High: ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  stock.high1Yr.toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                            marketData != null
                                                ? '${priceChange.toStringAsFixed(2)}(${marketData.percentChange}%)'
                                                : '(${double.parse(stock.pchange.toString()).toStringAsFixed(2)}%)',
                                            style: TextStyle(
                                              color: priceChangeColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
