// ignore_for_file: unused_import, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/Position/Models/TradeOrderModel/tradeOrder_model.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/ordersocketvalues_model.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late IO.Socket socket;
  String position = 'No data received yet';
  double? lastTradedPrice;
  double? percentChange;
  @override
  void initState() {
    super.initState();
    interactiveSocket();
    //initSocket();
    // interactiveSocket();

    //
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokend = prefs.getString('token');
    print('Tokens: $tokend');
    return tokend!;
  }

  Future<String> setupSocket() async {
    String? token = await getToken();
    if (token != null) {
      return token;
    } else {
      return 'Token not found';
    }
  }

//   void initSocket() async {
//     String token = await getToken();

//     String url1 =
//         'http://14.97.72.10:3000/?token=$token&userID=A0031&publishFormat=JSON&broadcastMode=Full&apiType=APIMARKETDATA';
//     socket = IO.io(
//         url1,
// //token=$token&apiType=INTERACTIVE&userID=A0031
//         IO.OptionBuilder()
//             .setTransports(['websocket']) // for Flutter or Dart VM
//             .setQuery({
//               'token': token,
//               'userID': 'A0031',
//               //  'apiType': 'MARKETDATA',
//               'publishFormat': 'JSON',
//               'broadcastMode': 'Full',
//             })
//             .setPath('/apimarketdata/socket.io')
//             // .enableAutoConnect() // disable auto-connection
//             .build());
//     socket.onConnect((data) {
//       print('Is connected MarketData ${socket.connected} & $data');

//       socket.on('connect', (data) {
//         print('Connected MarketData : $data');
//       });

//       socket.on('joined', (joined) {
//         setState(() {
//           position = joined;
//         });
//         print('joined marketdata:  $joined');
//       });
//       socket.on('1502-json-full', (data) {
//         print('position $data');
//         setState(() {
//           final datas = jsonDecode(data);

//           print("7777777777777777777777777777777777$datas");
//           lastTradedPrice = datas['Touchline']['LastTradedPrice'];
//           percentChange = datas['percentChange'];
//         });
//       });
//       socket.on("event", (data) => print(data));
//       socket.on('success', (data) {
//         print('success $data');
//       });
//     });

//     // socket.on('1501-json-full', (data) {
//     //   print('1502 $data');
//     // });
//     socket.on('disconnect', (error) {
//       print('Disconnected from socket ttiiiiiiii $error');
//     });

//     socket.on('message', (data) {
//       print(data);
//     });
//     socket.onConnectError((data) => print(data));
//     socket.emit('my event', 'Hello, Server!');
//     socket.on('my response', (data) {
//       print(data);
//     });
//     socket.onDisconnect((_) => print('Disconnected'));
//     socket.on('disconect', (data) => print(data));
//     socket.on('connect_error', (data) => print("Error connecterror :$data"));
//     socket.on('connect_timeout', (data) => print("Timeout$data"));
//     socket.on('error', (data) => print("erorr:;:$data"));
//     socket.onConnecting(
//       (data) => print('Connecting$data'),
//     );

//     socket.onConnectError((data) {
//       print('sss$data');
//     });
//     print(socket.connected.toString());
//   }

  void interactiveSocket() async {
    String token = await getToken();
    String url = "http://14.97.72.10:3000/";
    socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setQuery({
              'token': token,
              'apiType': 'INTERACTIVE',
              'publishFormat': 'JSON',
              'broadcastMode': 'Full',
              'userID': 'A0031'
            })
            .setPath('/interactive/socket.io')
            // .enableAutoConnect() // disable auto-connection
            .build());
    socket.onConnect((data) {
      print('hkj+$data');
      print('Is connected INTERACTIVE: ${socket.connected}');

      socket.on('connect', (data) {
        print('Connected INTERACTIVE $data');
      });

      socket.on('joined', (joined) {
        setState(() {
          position = joined;
        });
        print('joined:INTERACTIVE $joined');
      });
      socket.on('order', (data) {
        print('position $data');
      });
      socket.on('1502-json-full', (data) {
        print('position $data');
      });
      socket.on("event", (data) => print(data));
      socket.on('success INTERACTIVE', (data) {
        print('success $data');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    lastTradedPrice = lastTradedPrice ?? 0.0;
    String getTokend = getToken().toString();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  // Get.to(() => BuySellScreen(

                  // ));
                },
                icon: Icon(Icons.sort_by_alpha_outlined))
          ],
          title: const Text('Market'),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<String>(
                future:
                    getToken() as Future<String>, // your Future function here
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return Text(
                          'Token: $lastTradedPrice $percentChange'); // snapshot.data  <-- here, you have access to your data
                  }
                },
              ),
            ),
            MarketDataWidget(),
            IndividualMarketDataWidget(
              instrumentId: 26000,
            ),
            IndividualMarketDataWidget(
              instrumentId: 13611,
            ),
          ],
        ));
  }
}

