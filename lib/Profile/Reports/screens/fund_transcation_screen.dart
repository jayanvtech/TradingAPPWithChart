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

class FundTranscationScreen extends StatefulWidget {
  FundTranscationScreen();

  @override
  _FundTranscationScreenState createState() => _FundTranscationScreenState();
}

class _FundTranscationScreenState extends State<FundTranscationScreen>
    with SingleTickerProviderStateMixin {
  String? selectedCocd = 'ALL';
  var totalBalance;
  var FinalTotalbalance;
  String selectedTODate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedFromDate = DateFormat('dd/MM/yyyy')
      .format(DateTime.now().subtract(Duration(days: 365)));

  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // fetchLedgerReport();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchLedgerReport() async {
    try {
      await ApiService()
          .fetchLedgerReportDetails(selectedFromDate, selectedTODate);
      setState(() {
        // You can handle any additional state updates here if needed
      });
    } catch (error) {
      print('Error fetching ledger report: $error');
    }
  }

  // List<String> cocdTypes = [
  //   'ALL',
  //   'BSE_CASH',
  //   'NSE_CASH',
  //   'CD_NSE',
  //   'MF_BSE',
  //   'NSE_DLY',
  //   'NSE_FNO',
  //   'NSE_SLBM',
  //   'MTF'
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              automaticIndicatorColorAdjustment: true,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Payin'),
                Tab(text: 'Payout'),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterOptions(context);
            },
            icon: Icon(Icons.date_range_outlined),
          ),
        ],
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('Fund Transcation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                FutureBuilder<List<FundtransaferModel>>(
                  future: ApiService().fetchFundTransactionReportDetailsRecipt(
                      selectedFromDate, selectedTODate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Skeletonizer(
                              child: ListView(
                        children: List.generate(10, (index) {
                          return Container(
                              decoration: BoxDecoration(),
                              margin: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
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
                      final filteredTransactions =
                          transactions.where((transaction) {
                        final isValidDate = transaction.billDate != '0' &&
                            transaction.billDate != null;
                        final isValidAmount = transaction.crAmt != '0' ||
                            transaction.drAmt != '0';
                        final matchesCocd = selectedCocd == 'ALL' ||
                            selectedCocd == null ||
                            transaction.cocd == selectedCocd;
                        final hasNarration = selectedCocd != 'ALL' ||
                            transaction.narration != "";
                        final hasASSOCIATEOPENINGBALANCE =
                            selectedCocd != 'ALL' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";

                        final hasASSOCIATEOPENINGBALANCEBSE_CASH =
                            selectedCocd != 'BSE_CASH' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_CASH =
                            selectedCocd != 'NSE_CASH' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCECD_NSE =
                            selectedCocd != 'CD_NSE' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCEMF_BSE =
                            selectedCocd != 'MF_BSE' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_DLY =
                            selectedCocd != 'NSE_DLY' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_FNO =
                            selectedCocd != 'NSE_FNO' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_SLBM =
                            selectedCocd != 'NSE_SLBM' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_SLBMMTF =
                            selectedCocd != 'MTF' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";

                        final hasNarrationss = transaction.narration != "" &&
                            transaction.narration!.isNotEmpty;

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
                        final openingBalanceTransactions =
                            filteredTransactions.where((transaction) {
                          return transaction.narration!
                              .contains('OPENING BALANCE');
                        }).toList();

                        openingBalanceSum = openingBalanceTransactions.fold(
                            0.0,
                            (sum, transaction) =>
                                sum +
                                parseDouble(transaction.crAmt) -
                                parseDouble(transaction.drAmt));
                      }

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];

                          // // Usage
                          //                         Object totalBalance =
                          //                             getTotalBalance(filteredTransactions);

                          print(
                              "=============================Total Balance: $totalBalance");
                          //

                          // setState(() {
                          //   TotalBalance = TotalBalance;
                          // });
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => FunTranscationMoreDetailsScreen(
                                  transaction: transaction));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Text(transaction.voucherNo),

                                                  Text(
                                                    formattedDate(transaction
                                                                .billDate) ==
                                                            "-"
                                                        ? "${formattedDate(transaction.voucherDate)}"
                                                        : "${formattedDate(transaction.billDate)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  selectedCocd == "ALL"
                                                      ? Text(transaction.cocd)
                                                      : Text(""),
                                                ],
                                              ),
                                              Text(
                                                transaction.crAmt == "0"
                                                    ? "-${parseDouble(transaction.drAmt)}"
                                                    : "${parseDouble(transaction.crAmt)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      transaction.crAmt == "0"
                                                          ? Colors.red
                                                          : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  transaction.narration,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // transaction.TOTAL_BALANCE
                                              //         .contains("-")
                                              //     ? Text(
                                              //         "Bal: ${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)} DR",
                                              //         style: TextStyle(
                                              //           color: Colors.red,
                                              //         ),
                                              //       )
                                              //     : Text(
                                              //         "Bal: ${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)} CR",
                                              //         style: TextStyle(
                                              //           color: Colors.green,
                                              //         )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
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
                FutureBuilder<List<FundtransaferModel>>(
                  future: ApiService().fetchFundTransactionReportDetailsPAYout(
                      selectedFromDate, selectedTODate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Skeletonizer(
                              child: ListView(
                        children: List.generate(10, (index) {
                          return Container(
                              decoration: BoxDecoration(),
                              margin: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
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
                      final filteredTransactions =
                          transactions.where((transaction) {
                        final isValidDate = transaction.billDate != '0' &&
                            transaction.billDate != null;
                        final isValidAmount = transaction.crAmt != '0' ||
                            transaction.drAmt != '0';
                        final matchesCocd = selectedCocd == 'ALL' ||
                            selectedCocd == null ||
                            transaction.cocd == selectedCocd;
                        final hasNarration = selectedCocd != 'ALL' ||
                            transaction.narration != "";
                        final hasASSOCIATEOPENINGBALANCE =
                            selectedCocd != 'ALL' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";

                        final hasASSOCIATEOPENINGBALANCEBSE_CASH =
                            selectedCocd != 'BSE_CASH' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_CASH =
                            selectedCocd != 'NSE_CASH' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCECD_NSE =
                            selectedCocd != 'CD_NSE' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCEMF_BSE =
                            selectedCocd != 'MF_BSE' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_DLY =
                            selectedCocd != 'NSE_DLY' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_FNO =
                            selectedCocd != 'NSE_FNO' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_SLBM =
                            selectedCocd != 'NSE_SLBM' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";
                        final hasASSOCIATEOPENINGBALANCENSE_SLBMMTF =
                            selectedCocd != 'MTF' ||
                                transaction.narration !=
                                    "ASSOCIATE OPENING BALANCE";

                        final hasNarrationss = transaction.narration != "" &&
                            transaction.narration!.isNotEmpty;

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
                        final openingBalanceTransactions =
                            filteredTransactions.where((transaction) {
                          return transaction.narration!
                              .contains('OPENING BALANCE');
                        }).toList();

                        openingBalanceSum = openingBalanceTransactions.fold(
                            0.0,
                            (sum, transaction) =>
                                sum +
                                parseDouble(transaction.crAmt) -
                                parseDouble(transaction.drAmt));
                      }

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];

                          // // Usage
                          //                         Object totalBalance =
                          //                             getTotalBalance(filteredTransactions);

                          print(
                              "=============================Total Balance: $totalBalance");
                          //

                          // setState(() {
                          //   TotalBalance = TotalBalance;
                          // });
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => FunTranscationMoreDetailsScreen(
                                  transaction: transaction));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Text(transaction.voucherNo),

                                                  Text(
                                                    formattedDate(transaction
                                                                .billDate) ==
                                                            "-"
                                                        ? "${formattedDate(transaction.voucherDate)}"
                                                        : "${formattedDate(transaction.billDate)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  selectedCocd == "ALL"
                                                      ? Text(transaction.cocd)
                                                      : Text(""),
                                                ],
                                              ),
                                              Text(
                                                transaction.crAmt == "0"
                                                    ? "-${parseDouble(transaction.drAmt)}"
                                                    : "${parseDouble(transaction.crAmt)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      transaction.crAmt == "0"
                                                          ? Colors.red
                                                          : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  transaction.narration,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // transaction.TOTAL_BALANCE
                                              //         .contains("-")
                                              //     ? Text(
                                              //         "Bal: ${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)} DR",
                                              //         style: TextStyle(
                                              //           color: Colors.red,
                                              //         ),
                                              //       )
                                              //     : Text(
                                              //         "Bal: ${double.parse(transaction.TOTAL_BALANCE).toStringAsFixed(2)} CR",
                                              //         style: TextStyle(
                                              //           color: Colors.green,
                                              //         )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
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
              ]),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [],
            color: AppColors.primaryBackgroundColor,
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
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
                        label: Text('7 Days'),
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime sevenDaysAgo =
                              now.subtract(Duration(days: 7));
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
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
                        label: Text('Previous Day'),
                        onPressed: () {
                          DateTime now = DateTime.now();
                          DateTime previousDay =
                              now.subtract(Duration(days: 1));
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
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
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
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
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
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
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
                            backgroundColor:
                                AppColors.primaryColorDark3.withOpacity(0.1),
                            foregroundColor: AppColors.primaryColor1,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0),
                        icon: Icon(HugeIcons.strokeRoundedCalendar03),
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

  void _handleFilterSelection(String selection,
      {DateTime? selectedFromDate, DateTime? selectedTODate}) {
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

  // Object getTotalBalance(List<FundtransaferModel> filteredTransactions) {
  //   Object totalBalanced = filteredTransactions.isNotEmpty
  //       ? filteredTransactions.last.TOTAL_BALANCE
  //       : 0.00;

  //   AppVariables.TotalBalance = totalBalanced;

  //   return totalBalanced;
  // }

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
