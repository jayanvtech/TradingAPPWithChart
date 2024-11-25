import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/Profile/Models/UserProfileModel/ledger_report_model.dart';


class VoucherBillScreen extends StatefulWidget {
  final String voucherDate;
  const VoucherBillScreen({super.key,  required this.voucherDate});

  @override
  State<VoucherBillScreen> createState() => _VoucherBillScreenState();
}

class _VoucherBillScreenState extends State<VoucherBillScreen> {
  @override
  Widget build(BuildContext context) {
    String formatDate(String dateStr) {
        DateTime dateTime =
            DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(dateStr);
        String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);

        return formattedDate;
      }
    print(widget.voucherDate);
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,
      backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('Voucher Bill (${formatDate(widget.voucherDate)})'),
      ),
      body: FutureBuilder(
          future: ApiService().fetchVoucherBillDetails(widget.voucherDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "ISIN",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54,
                                              fontSize: 13),
                                        ),
                                        SizedBox(width: 10),
                                        Text(snapshot.data![index].scripName,      style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54,
                                              fontSize: 13),),
                                    
                                    Text(" - ${snapshot.data![index].instType}",      style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54,
                                              fontSize: 13),),
                                      ],
                                    ),
                                    Text(snapshot.data![index].isin),
                                    
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Net Ammont",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54,
                                          fontSize: 13),
                                    ),
                                    Text(double.parse(snapshot.data![index].closingAmt).toStringAsFixed(2)
                                    ,      style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: snapshot.data![index].closingAmt.contains("-")?Colors.red:Colors.green,
                                              ),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                snapshot.data![index].instType == "OPTIDX"
                                    ? Container(height: 51,padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1),
                                  // border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "B QTY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(snapshot.data![index].bQty),
                                              ],
                                            ),
                                       VerticalDivider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "B Rate",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(double.parse(snapshot.data![index].bRate).toStringAsFixed(2)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                    : Container(height: 51,padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1),
                                  // border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "B.F QTY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(snapshot.data![index].bfQty),
                                              ],
                                            ),
                                       VerticalDivider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "B.F Rate",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(double.parse(snapshot.data![index].bfRate).toStringAsFixed(2)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                       snapshot.data![index].instType == "OPTIDX"?
                                Container(height: 51,padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1),
                                  // border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                  child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "S QTY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(snapshot.data![index].sQty),
                                              ],
                                            ),
                                    VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                         
                                              color: Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "S Rate",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(double.parse(snapshot.data![index].sRate).toStringAsFixed(2)),
                                              ],
                                            ),
                                        ],
                                      ),
                                ):Container(height: 51,padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.1),
                                  // border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Net QTY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(snapshot.data![index].netQty),
                                              ],
                                            ),
                                       VerticalDivider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Rate",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black54,
                                                      fontSize: 13),
                                                ),
                                                Text(_formatCloseRate(snapshot.data![index].closeRate)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                              ],
                            )

                            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [Text("ISIN: "),
                            //     Text(snapshot.data![index].isin),
                            //   ],
                            // ),
                            // Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text("Inst Type: "),
                            //     Text(snapshot.data![index].instType),
                            //   ],
                            // ),
                            // Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text("Buy Qty: "),
                            //     Text(snapshot.data![index].bQty),
                            //   ],
                            // ),
                            // Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text("Buy Rate: "),
                            //     Text(snapshot.data![index].bRate),
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text("Buy Amt: "),
                            //     Text(snapshot.data![index].samt),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
            }
          }),
    );
  }
  String _formatCloseRate(String? closeRate) {
  if (closeRate == null || closeRate.isEmpty) {
    return '-';
  }
  try {
    return double.parse(closeRate).toStringAsFixed(2);
  } catch (e) {
    return '0.00';
  }
}
}
