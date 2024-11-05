import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradingapp/Profile/Models/UserProfileModel/ledger_report_model.dart';

class LedgerMoreDetails extends StatefulWidget {
  final LedgerReportModel transaction;
  const LedgerMoreDetails({super.key, required this.transaction});

  @override
  State<LedgerMoreDetails> createState() => _LedgerMoreDetailsState();
}

class _LedgerMoreDetailsState extends State<LedgerMoreDetails> {
  @override
  Widget build(BuildContext context) {
    double parseDouble(String value) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0; 
      }
    }

    String formattedDate(String dateString) {
      try {
        DateFormat inputFormat = DateFormat('MMMM, dd yyyy HH:mm:ss Z');
        DateTime dateTime = inputFormat.parse(dateString);
        DateFormat outputFormat = DateFormat('dd-MM-yyyy');
        String formattedDate = outputFormat.format(dateTime);

        return formattedDate;
      } catch (e) {
        return '-';
      }
    }

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,scrolledUnderElevation: 0,
        title: Text('Ledger More Details',),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bill Date"),
                      Text(formattedDate(widget.transaction.billDate)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Voucher Date"),
                      Text(formattedDate(widget.transaction.voucherDate)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Voucher No",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.voucherNo),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Settlement No",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.settlementNo),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.justify,
                    "Narration",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(widget.transaction.narration),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trading COCD",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.tradingCocd),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amont",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DR Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.drAmt,
                        style: TextStyle(
                          color: widget.transaction.crAmt == "0"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CR Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.crAmt,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: widget.transaction.crAmt == "0"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class FunTranscationMoreDetailsScreen extends StatefulWidget {
  final FundtransaferModel transaction;
  const FunTranscationMoreDetailsScreen({super.key, required this.transaction});

  @override
  State<FunTranscationMoreDetailsScreen> createState() => _FunTranscationMoreDetailsScreenState();
}

class _FunTranscationMoreDetailsScreenState extends State<FunTranscationMoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double parseDouble(String value) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0; 
      }
    }

    String formattedDate(String dateString) {
      try {
        DateFormat inputFormat = DateFormat('MMMM, dd yyyy HH:mm:ss Z');
        DateTime dateTime = inputFormat.parse(dateString);
        DateFormat outputFormat = DateFormat('dd-MM-yyyy');
        String formattedDate = outputFormat.format(dateTime);

        return formattedDate;
      } catch (e) {
        return '-';
      }
    }

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,scrolledUnderElevation: 0,
        title: Text('Fund Transcation',),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bill Date"),
                      Text(formattedDate(widget.transaction.billDate)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Voucher Date"),
                      Text(formattedDate(widget.transaction.voucherDate)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Voucher No",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.voucherNo),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vocher Type",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.vocType),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.justify,
                    "Narration",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(widget.transaction.narration),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trading COCD",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(widget.transaction.tradingCocd),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amont",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DR Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.drAmt,
                        style: TextStyle(
                          color: widget.transaction.crAmt == "0"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CR Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.crAmt,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: widget.transaction.crAmt == "0"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
