import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradingapp/Position/Models/TradeOrderModel/tradeOrder_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewmoreOrderHistory extends StatefulWidget {
  final OrderHistory orderValues;
  const ViewmoreOrderHistory({
    super.key,
    required OrderHistory orderValues,
  }) : this.orderValues = orderValues;

  @override
  State<ViewmoreOrderHistory> createState() => _ViewmoreOrderHistoryState();
}

class _ViewmoreOrderHistoryState extends State<ViewmoreOrderHistory> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Order Values: ${widget.orderValues!.reasonForRejection}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderValues.symbol),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Symbol'),
                          Text(widget.orderValues.tradingSymbol),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Trade ID'),
                          Text(widget.orderValues.tradeId),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Status'),
                          Text(widget.orderValues.status),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Exchange Segment"),
                          Text(widget.orderValues.exchangeSegment),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Type '),
                          Text(
                            widget.orderValues.buySell,
                            style: TextStyle(
                                color: widget.orderValues.buySell == "Buy"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Date'),
                          Text(DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(widget.orderValues.tradeDate))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Qty"),
                          Text(widget.orderValues.totalQty),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Avarage Price'),
                          Text(
                            widget.orderValues.averagePrice,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Rejection Reason'),
                          Text(
                            widget.orderValues.reasonForRejection == ""
                                ? "N/A"
                                : widget.orderValues.reasonForRejection,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Qty"),
                          Text(widget.orderValues.totalQty),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Avarage Price'),
                          Text(
                            widget.orderValues.averagePrice,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Rejection Reason'),
                          Text(
                            widget.orderValues.reasonForRejection == ""
                                ? "N/A"
                                : widget.orderValues.reasonForRejection,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(widget.orderValues.averagePrice),
              ],
            )),
      ),
    );
  }
}
