import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/WishListInstrumentDetailScreen/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';

import 'package:tradingapp/model/option_chain_model.dart';

class OptionChainService {
  final String apiUrl =
      'https://mtrade.arhamshare.com/apimarketdata/search/instruments?searchString=';

  Future<List<OptionChain>> fetchOptionChain(String searchString) async {
    try {
      String? token = await getToken();
      final response = await http.get(Uri.parse('$apiUrl$searchString'),
          headers: {'Content-Type': 'application', 'Authorization': '$token'});

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['result'];
        List<OptionChain> optionChains =
            data.map((item) => OptionChain.fromJson(item)).toList();
        optionChains = optionChains.where((item) {
          String contractExpirationString =
              item.ContractExpirationString!.toUpperCase();
          String newContractExpirationString = contractExpirationString
              .substring(0, contractExpirationString.length - 4);

          String variable =
              item.name!.toUpperCase() + ' ' + newContractExpirationString;

          return item.displayName!.contains("$variable");
        }).toList();

        return optionChains;
      } else {
        throw Exception('Failed to load option chain data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load option chain: $e');
    }
  }

  Future<List<String>> fetchExpirationDates(String searchString) async {
    try {
      String? token = await getToken();
      final response = await http.get(Uri.parse('$apiUrl$searchString'),
          headers: {'Content-Type': 'application', 'Authorization': '$token'});

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['result'];
        List<OptionChain> optionChains =
            data.map((item) => OptionChain.fromJson(item)).toList();

        Set<String> expirationDates =
            optionChains.map((item) => item.ContractExpirationString!).toSet();

        // Filter the dates to only include those that match the format
        final RegExp format =
            RegExp(r'^\d{2}[a-z]{3}\d{4}$', caseSensitive: false);
        expirationDates =
            expirationDates.where((date) => format.hasMatch(date)).toSet();

        print(expirationDates.toList());
        return expirationDates.toList();
      } else {
        throw Exception('Failed to load expiration dates');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load expiration dates: $e');
    }
  }
}

class OptionChainScreen extends StatefulWidget {
  final String displayName;
  final String lastTradedPrice;
  final String exchangeSegment;
  final String exchangeInstrumentID;

  OptionChainScreen({
    required this.displayName,
    required this.lastTradedPrice,
    required this.exchangeSegment,
    required this.exchangeInstrumentID,
  });

  @override
  _OptionChainScreenState createState() => _OptionChainScreenState();
}

class _OptionChainScreenState extends State<OptionChainScreen> {
  final OptionChainService service = OptionChainService();
  late Future<List<OptionChain>> futureOptionChain;
  late Future<List<String>> futureExpirationDates;

  String? selectedDate;
  List<OptionChain> allOptions = [];
  List<OptionChain> filteredOptions = [];

  Set<String> subscribedInstrumentIDs = Set();

  @override
  void initState() {
    super.initState();
    //MarketFeedSocket marketFeedSocket = Provider.of<MarketFeedSocket>(context, listen: false);

    futureOptionChain = service.fetchOptionChain(widget.displayName);
    futureExpirationDates = service.fetchExpirationDates(widget.displayName);

    futureOptionChain.then((options) {
      setState(() {
        allOptions = options;
        filteredOptions = options;
      });
    });

    futureExpirationDates.then((dates) {
      if (dates.isNotEmpty) {
        setState(() {
          selectedDate = dates[0];
          filteredOptions = allOptions
              .where(
                  (option) => option.ContractExpirationString == selectedDate)
              .toList();
        });
      }
    });
  }

  void filterOptionsByDate(String date) {
    setState(() {
      selectedDate = date;
      filteredOptions = allOptions
          .where((option) => option.ContractExpirationString == date)
          .toList();
    });
  }

  List<OptionChain> getNearestOptions(List<OptionChain> optionChain) {
    optionChain.sort((a, b) {
      final diffA =
          (double.parse(a.strikePrice!) - double.parse(widget.lastTradedPrice))
              .abs();
      final diffB =
          (double.parse(b.strikePrice!) - double.parse(widget.lastTradedPrice))
              .abs();
      return diffA.compareTo(diffB);
    });

    return optionChain
        .take(40)
        .toList(); // Take the nearest 20 options to sort further
  }

