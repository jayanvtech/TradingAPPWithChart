import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';

import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/Profile/Screens/ProfileScreen/profilepage_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';

class BuySellScreen extends StatefulWidget {
  final String exchangeInstrumentId;
  final String exchangeSegment;
  final String lastTradedPrice;
  final String close;
  final String displayName;
  final bool isBuy;
  final String? lotSize;

  BuySellScreen({
    Key? key,
    required this.exchangeInstrumentId,
    required this.exchangeSegment,
    required this.lastTradedPrice,
    required this.close,
    required this.displayName,
    required this.isBuy,
    required this.lotSize,
  }) : super(key: key);

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> quantitySuggestions = [10, 15, 50, 100];

  late TextEditingController _controller;
  final TextEditingController limitPriceController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '1');
  final TextEditingController stopLossTriggerPriceController =
      TextEditingController();
  final TextEditingController stopLossLimitPriceController =
      TextEditingController();
  String _selectedOption = 'LIMIT';
  String _selectedProductType = 'NRML';
  bool _isStopLossEnabled = false;
  String selectedMarket = 'NSE'; // Tracks which market is selected
  bool isBuy = true;
  bool _showQuantitySuggestions = false;
  String _selectedButton = 'Market';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.lastTradedPrice);
    isBuy = widget.isBuy;
  }

  @override
  void dispose() {
    _controller.dispose();
    stopLossTriggerPriceController.dispose();
    stopLossLimitPriceController.dispose();
    _showQuantitySuggestions = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double price = double.tryParse(_controller.text) ?? 0;
    double marginRequired = quantity * price;

    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onDoubleTap,
        GestureType.onLongPress
      ],
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(147, 228, 233, 237),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 120,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Margin Required(Approx)",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text("Available Cash",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      marginRequired.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        ChangeNotifierProvider(
                          create: (context) => BalanceProvider()..GetBalance(),
                          child: Consumer<BalanceProvider>(
                            builder: (context, provider, child) {
                              if (provider.balance == null) {
                                return Container();
                              }
                              if (provider.balance!.isNotEmpty) {
                                var balance = provider.balance!.first;
                                return Text(
                                  "₹ ${double.parse(balance.netMarginAvailable).toStringAsFixed(2)}", // Replace `cashAvailable` with your actual field
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print("Form is valid");
                      } else {
                        print("Form is invalid");
                      }
                      final finalquantiy =
                          int.parse(quantityController.text.toString()) *
                              int.parse(widget.lotSize.toString());
                      final orderDetails = {
                        // "clientID": "A0031",
                        // "userID": "A0031",
                        "exchangeSegment": ExchangeConverter()
                            .getExchangeSegmentName(
                                int.parse(widget.exchangeSegment))
                            .toString(),
                        "exchangeInstrumentID":
                            int.parse(widget.exchangeInstrumentId),
                        "productType": _selectedProductType,
                        "orderType": _selectedButton == "Market"
                            ? "Market"
                            : _selectedButton == "Price Limit"
                                ? "Limit"
                                : _selectedButton == "SL Limit"
                                    ? "StopLimit"
                                    : "Limit",
                        "orderSide": isBuy ? "BUY" : "SELL",
                        "timeInForce": "DAY",
                        "disclosedQuantity": "0",
                        "orderQuantity": finalquantiy.toString(),
                        "limitPrice": double.parse(_controller.text),
                        "stopPrice": _isStopLossEnabled &&
                                stopLossTriggerPriceController.text.isNotEmpty
                            ? double.parse(stopLossLimitPriceController.text)
                            : 0, //    "stopLimitPrice": _isStopLossEnabled ? stopLossLimitPriceController.text.toString() : null,
                        "orderUniqueIdentifier": "123abc"
                      };
                      print(_selectedOption);
                      print(orderDetails);
                      try {
                        final response = await ApiService().placeOrder(
                            orderDetails, widget.displayName, context);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Order placed successfully!'),
                        //   ),
                        // );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to place order: $error'),
                          ),
                        );
                      }
                    },
                    child: Text(isBuy ? "Place Buy Order" : "Place Sell Order"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.to(MainScreen());
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size(0, 40),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: double.infinity, // Ensure the Container takes full width

              child:
                  Consumer<MarketFeedSocket>(builder: (context, data, child) {
                final marketData =
                    data.getDataById(int.parse(widget.exchangeInstrumentId));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedMarket = 'NSE'),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedMarket == 'NSE'
                                            ? Colors.blue
                                            : const Color.fromARGB(
                                                255, 228, 233, 237),
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(5)),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "NSE",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: selectedMarket == 'NSE'
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  marketData?.price
                                                          .toString() ??
                                                      'N/A',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        selectedMarket == 'NSE'
                                                            ? Colors.white
                                                            : Colors.grey,
                                                  ),
                                                ),
                                                // Text(
                                                //   " (${marketData?.percentChange.toString()}%)" ??
                                                //       'N/A',
                                                //   style: TextStyle(
                                                //     color: selectedMarket == 'NSE'
                                                //         ? Colors.white
                                                //         : Colors.grey,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedMarket = 'BSE'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedMarket == 'BSE'
                                          ? Colors.blue
                                          : const Color.fromARGB(
                                              255, 228, 233, 237),
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(5)),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "BSE",
                                            style: TextStyle(
                                                color: selectedMarket == 'BSE'
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                marketData?.price.toString() ??
                                                    'N/A',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: selectedMarket == 'BSE'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Consumer<MarketFeedSocket>(builder: (context, data, child) {
            final marketData =
                data.getDataById(int.parse(widget.exchangeInstrumentId));
            final priceChange = marketData != null
                ? double.parse(marketData.price) - double.parse(widget.close)
                : 0;
            final priceChangeColor =
                priceChange > 0 ? Colors.green : Colors.red;

            String displayname1 = widget.displayName.split(" ")[0];
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              widget.exchangeSegment != '1'
                                  ? Column(
                                      children: [
                                        Text(
                                          displayname1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.displayName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                ExchangeConverter().getExchangeSegmentName(
                                    int.parse(widget.exchangeSegment)),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //
                              Text(
                                "₹" + (marketData?.price.toString() ?? 'N/A'),
                                style: TextStyle(
                                    color: priceChangeColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${priceChange.toStringAsFixed(2)}(${marketData?.percentChange ?? 0}%)",
                                style: TextStyle(
                                    color: priceChangeColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBuy = true;
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(5)),
                                      color: isBuy
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255, 228, 233, 237)),
                                  child: Center(
                                    child: Text(
                                      "BUY",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isBuy
                                              ? Colors.white
                                              : Colors.green),
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBuy = false;
                                  print(isBuy);
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(5)),
                                      color: !isBuy
                                          ? Colors.red
                                          : const Color.fromARGB(
                                              255, 228, 233, 237)),
                                  child: Center(
                                    child: Text(
                                      "SELL",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: !isBuy
                                              ? Colors.white
                                              : Colors.red),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ],
            );
          }),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child:
                    //   Consumer<MarketFeedSocket>(builder: (context, data, child) {
                    // final marketData =
                    //     data.getDataById(int.parse(widget.exchangeInstrumentId));
                    // double totalCost = 0.0;
                    // double quantity = 1.0;
                    // double price = 0.0;

                    // try {
                    //   quantity = double.parse(quantityController.text);
                    // } catch (e) {
                    //   print("Error parsing quantity: ${e.toString()}");
                    // }

                    // try {
                    //   price = double.parse(marketData!.price);
                    // } catch (e) {
                    //   print("Error parsing price: ${e.toString()}");
                    //   // Optionally, show an error message to the user
                    // }

                    // totalCost = quantity * price;

                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Type",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 19),
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 228, 233, 237),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: _buildProductTypeButton('NRML')),
                                    Expanded(
                                        child: _buildProductTypeButton('MIS')),
                                    Expanded(
                                        child: _buildProductTypeButton('CNC')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(147, 228, 233, 237),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSelectButton('Market', 'Market'),
                                _buildSelectButton(
                                    'Price Limit', 'Price Limit'),
                                _buildSelectButton('SL Limit', 'SL Limit'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 70,
                                      ),
                                      Text(
                                        "x${widget.lotSize ?? 1} Lots",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      _buildPriceButton(Icons.remove, () {
                                        int currentValue = int.tryParse(
                                                quantityController.text) ??
                                            0;
                                        currentValue -= 1;
                                        quantityController.text =
                                            currentValue.toString();
                                      }),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        child: Container(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: TextFormField(
                                            autofocus: true,
                                            style: TextStyle(),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(),
                                            controller: quantityController,
                                            textAlign: TextAlign.center,
                                            readOnly:
                                                _selectedOption == 'Market',
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            validator: (value) {
                                              if (_selectedOption == 'Limit' &&
                                                  value!.isEmpty) {
                                                return "Please enter price";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      _buildPriceButton(Icons.add, () {
                                        int currentValue = int.tryParse(
                                                quantityController.text) ??
                                            0;
                                        currentValue += 1;
                                        quantityController.text =
                                            currentValue.toString();
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 0,
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 100),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                child: _selectedButton == 'Price Limit' ||
                                        _selectedButton == 'SL Limit'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Limit Price",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Row(
                                                children: [
                                                  _buildPriceButton(
                                                      Icons.remove, () {
                                                    double currentValue =
                                                        double.tryParse(
                                                                _controller
                                                                    .text) ??
                                                            0;
                                                    currentValue -= 1;
                                                    _controller.text =
                                                        currentValue
                                                            .toStringAsFixed(2);
                                                  }),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      child: TextFormField(
                                            
                                                        onChanged: (value) {
                                                          setState(() {});
                                                        },
                                                        decoration:
                                                            InputDecoration(),
                                                        controller: _controller,
                                                        textAlign:
                                                            TextAlign.center,
                                                        readOnly:
                                                            _selectedOption ==
                                                                'Market',
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                          decimal: true,
                                                        ),
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^\d+\.?\d{0,2}')),
                                                        ],
                                                        validator: (value) {
                                                          if (_selectedOption ==
                                                                  'Limit' &&
                                                              value!.isEmpty) {
                                                            return "Please enter price";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  _buildPriceButton(Icons.add,
                                                      () {
                                                    double currentValue =
                                                        double.tryParse(
                                                                _controller
                                                                    .text) ??
                                                            0;
                                                    currentValue += 1;
                                                    _controller.text =
                                                        currentValue
                                                            .toStringAsFixed(2);
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Stack(
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 100),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                child: _selectedButton == 'SL Limit'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SL Trigger Price",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Row(
                                                children: [
                                                  _buildPriceButton(
                                                      Icons.remove, () {
                                                    double currentValue =
                                                        double.tryParse(
                                                                stopLossTriggerPriceController
                                                                    .text) ??
                                                            0;
                                                    currentValue -= 1;
                                                    stopLossTriggerPriceController
                                                            .text =
                                                        currentValue
                                                            .toStringAsFixed(2);
                                                  }),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                    child: Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            height:
                                                                1.0), // Ensure non-zero height

                                                        controller:
                                                            stopLossTriggerPriceController,
                                                        textAlign:
                                                            TextAlign.center,
                                                        readOnly:
                                                            _selectedOption ==
                                                                'Market',
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^\d+\.?\d{0,2}')),
                                                        ],
                                                        validator: (value) {
                                                          if (_selectedOption ==
                                                                  'Limit' &&
                                                              value!.isEmpty) {
                                                            return "Please enter price";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  _buildPriceButton(Icons.add,
                                                      () {
                                                    double currentValue =
                                                        double.tryParse(
                                                                stopLossTriggerPriceController
                                                                    .text) ??
                                                            0;
                                                    currentValue += 1;
                                                    stopLossTriggerPriceController
                                                            .text =
                                                        currentValue
                                                            .toStringAsFixed(2);
                                                  }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Range: 0.0 - 0.0",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        _selectedProductType == 'MIS'
                            ? Container(
                                child: Text(11.toString() ?? ''),
                              )
                            : SizedBox(height: 20),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // Step 2: Create a method to display quantity suggestions
  Widget _buildQuantitySuggestions() {
    List<int> quantities = [
      10,
      15,
      50,
      100,
      200
    ]; // Define your quantities here
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      decoration: BoxDecoration(
        color: Color.fromARGB(147, 228, 233, 237),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Wrap(
            children: quantities.map((quantity) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                child: ChoiceChip(
                  label: Text(quantity.toString()),
                  selected: quantityController == quantity,
                  onSelected: (bool selected) {
                    setState(() {
                      quantityController.text = quantity.toString();
                      _showQuantitySuggestions =
                          false; // Optionally hide suggestions after selection
                    });
                  },
                ),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: () {
              _showQuantitySuggestions = false;
            },
            icon: Icon(
              Icons.delete,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectButton(String label, String value) {
    return Expanded(
      // Ensures equal distribution of buttons
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedButton = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 8.0), // Adjust padding if needed
          decoration: BoxDecoration(
            color: _selectedButton == value
                ? Colors.blue
                : Color.fromARGB(
                    75, 228, 233, 237), // Dynamic color based on selection
            borderRadius:
                BorderRadius.circular(5.0), // Consistent border radius
          ),
          child: Center(
            // Center text for better alignment
            child: Text(
              label,
              style: TextStyle(
                color: _selectedButton == value
                    ? Colors.white
                    : Colors.black, // Dynamic text color
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductTypeButton(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProductType = type;
        });
      },
      child: Container(
        height: 35,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Text(
                      type,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 4,
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: _selectedProductType == type
                    ? Colors.blue
                    : Color.fromARGB(147, 228, 233, 237),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        foregroundColor:
            _selectedOption == option ? Colors.white : Colors.black,
        backgroundColor: _selectedOption == option
            ? Colors.blue
            : Color.fromARGB(41, 228, 233, 237),
        disabledForegroundColor: Color.fromARGB(147, 228, 233, 237),
      ),
      onPressed: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Text(option),
    );
  }

  Widget _buildPriceButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Color.fromARGB(98, 228, 233, 237),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 15, color: Colors.blue),
        onPressed: _selectedOption == 'Limit' ? onPressed : null,
      ),
    );
  }
}
