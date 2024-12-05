// ignore_for_file: unused_import

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Position/Models/TradeOrderModel/tradeOrder_model.dart';
import 'package:tradingapp/Utils/exchangeConverter.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/ordersocketvalues_model.dart';

class ModifyOrderScreen extends StatefulWidget {
  final OrderValues orderValues;
  ModifyOrderScreen(

      {Key? key, OrderValues? orderValues})
      : orderValues = orderValues!,
        super(key: key);
 

  @override
  State<ModifyOrderScreen> createState() => _ModifyOrderScreenState();
}

class _ModifyOrderScreenState extends State<ModifyOrderScreen> {

  late TextEditingController _controller;
  late TextEditingController LimitPriceController = TextEditingController();
  late TextEditingController QantityController = TextEditingController();
  final TextEditingController limitPriceController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController();
  late TextEditingController stopLossTriggerPriceController =
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
    _controller = TextEditingController(text: widget.orderValues.orderPrice.toString());
   _selectedOption=widget.orderValues.orderType.toString();
   _selectedProductType=widget.orderValues.productType.toString();
   _isStopLossEnabled=widget.orderValues.orderStopPrice!=0;
   stopLossTriggerPriceController = TextEditingController(text: widget.orderValues.orderStopPrice.toString());
       LimitPriceController=LimitPriceController..text=widget.orderValues.orderPrice.toString();
    QantityController=TextEditingController(text: widget.orderValues.orderQuantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: Consumer<MarketFeedSocket>(builder: (context, data, child) {
          final marketData =
              data.getDataById(int.parse(widget.orderValues.exchangeInstrumentID.toString()));

          final priceChange = marketData != null
              ? double.parse(marketData.price) - double.parse(widget.orderValues.orderPrice.toString())
              : 0;
          final priceChangeColor = priceChange > 0 ? Colors.green : Colors.red;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.orderValues.tradingSymbol),
                  Text(
                    widget.orderValues.exchangeSegment.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
                
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "₹" + marketData!.price.toString(),
                        style: TextStyle(color: priceChangeColor, fontSize: 18),
                      ),
                      Icon(
                        Icons.arrow_drop_up,
                        color: priceChangeColor,
                      ),
                    ],
                  ),
                  Text(
                    "${priceChange.toStringAsFixed(2)}(${marketData!.percentChange}%)",
                    style: TextStyle(color: priceChangeColor, fontSize: 15),
                  )
                ],
              ),
            ],
          );
        }),
      ),
      backgroundColor: Colors.white,
      body: Container(padding: EdgeInsets.all(15),
        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Type",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
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
                                            child:
                                                _buildProductTypeButton('NRML')),
                                        Expanded(
                                            child:
                                                _buildProductTypeButton('MIS')),
                                        Expanded(
                                            child:
                                                _buildProductTypeButton('CNC')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            "x${1 ?? 1} Lots",
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
                                                decoration: InputDecoration(),
                                                controller: QantityController,
                                                textAlign: TextAlign.center,
                                                readOnly:
                                                    _selectedOption == 'Market',
                                                keyboardType:
                                                    TextInputType.number,
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
                                                                .toStringAsFixed(
                                                                    2);
                                                      }),
                                                      SizedBox(width: 10),
                                                      GestureDetector(
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                          child: TextFormField(
                                                    
                                                            style: TextStyle(),
                                                            decoration:
                                                                InputDecoration(),
                                                            controller:
                                                                _controller,
                                                            textAlign:
                                                                TextAlign.center,
                                                            readOnly:
                                                                _selectedOption ==
                                                                    'Market',
                                                            keyboardType:
                                                                TextInputType
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
                                                                  value!
                                                                      .isEmpty) {
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
                                                                .toStringAsFixed(
                                                                    2);
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: <Widget>[
                                              //     _buildOptionButton('Limit'),
                                              //     SizedBox(width: 5),
                                              //     _buildOptionButton('Market'),
                                              //   ],
                                              // ),
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
        
                              Stack(
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       _showQuantitySuggestions =
                                  //           !_showQuantitySuggestions;
                                  //     });
                                  //   },
                                  //   child: Container(
                                  //     width:
                                  //         MediaQuery.of(context).size.width * 0.45,
                                  //     decoration: BoxDecoration(
                                  //       color:Color.fromARGB(147, 228, 233, 237),
                                  //       borderRadius: BorderRadius.circular(5),
                                  //     ),
                                  //     padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                                  //     child: Column(
                                  //       children: [
                                  //         SizedBox(
                                  //           height: 10,
                                  //         ),
                                  //         Row(
                                  //           children: [
                                  //             Icon(
                                  //               Icons.info_outline,
                                  //               size: 16,
                                  //             ),
                                  //             Text(" Show Suggestions"),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
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
                                                                .toStringAsFixed(
                                                                    2);
                                                      }),
                                                      SizedBox(width: 10),
                                                      GestureDetector(
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(
                                                                      context)
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
                                                                  value!
                                                                      .isEmpty) {
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
                                                                .toStringAsFixed(
                                                                    2);
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
                              Visibility(
                                visible: _showQuantitySuggestions,
                                child:
                                    Container(child: _buildQuantitySuggestions()),
                              ),
        
                              SizedBox(height: 5),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Enable Stop Loss",
                              //       style: TextStyle(color: Colors.grey),
                              //     ),
                              //     Switch(
                              //       activeColor: Colors.blue,
                              //       inactiveTrackColor:
                              //           const Color.fromARGB(147, 228, 233, 237),
                              //       value: _isStopLossEnabled,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _isStopLossEnabled = value;
                              //         });
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
            //   body: Container(
            //     padding: EdgeInsets.all(15),
            //     child: Consumer<MarketFeedSocket>(builder: (context, data, child) {
            //       final marketData =
            //           data.getDataById(int.parse(widget.orderValues.exchangeInstrumentID.toString()));
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("Prodcut Type"),
            //                 Row(
            //                   children: <Widget>[
            //                     TextButton(
            //                       style: TextButton.styleFrom(
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(10)),
            //                         foregroundColor: _selectedProductType == 'NRML'
            //                             ? Colors.white
            //                             : Colors.black,
            //                         backgroundColor: _selectedProductType == 'NRML'
            //                             ? Colors.blue
            //                             : Colors.grey,
            //                         disabledForegroundColor:
            //                             Colors.grey.withOpacity(0.38),
            //                       ),
            //                       onPressed: () {
            //                         setState(() {
            //                           _selectedProductType = 'NRML';
            //                         });
            //                       },
            //                       child: Text('NRML'),
            //                     ),
            //                     SizedBox(
            //                       width: 5,
            //                     ),
            //                     TextButton(
            //                       style: TextButton.styleFrom(
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(10)),
            //                         foregroundColor: _selectedProductType == 'MIS'
            //                             ? Colors.white
            //                             : Colors.black,
            //                         backgroundColor: _selectedProductType == 'MIS'
            //                             ? Colors.blue
            //                             : Colors.grey,
            //                         disabledForegroundColor:
            //                             Colors.grey.withOpacity(0.38),
            //                       ),
            //                       onPressed: () {
            //                         setState(() {
            //                           _selectedProductType = 'MIS';
            //                         });
            //                       },
            //                       child: Text('MIS'),
            //                     ),
            //                     SizedBox(
            //                       width: 5,
            //                     ),
            //                     TextButton(
            //                       style: TextButton.styleFrom(
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(10)),
            //                         foregroundColor: _selectedProductType == 'CNC'
            //                             ? Colors.white
            //                             : Colors.black,
            //                         backgroundColor: _selectedProductType == 'CNC'
            //                             ? Colors.blue
            //                             : Colors.grey,
            //                         disabledForegroundColor:
            //                             Colors.grey.withOpacity(0.38),
            //                       ),
            //                       onPressed: () {
            //                         setState(() {
            //                           _selectedProductType = 'CNC';
            //                         });
            //                       },
            //                       child: Text('CNC'),
            //                     ),
            //                   ],
            //                 ),
            //                 Text("No of Shares"),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //                 TextField(
            //                   keyboardType: TextInputType.numberWithOptions(),
            //                   controller: QantityController,
            //                   decoration: InputDecoration(
            //                       hintText: "Enter Quantity",
            //                       labelText: "Quantity",
            //                       border: OutlineInputBorder(
            //                           borderRadius: BorderRadius.circular(10))),
            //                 ),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //                 Text("Price"),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Container(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           Container(
            //                             decoration: BoxDecoration(
            //                                 color: Colors.blue,
            //                                 borderRadius: BorderRadius.circular(10)),
            //                             child: IconButton(
            //                               icon: Icon(Icons.remove, color: Colors.white),
            //                               onPressed: _selectedOption == 'Limit'
            //                                   ? () {
            //                                       double currentValue = double.tryParse(
            //                                               _controller.text) ??
            //                                           0;
            //                                       currentValue -=
            //                                           1; // Decrease the value by 1
            //                                       _controller.text =
            //                                           currentValue.toStringAsFixed(
            //                                               2); // Update the controller
            //                                     }
            //                                   : null, // Disable the button when "Market" is selected
            //                             ),
            //                           ),
            //                           Divider(),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Container(
            //                             width:
            //                                 70, // You can adjust this value as needed
            //                             child: TextField(
            //                               controller: _controller,
            //                               textAlign: TextAlign.center,
        
            //                               readOnly: _selectedOption ==
            //                                   'Market', // Make the TextField read-only when "Market" is selected
            //                               keyboardType: TextInputType.number,
            //                               inputFormatters: <TextInputFormatter>[
            //                                 FilteringTextInputFormatter.allow(RegExp(
            //                                     r'^\d+\.?\d{0,2}')), // Allow decimal input
            //                               ],
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Container(
            //                             decoration: BoxDecoration(
            //                                 color: Colors.blue,
            //                                 borderRadius: BorderRadius.circular(10)),
            //                             child: IconButton(
            //                               icon: Icon(
            //                                 Icons.add,
            //                                 color: Colors.white,
            //                               ),
            //                               onPressed: _selectedOption == 'Limit'
            //                                   ? () {
            //                                       double currentValue = double.tryParse(
            //                                               _controller.text) ??
            //                                           0;
            //                                       currentValue +=
            //                                           1; // Increase the value by 1
            //                                       _controller.text =
            //                                           currentValue.toStringAsFixed(
            //                                               2); // Update the controller
            //                                     }
            //                                   : null, // Disable the button when "Market" is selected
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     Container(
            //                       child: Row(
            //                         children: <Widget>[
            //                           TextButton(
            //                             style: TextButton.styleFrom(
            //                               shape: RoundedRectangleBorder(
            //                                   borderRadius: BorderRadius.circular(10)),
            //                               foregroundColor: _selectedOption == 'Limit'
            //                                   ? Colors.white
            //                                   : Colors.black,
            //                               backgroundColor: _selectedOption == 'Limit'
            //                                   ? Colors.blue
            //                                   : Colors.grey,
            //                               disabledForegroundColor:
            //                                   Colors.grey.withOpacity(0.38),
            //                             ),
            //                             onPressed: () {
            //                               setState(() {
            //                                 _selectedOption = 'Limit';
            //                               });
            //                             },
            //                             child: Text('Limit'),
            //                           ),
            //                           SizedBox(
            //                             width: 5,
            //                           ),
            //                           TextButton(
            //                             style: TextButton.styleFrom(
            //                               shape: RoundedRectangleBorder(
            //                                   borderRadius: BorderRadius.circular(10)),
            //                               foregroundColor: _selectedOption == 'Market'
            //                                   ? Colors.white
            //                                   : Colors.black,
            //                               backgroundColor: _selectedOption == 'Market'
            //                                   ? Colors.blue
            //                                   : Colors.grey,
            //                               disabledForegroundColor:
            //                                   Colors.grey.withOpacity(0.38),
            //                             ),
            //                             onPressed: () {
            //                               setState(() {
            //                                 _selectedOption = 'Market';
            //                                 // Provider.of<MarketFeedSocket>(context,
            //                                 //         listen: false)
            //                                 //     .addListener(() {
            //                                 //   _controller.text =
            //                                 //       Provider.of<MarketFeedSocket>(context,
            //                                 //               listen: false)
            //                                 //           .getDataById(int.parse(
            //                                 //               widget.exchangeInstrumentId))!
            //                                 //           .price
            //                                 //           .toString();
            //                                 // });
            //                               });
            //                             },
            //                             child: Text('Market'),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //               ],
            //             ),
            //           ),
            //           SizedBox(
            //             height: 10,
            //           ),
            //           Column(
            //             children: [
            //               Container(
            //                 width: double.infinity,
            //                 height: 50,
            //                 child: ElevatedButton(
            //                   onPressed: () {
            //                     final orderDetails = {
            //                       "appOrderID": widget.orderValues.appOrderID,
            //                       "clientID": "A0031",
            //                       "exchangeSegment":widget.orderValues.exchangeSegment,
            //                       "exchangeInstrumentID":
            //                           widget.orderValues.exchangeInstrumentID.toString(),
            //                       "modifiedProductType": "NRML",
            //                       "modifiedOrderType":
            //                         _controller.text == "0" 
            //                               ? "MARKET"
            //                               : "LIMIT", 
            //                               "orderSide": widget.orderValues.orderSide.toString() == "BUY"
            //                           ? "SELL"
            //                           : "BUY",
            //                       "modifiedTimeInForce": "DAY",
            //                       "modifiedDisclosedQuantity": 0,
            //                       "modifiedOrderQuantity": QantityController.text,
            //                       "modifiedLimitPrice": _controller.text,
            //                       "modifiedStopPrice": 0,
            //                       "userID": "A0031"
            //                     };
            //                     ApiService().ModifyOrder(
            //                         orderDetails, widget.orderValues.tradingSymbol, context);
            //                   },
            //                   child: Text("Modify Order"),
            //                   style: ButtonStyle(
            //                     backgroundColor:
            //                         MaterialStateProperty.all<Color>(Colors.blue),
            //                     foregroundColor: MaterialStateColor.resolveWith(
            //                         (states) => Colors.white),
            //                     shape:
            //                         MaterialStateProperty.all<RoundedRectangleBorder>(
            //                             RoundedRectangleBorder(
            //                                 borderRadius: BorderRadius.circular(10))),
            //                   ),
            //                 ),
            //               ),
            //               _selectedProductType == 'MIS'
            //                   ? Container(
            //                       child: Text(marketData!.percentChange.toString()),
            //                     ) // Display this when 'mis' is selected
            //                   : SizedBox(
            //                       height: 20,
            //                     ),
            //             ],
            //           ),
            //         ],
            //       );
            //     }),
            //   ),
            // );
         
                        )
                        ,
                        Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final orderDetails = {
                                  "appOrderID": widget.orderValues.appOrderID,
                                  // "clientID": "A0031",
                                  // "exchangeSegment":widget.orderValues.exchangeSegment,
                                  // "exchangeInstrumentID":
                                      // widget.orderValues.exchangeInstrumentID.toString(),
                                  "modifiedProductType": _selectedProductType,
                                  "modifiedOrderType":
                                  _selectedButton == "Market"
    ? "Market"
    : _selectedButton == "Price Limit"
        ? "Limit"
        : _selectedButton == "SL Limit"
            ? "StopLimit"
            : "LIMIT",
                                          // "orderSide": widget.orderValues.orderSide.toString() == "BUY"
                                      // ? "SELL"
                                      // : "BUY",
                                  "modifiedTimeInForce": widget.orderValues.timeInForce,
                                  "modifiedDisclosedQuantity": widget.orderValues.orderDisclosedQuantity,
                                  "modifiedOrderQuantity": QantityController.text,
                                  "modifiedLimitPrice": _controller.text,
                                  "modifiedStopPrice": _isStopLossEnabled &&
                                stopLossTriggerPriceController.text.isNotEmpty
                            ? int.parse(stopLossLimitPriceController.text)
                            : 0,
                            "orderUniqueIdentifier": widget.orderValues.orderUniqueIdentifier,
                                  // "userID": "A0031"
                                };
                                ApiService().ModifyOrder(
                                    orderDetails, widget.orderValues.tradingSymbol, context);
                              },
                              child: Text("Modify Order"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors.blue),
                                foregroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                          _selectedProductType == 'MIS'
                              ? Container(
                                  child: Text("marketData!.percentChange.toString()"),
                                ) // Display this when 'mis' is selected
                              : SizedBox(
                                  height: 20,
                                ),
                        ],
                      ),
                        ]
        ),
      ));
 
 }
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