  List<OptionChain> sortOptions(List<OptionChain> nearestOptions) {
    List<OptionChain> lessThanLastTraded = [];
    List<OptionChain> greaterThanOrEqualLastTraded = [];

    nearestOptions.forEach((option) {
      if (double.parse(option.strikePrice!) <
          double.parse(widget.lastTradedPrice)) {
        lessThanLastTraded.add(option);
      } else {
        greaterThanOrEqualLastTraded.add(option);
      }
    });

    lessThanLastTraded.sort((a, b) =>
        double.parse(b.strikePrice!).compareTo(double.parse(a.strikePrice!)));
    greaterThanOrEqualLastTraded.sort((a, b) =>
        double.parse(a.strikePrice!).compareTo(double.parse(b.strikePrice!)));

    return [...lessThanLastTraded.reversed, ...greaterThanOrEqualLastTraded];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: TextStyle(fontSize: 14),
                ),
                Consumer(builder:
                    (context, MarketFeedSocket marketFeedSocket, child) {
                  final marketData = marketFeedSocket
                      .getDataById(int.parse(widget.exchangeInstrumentID));
                  return Row(
                    children: [
                      Text(
                        marketData != null
                            ? marketData.price.toString()
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          color: marketData != null
                              ? double.parse(marketData.price) >
                                      double.parse(marketData.close)
                                  ? Colors.green
                                  : double.parse(marketData.price) <
                                          double.parse(marketData.close)
                                      ? Colors.red
                                      : Colors.black
                              : Colors.black,
                        ),
                      ),
                      Text(
                        "(${marketData != null ? marketData.percentChange.toString() : 'N/A'})",
                        style: TextStyle(
                          fontSize: 14,
                          color: marketData != null
                              ? double.parse(marketData.price) >
                                      double.parse(marketData.close)
                                  ? Colors.green
                                  : double.parse(marketData.price) <
                                          double.parse(marketData.close)
                                      ? Colors.red
                                      : Colors.black
                              : Colors.black,
                        ),
                      )
                    ],
                  );
                }),
              ],
            ),
        CupertinoButton(
  child: Row(
    children: [
      Text(
        selectedDate ?? 'Select Date',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(
        width: 10,
      ),
      Icon(
        CupertinoIcons.calendar,
        size: 17,
      ),
    ],
  ),
  onPressed: () {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<String>>(
          future: futureExpirationDates,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CupertinoActionSheet(
                title: Text('Select Date'),
                actions: snapshot.data!.map((date) {
                  return CupertinoActionSheetAction(
                    child: Text(date),
                    onPressed: () {
                      setState(() {
                        selectedDate = date;
                      });
                      filterOptionsByDate(date);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Failed to load expiration dates"));
            }
            return Container(); // return an empty container if none of the above conditions are met
          },
        );
      },
    );
  },
),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<OptionChain>>(
              future: futureOptionChain,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<OptionChain>? optionChain = filteredOptions;
                  optionChain.removeWhere((item) =>
                      item.strikePrice == "null" || item.strikePrice == '0');

                  final nearestOptions = getNearestOptions(optionChain);
                  final sortedOptions = sortOptions(nearestOptions);

                  final groupedOptions = groupBy<OptionChain, String>(
                    sortedOptions,
                    (option) => option.strikePrice!,
                  ).values.toList();
                  if (optionChain.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                height: 200,
                                width: 200,
                                'assets/error_illustrations/chain_error.svg',
                              ),
                            ],
                          ),
                          Text(
                            "Oh NO!",
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            "No Option Chain Found for this Quote",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    );
                  }
                  // Insert a pseudo-item for the last traded price in the middle
                  // final middleIndex = (groupedOptions.length / 2).ceil();
                  // groupedOptions.insert(middleIndex, []);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Call",
                                          textAlign: TextAlign.left)),
                                  Expanded(
                                      child: Text("Strike Price",
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                      child: Text("PUT",
                                          textAlign: TextAlign.right)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<MarketFeedSocket>(
                                builder: (context, marketFeedSocket, child) {
                                  return Container(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: Colors.grey[100]!.withOpacity(1),
                                      ),
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: groupedOptions.length,
                                      itemBuilder: (context, index) {
                                        print(
                                            "==============${groupedOptions.length}");

                                        // if (index == middleIndex) {
                                        //   return ListTile(
                                        //     title: Center(
                                        //       child: Text(
                                        //         " ${marketFeedSocket.getDataById(int.parse(widget.exchangeInstrumentID))?.price.toString()} (${marketFeedSocket.getDataById(int.parse(widget.exchangeInstrumentID))?.percentChange.toString()})",
                                        //         style: TextStyle(
                                        //             fontWeight: FontWeight.bold,
                                        //             color: Colors.red),
                                        //       ),
                                        //     ),
                                        //   );
                                        // }{

                                        final optionGroup =
                                            groupedOptions[index];
                                        final hasCallOption = optionGroup.any(
                                            (option) =>
                                                option.optionType == '3');
                                        final hasPutOption = optionGroup.any(
                                            (option) =>
                                                option.optionType == '4');

                                        // Subscribe to the market data for both call and put options
                                        optionGroup.forEach((option) {
                                          if (option.exchangeInstrumentID !=
                                                  null &&
                                              !subscribedInstrumentIDs.contains(
                                                  option
                                                      .exchangeInstrumentID!)) {
                                            subscribedInstrumentIDs.add(
                                                option.exchangeInstrumentID!);
                                            ApiService()
                                                .MarketInstrumentSubscribe(
                                                    option.exchangeSegment!,
                                                    option
                                                        .exchangeInstrumentID!);
                                            print(
                                                'Subscribed to ${option.exchangeInstrumentID}');
                                          }
                                        });
                                        final marketdatacall = hasCallOption
                                            ? marketFeedSocket.getDataById(
                                                int.parse(optionGroup
                                                        .firstWhere((option) =>
                                                            option.optionType ==
                                                            '3')
                                                        .exchangeInstrumentID ??
                                                    "0"))
                                            : null;
                                        final marketdataput = hasPutOption
                                            ? marketFeedSocket.getDataById(
                                                int.parse(optionGroup
                                                        .firstWhere((option) =>
                                                            option.optionType ==
                                                            '4')
                                                        .exchangeInstrumentID ??
                                                    "0"))
                                            : null;
                                        final pricechangecall =
                                            marketdatacall != null
                                                ? double.parse(
                                                        marketdatacall.price) -
                                                    double.parse(
                                                        marketdatacall.close)
                                                : 0;

                                        final pricechangeput =
                                            marketdataput != null
                                                ? double.parse(
                                                        marketdataput.price) -
                                                    double.parse(
                                                        marketdataput.close)
                                                : 0;
                                        // Determine the color for the call option price
                                        Color getPriceColor(double livePrice,
                                            double closePrice) {
                                          if (livePrice > closePrice) {
                                            return Colors.green;
                                          } else if (livePrice < closePrice) {
                                            return Colors.red;
                                          } else if (livePrice == "0") {
                                            return Colors.black;
                                          } else {
                                            return Colors.black;
                                          }
                                        }

                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Call Option Column
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ViewMoreInstrumentDetailScreen(
                                                              exchangeInstrumentId:
                                                                  optionGroup.firstWhere((option) => option.optionType == '3').exchangeInstrumentID ??
                                                                      "000000",
                                                              exchangeSegment:
                                                                  optionGroup.firstWhere((option) => option.optionType == '3').exchangeSegment ??
                                                                      "00000",
                                                              lastTradedPrice:
                                                                  marketdatacall
                                                                          ?.price
                                                                          .toString() ??
                                                                      "N/A",
                                                              close: marketdataput
                                                                      ?.close
                                                                      .toString() ??
                                                                  "N/A",
                                                              displayName: optionGroup
                                                                      .firstWhere((option) =>
                                                                          option.optionType == '3')
                                                                      .companyName ??
                                                                  ""),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 5, 10, 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (hasCallOption) ...[
                                                            Text(
                                                              (marketdatacall?.price) ==
                                                                      0
                                                                  ? marketdatacall
                                                                          ?.close
                                                                          .toString() ??
                                                                      ""
                                                                  : marketdatacall
                                                                          ?.price
                                                                          .toString() ??
                                                                      "",
                                                              style: TextStyle(
                                                                color: marketdatacall !=
                                                                        null
                                                                    ? getPriceColor(
                                                                        double.parse(marketdatacall.price.toString()),
                                                                        double.parse(marketdatacall.close.toString()))
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${pricechangecall.toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                color: marketdatacall !=
                                                                        null
                                                                    ? getPriceColor(
                                                                        double.parse(marketdatacall.price.toString()),
                                                                        double.parse(marketdatacall.close.toString()))
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Strike Price Column
                                                Expanded(
                                                  child: Center(
                                                    child: Container(
                                                        child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Text(
                                                        optionGroup
                                                            .first.strikePrice!,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                                // Put Option Column
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ViewMoreInstrumentDetailScreen(
                                                              exchangeInstrumentId: optionGroup
                                                                  .firstWhere((option) =>
                                                                      option.optionType ==
                                                                      '4')
                                                                  .exchangeInstrumentID!,
                                                              exchangeSegment: optionGroup
                                                                  .firstWhere(
                                                                      (option) =>
                                                                          option.optionType ==
                                                                          '4')
                                                                  .exchangeSegment!,
                                                              lastTradedPrice:
                                                                  marketdatacall
                                                                          ?.price
                                                                          .toString() ??
                                                                      "N/A",
                                                              close: marketdataput
                                                                      ?.close
                                                                      .toString() ??
                                                                  "N/A",
                                                              displayName: optionGroup
                                                                  .firstWhere(
                                                                      (option) => option.optionType == '4')
                                                                  .companyName!),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 5, 10, 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (hasPutOption) ...[
                                                            Text(
                                                              "${pricechangeput.toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                color: marketdataput !=
                                                                        null
                                                                    ? getPriceColor(
                                                                        double.parse(marketdataput.price.toString()),
                                                                        double.parse(marketdataput.close.toString()))
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              marketdataput
                                                                      ?.price
                                                                      .toString() ??
                                                                  "N/A",
                                                            )
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load option chain'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
