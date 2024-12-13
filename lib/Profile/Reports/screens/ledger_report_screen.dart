import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Profile/Reports/Models/ledger_report_model.dart';
import 'package:flutter/material.dart';
import 'package:tradingapp/Profile/Reports/screens/ledger_more_details_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';

class LedgerReportScreen extends StatefulWidget {
  LedgerReportScreen();

  @override
  _LedgerReportScreenState createState() => _LedgerReportScreenState();
}

class _LedgerReportScreenState extends State<LedgerReportScreen> {
  String? selectedCocd = 'ALL';
  var totalBalance;
  var FinalTotalbalance;
  String selectedTODate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedFromDate = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(Duration(days: 7)));

  @override
  void initState() {
    super.initState();
    fetchLedgerReport();
  }

  Future<void> fetchLedgerReport() async {
    try {
      await ApiService().fetchLedgerReportDetails(selectedFromDate, selectedTODate);
      setState(() {
        // You can handle any additional state updates here if needed
      });
    } catch (error) {
      print('Error fetching ledger report: $error');
    }
  }

  List<String> cocdTypes = ['ALL', 'BSE_CASH', 'NSE_CASH', 'CD_NSE', 'MF_BSE', 'NSE_DLY', 'NSE_FNO', 'NSE_SLBM', 'MTF'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(color: AppColors.primaryColor, blurRadius: 1),
          ],
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Total Balance: ${double.parse(AppVariables.TotalBalance.toString()).toStringAsFixed(2)} DR"),
            ElevatedButton(
              onPressed: () {},
              child: Text('Export'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primaryBackgroundColor,
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          child: AppBar(
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  _showFilterOptions(context);
                },
                icon: Icon(HugeIcons.strokeRoundedCalendarAdd01),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBackgroundColor,
                        AppColors.tertiaryGrediantColor1.withOpacity(1),
                        AppColors.tertiaryGrediantColor1.withOpacity(1),
                      ],
                      stops: [0.5, 1, 0.5],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(1)),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: cocdTypes.map((cocd) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCocd = cocd;
                            });
                          },
                          child: Text(
                            cocd,
                            style: TextStyle(
                                fontSize: selectedCocd == cocd ? 15 : 13, fontWeight: selectedCocd == cocd ? FontWeight.w800 : FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: LinearBorder(
                              bottom: LinearBorderEdge(
                                size: .67,
                              ),
                              // borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(width: 3, color: selectedCocd == cocd ? AppColors.primaryColor : Colors.transparent),
                            ),
                            elevation: 0,
                            foregroundColor: selectedCocd == cocd ? AppColors.primaryColor : AppColors.primaryColorDark1,
                            backgroundColor: selectedCocd == cocd ? Colors.transparent : Colors.transparent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.primaryBackgroundColor,
            scrolledUnderElevation: 0,
            title: Text('Ledger Report'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            // SingleChildScrollView(
            //   physics: BouncingScrollPhysics(),
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: cocdTypes.map((cocd) {
            //       return Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child: ElevatedButton(
            //           onPressed: () {
            //             setState(() {
            //               selectedCocd = cocd;
            //             });
            //           },
            //           child: Text(cocd),
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5.0),
            //               side: BorderSide(
            //                   color: selectedCocd == cocd
            //                       ? AppColors.primaryColor
            //                       : AppColors.primaryColorDark3),
            //             ),
            //             elevation: 0,
            //             foregroundColor: selectedCocd == cocd
            //                 ? AppColors.primaryColor
            //                 : AppColors.primaryColorDark1,
            //             backgroundColor: selectedCocd == cocd
            //                 ? AppColors.primaryColor.withOpacity(0.1)
            //                 : AppColors.primaryBackgroundColor,
            //           ),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
            Expanded(
              child: FutureBuilder<List<LedgerReportModel>>(
                future: ApiService().fetchLedgerReportDetails(selectedFromDate, selectedTODate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Skeletonizer(
                            child: ListView(
                      children: List.generate(10, (index) {
                        return Container(
                            decoration: BoxDecoration(),
                            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                            child: ListTile(
                              title: Text("datasbfjksd"),
                              subtitle: Text("data"),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("ddsdbsdbsjshfsfjatasnfms"),
                                  Text("datasnfms"),
                                ],
                              ),
                            ));
                      }),
                    )));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Data Available'));
                  } else {
                    final transactions = snapshot.data!;
                    final filteredTransactions = transactions.where((transaction) {
                      final isValidDate = transaction.billDate != '0' && transaction.billDate != null;
                      final isValidAmount = transaction.crAmt != '0' || transaction.drAmt != '0';
                      final matchesCocd = selectedCocd == 'ALL' || selectedCocd == null || transaction.cocd == selectedCocd;
                      final hasNarration = selectedCocd != 'ALL' || transaction.narration != "";
                      final hasASSOCIATEOPENINGBALANCE = selectedCocd != 'ALL' || transaction.narration != "ASSOCIATE OPENING BALANCE";

                      final hasASSOCIATEOPENINGBALANCEBSE_CASH = selectedCocd != 'BSE_CASH' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCENSE_CASH = selectedCocd != 'NSE_CASH' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCECD_NSE = selectedCocd != 'CD_NSE' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCEMF_BSE = selectedCocd != 'MF_BSE' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCENSE_DLY = selectedCocd != 'NSE_DLY' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCENSE_FNO = selectedCocd != 'NSE_FNO' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCENSE_SLBM = selectedCocd != 'NSE_SLBM' || transaction.narration != "ASSOCIATE OPENING BALANCE";
                      final hasASSOCIATEOPENINGBALANCENSE_SLBMMTF = selectedCocd != 'MTF' || transaction.narration != "ASSOCIATE OPENING BALANCE";

                      final hasNarrationss = transaction.narration != "" && transaction.narration.isNotEmpty;

                      return isValidDate &&
                          isValidAmount &&
                          matchesCocd &&
                          hasNarration &&
                          hasNarrationss &&
                          hasASSOCIATEOPENINGBALANCE &&
                          hasASSOCIATEOPENINGBALANCEBSE_CASH &&
                          hasASSOCIATEOPENINGBALANCENSE_CASH &&
                          hasASSOCIATEOPENINGBALANCECD_NSE &&
                          hasASSOCIATEOPENINGBALANCEMF_BSE &&
                          hasASSOCIATEOPENINGBALANCENSE_DLY &&
                          hasASSOCIATEOPENINGBALANCENSE_FNO &&
                          hasASSOCIATEOPENINGBALANCENSE_SLBM &&
                          hasASSOCIATEOPENINGBALANCENSE_SLBMMTF;
                    }).toList();
                    double openingBalanceSum = 0.0;

                    if (selectedCocd == 'ALL') {
                      final openingBalanceTransactions = filteredTransactions.where((transaction) {
                        return transaction.narration.contains('OPENING BALANCE');
                      }).toList();

                      openingBalanceSum = openingBalanceTransactions.fold(
                          0.0, (sum, transaction) => sum + parseDouble(transaction.crAmt) - parseDouble(transaction.drAmt));
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                      ),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => LedgerMoreDetails(transaction: transaction));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        // border:
                                        //     Border.all(color: AppColors.primaryColorDark3.withOpacity(0.5)),
                                        // borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Text(transaction.voucherNo),

                                                Text(
                                                  "${formattedDate(transaction.voucherDate)}",
                                                  style: TextStyle(
                                                    color: AppColors.primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                selectedCocd == "ALL"
                                                    ? Container(
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: AppColors.primaryColorDark3.withOpacity(0.25),
                                                        ),
                                                        child: Text(
                                                          transaction.cocd,
                                                          style: TextStyle(color: AppColors.primaryColor),
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                            Text(
                                              transaction.crAmt == "0" ? "-${parseDouble(transaction.drAmt)}" : "${parseDouble(transaction.crAmt)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: transaction.crAmt == "0" ? AppColors.RedColor : AppColors.GreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                transaction.narration,
                                                style: TextStyle(
                                                  color: AppColors.primaryColorDark2,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            transaction.TOTAL_BALANCE.contains("-")
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors.RedColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        padding: EdgeInsets.all(5),
                                                        child: Text(
                                                          textAlign: TextAlign.center,
                                                          "Dr",
                                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                                        ),
                                                        decoration: BoxDecoration(color: AppColors.RedColor, borderRadius: BorderRadius.circular(10)),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text("${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.green,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        padding: EdgeInsets.all(5),
                                                        child: Text("Cr", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                                        decoration:
                                                            BoxDecoration(color: AppColors.GreenColor, borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [],
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date Range',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('7 Days'),
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
                          _updateDateAndFetchData(sevenDaysAgo, now);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('Previous Day'),
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime previousDay = now.subtract(Duration(days: 1));
                          _updateDateAndFetchData(previousDay, now);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                color: Colors.grey[300]!,
              ),
              Text("Financial Year",
                  style: TextStyle(
                    fontSize: 17,
                  )),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('FY 23-24'),
                        onPressed: () {
                          DateTime startDate = DateTime(2023, 4, 1);
                          DateTime endDate = DateTime(2024, 3, 31);
                          _updateDateAndFetchData(startDate, endDate);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('FY 24-25'),
                        onPressed: () {
                          DateTime startDate = DateTime(2024, 4, 1);
                          DateTime endDate = DateTime(2025, 3, 31);
                          _updateDateAndFetchData(startDate, endDate);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                color: Colors.grey[300]!,
              ),
              Text("Custom Date",
                  style: TextStyle(
                    fontSize: 17,
                  )),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('Custom Date'),
                        onPressed: () async {
                          Navigator.pop(context);
                          DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          if (picked != null) {
                            _updateDateAndFetchData(picked.start, picked.end);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    child: Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            foregroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(Icons.calendar_today),
                        label: Text('Cancel'),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  } // Call this function wherever you change the dates

  void _updateDateAndFetchData(DateTime fromDate, DateTime toDate) {
    setState(() {
      selectedFromDate = DateFormat('dd/MM/yyyy').format(fromDate);
      selectedTODate = DateFormat('dd/MM/yyyy').format(toDate);
    });
    print('Selected dates: $selectedFromDate - $selectedTODate');
    fetchLedgerReport(); // Fetch data again with updated dates
  }

  void _handleFilterSelection(String selection, {DateTime? selectedFromDate, DateTime? selectedTODate}) {
    // Handle the filter selection and fetch data accordingly
    print('Selected filter: $selection');
    setState(() {
      selectedFromDate = selectedFromDate;
      selectedTODate = selectedTODate;
    });
    // Call your API with the selected filter
    // For example:
    // ApiService().fetchLedgerReportDetails(selection);
  }

  Object getTotalBalance(List<LedgerReportModel> filteredTransactions) {
    Object totalBalanced = filteredTransactions.isNotEmpty ? filteredTransactions.last.TOTAL_BALANCE : 0.00;

    AppVariables.TotalBalance = totalBalanced;

    return totalBalanced;
  }

  double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0; // Default value if parsing fails
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
}
