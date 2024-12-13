import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:intl/intl.dart';
import 'package:tradingapp/Profile/Reports/Models/ledger_report_model.dart';
import 'package:tradingapp/Profile/Reports/screens/voucher_bill_screen.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

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

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        scrolledUnderElevation: 0,
        title: CommonText(
          text: 'Ledger More Details',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyColor.withOpacity(0.57),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor3,
                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor3,
                  ],
                  stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: 'Bill Date',
                        fontWeight: FontWeight.bold,
                      ).paddingOnly(bottom: 4),
                      CommonText(
                        text: '${formattedDate(widget.transaction.billDate)}',
                        fontSize: 12,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonText(
                        text: widget.transaction.crAmt == '0' ? '-${widget.transaction.drAmt}' : '+${widget.transaction.crAmt}',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.transaction.crAmt == '0' ? AppColors.RedColor : AppColors.GreenColor,
                      ).paddingOnly(bottom: 4),
                      CommonText(
                        text: widget.transaction.crAmt != '0' ? 'Credited' : 'Debited',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor300),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(text: "Bill Date"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoucherBillScreen(voucherDate: widget.transaction.billDate),
                            ),
                          );
                        },
                        child: CommonText(text: formattedDate(widget.transaction.billDate)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(text: "Voucher Date"),
                      CommonText(text: formattedDate(widget.transaction.voucherDate)),
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
                      CommonText(
                        text: "Voucher No",
                        color: Colors.black54,
                      ),
                      CommonText(text: widget.transaction.voucherNo),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: "Settlement No",
                        color: Colors.black54,
                      ),
                      CommonText(text: widget.transaction.settlementNo),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
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
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
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
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DR Amount",
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.drAmt,
                        style: TextStyle(
                          color: widget.transaction.crAmt == "0" ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CR Amount",
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.crAmt,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: widget.transaction.crAmt == "0" ? Colors.red : Colors.green,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Fund Transcation',
        ),
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
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                      ),
                      Text(widget.transaction.voucherNo),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vocher Type",
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
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
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
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
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DR Amount",
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.drAmt,
                        style: TextStyle(
                          color: widget.transaction.crAmt == "0" ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CR Amount",
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                      ),
                      Text(
                        widget.transaction.crAmt,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: widget.transaction.crAmt == "0" ? Colors.red : Colors.green,
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