class IndividualMarketDataWidget extends StatelessWidget {
  final int instrumentId;

  IndividualMarketDataWidget({required this.instrumentId});

  @override
  Widget build(BuildContext context) {
    final marketSocket = Provider.of<MarketFeedSocket>(context);

    return Column(
      children: <Widget>[
        Text('Data for Instrument ID: $instrumentId'),
        Consumer<MarketFeedSocket>(
          builder: (context, data, child) {
            final marketData = data.getDataById(instrumentId);
            //print(marketData);

            if (marketData != null) {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("displayName",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                            Row(
                              children: [
                                Text(
                                  '${marketData.price}'.toString(),
                                  // style: TextStyle(color: priceChangeColor),
                                ),
                                Icon(
                                  marketData.percentChange
                                          .toString()
                                          .contains('-')
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  // color: priceChangeColor,
                                  size: 12,
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Exchange Segment:"
                                    // style: TextStyle(
                                    //     fontSize: 12,
                                    //     fontWeight: FontWeight.w500),
                                    ),
                                // Text(
                                //   getExchangeSegmentName(
                                //       int.parse(exchangeSegment)),
                                //   style: TextStyle(fontSize: 12),
                                // )
                              ],
                            ),
                            Row(
                              children: [
                                // Text(priceChange.toStringAsFixed(2),
                                //     style:
                                //         TextStyle(color: priceChangeColor)),
                                // Text(
                                //   "(${percentChange.toStringAsFixed(2)}%)",
                                //   style: TextStyle(color: priceChangeColor),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text('Last Traded Price: ${marketData.price}'),
                  Text('Percent Change: ${marketData.percentChange}'),
                  Text('Timestamp: ${marketData.close}'),
                ],
              );
            }
            return Text('No data available for this ID.');
          },
        ),
      ],
    );
  }
}

class MarketDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final marketSocket = Provider.of<MarketFeedSocket>(context);

    return StreamBuilder<MarketData>(
      stream: marketSocket.marketDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Text('Last Traded Price: ${snapshot.data!.price}'),
                Text('Percent Change: ${snapshot.data!.percentChange}'),
                Text(
                    'Exchange Instrument ID: ${snapshot.data!.close}'), // Assuming timestamp is used for this
                Text(
                    'Exchange Segment: PLACEHOLDER'), // You need to adjust based on where this data is
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class InteractiveSocketFeed extends ChangeNotifier {
  late IO.Socket _socket;
  late StreamController<List<OrderSocketValues>> _controller;
  List<OrderSocketValues> _dataList = [];

  InteractiveSocketFeed() {
    _controller = StreamController<List<OrderSocketValues>>.broadcast();
    initSocket();
  }

  Future<void> initSocket() async {
    String? token = await getToken();
    String url = "https://mtrade.arhamshare.com/";
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            'token': token,
            'apiType': 'INTERACTIVE',
            'publishFormat': 'JSON',
            'broadcastMode': 'Full',
            'userID': 'A0031'
          })
          .setPath('/interactive/socket.io')
          .build(),
    );

    _socket.onConnect((_) {
      print('Is connected INTERACTIVE: ${_socket.connected}');
    });

    _socket.on('order', (rawData) async {
      print('Raw data received: $rawData');
      try {
        final jsonData = jsonDecode(rawData);
        final orderSocketValues = OrderSocketValues.fromJson(jsonData);
        updateOrderList(orderSocketValues);
        await OrderProvider()
            .refreshOrder(); // Trigger API call to refresh data
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    });

    _socket.on("event", (data) => print(data));
    _socket.on('success INTERACTIVE', (data) => print('success $data'));
  }

  void updateOrderList(OrderSocketValues order) {
    // Replace 'PendingNew' with 'Pending'
    // if (order.orderStatus == 'PendingNew') {
    //   order.orderStatus = 'Pending';
    // }

    // Ignore 'New' status if 'Pending' is already present for the same order
    if (order.orderStatus == 'New') {
      final pendingIndex = _dataList.indexWhere((o) =>
          o.appOrderID == order.appOrderID && o.orderStatus == 'PendingNew');
      if (pendingIndex != -1) {
        return; // Skip adding the 'New' order
      }
    }

    // Check for existing order with the same AppOrderID
    final index = _dataList.indexWhere((o) => o.appOrderID == order.appOrderID);
    if (index != -1) {
      // Update the existing order
      _dataList[index] = order;
    } else {
      // Add new order to the list
      _dataList.add(order);
    }

    _controller.add(_dataList);
    notifyListeners();
  }

  List<OrderSocketValues> get dataList => _dataList;

  @override
  void dispose() {
    _controller.close();
    _socket.dispose();
    super.dispose();
  }

  Stream<List<OrderSocketValues>> get dataListStream => _controller.stream;
}
