import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math; // Import dart:math for the max function
import 'package:tradingapp/DashBoard/Screens/FII/DII/Model/fiiHistoryDataModel.dart';
import 'package:tradingapp/DashBoard/Screens/FII/DII/Model/fiidiimonthlydetails_model.dart';
import 'package:tradingapp/DashBoard/Screens/FII/DII/Model/stocksAndIndexDataModel.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';

class FiiDiiScreen extends StatefulWidget {
  const FiiDiiScreen({Key? key}) : super(key: key);

  @override
  State<FiiDiiScreen> createState() => _FiiDiiScreenState();
}

class _FiiDiiScreenState extends State<FiiDiiScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppColors.blackColor,
        backgroundColor: AppColors.primaryBackgroundColor,
        title: CommonText(
          text: 'Fii Dii Screen',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
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
                  color: AppColors.greyColor.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(1),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.primaryColor,
              controller: _tabController,
              isScrollable: false,
              splashFactory: InkRipple.splashFactory,
              tabAlignment: TabAlignment.fill,
              tabs: [
                Tab(text: 'Cash'),
                Tab(text: 'Future'),
                Tab(text: 'Option'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CashFiiDII(),
          FnOFiiDII(),
          OptionScreen(),
        ],
      ),
    );
  }
}

class CashFiiDII extends StatefulWidget {
  const CashFiiDII({super.key});

  @override
  State<CashFiiDII> createState() => _CashFiiDIIState();
}

class _CashFiiDIIState extends State<CashFiiDII> {
  bool _isDailySelected = true;

  double calculateDecimalPercentage(double finalValue, double secondValue) {
    return (secondValue / finalValue) * 100;
    // return secondValue / finalValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              /// IN Cash Daily & Monthly Buttons ==>
              Row(
                children: [
                  CustomSelectionButton(
                    isSelected: _isDailySelected,
                    text: 'Daily',
                    onPressed: () {
                      setState(() => _isDailySelected = true);
                    },
                  ).paddingOnly(right: 15.w),
                  CustomSelectionButton(
                    isSelected: !_isDailySelected,
                    text: 'Monthly',
                    onPressed: () {
                      setState(() => _isDailySelected = false);
                    },
                  )
                ],
              ),
              _isDailySelected
                  ? Expanded(
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: ApiService().fetchFiiDiiDetails(),
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.hasError)
                              return CommonText(text: 'Error: ${snapshot.error}');
                            else {
                              var data = snapshot.data!.entries.toList();
                              print(data);
                              data.sort((a, b) => b.key.compareTo(a.key)); // sort in descending order
                              return ListView.separated(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  log("$data");

                                  /// Date & FII & DII Text ==>
                                  if (index == 0) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText(
                                          text: 'Date',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        CommonText(
                                          text: 'FII',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        CommonText(
                                          text: 'DII',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ).paddingAll(8);
                                  } else {
                                    var itemIndex = index - 1;
                                    var date = data[itemIndex].key;
                                    var inputFormat = DateFormat('yyyy-MM-dd');
                                    var inputDate = inputFormat.parse(date);
                                    var outputFormat = DateFormat('dd MMM yyyy');
                                    var outputDate = outputFormat.format(inputDate);
                                    var fiiDifference = data[itemIndex].value['fii_buy_sell_difference'];
                                    var diiDifference = data[itemIndex].value['dii_buy_sell_difference'];
                                    bool isNegative = fiiDifference.toString().startsWith('-');
                                    bool isNegative2 = diiDifference.toString().startsWith('-');
                                    log('fiiDifference :: ${fiiDifference}');

                                    /// Date & FII & DII Data's ==>
                                    return Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CommonText(
                                                  text: _isDailySelected ? outputDate : date,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    CommonText(
                                                      text: fiiDifference.toStringAsFixed(2),
                                                      color: isNegative ? AppColors.RedColor : AppColors.GreenColor,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    CommonText(
                                                      text: diiDifference.toStringAsFixed(2),
                                                      color: isNegative2 ? AppColors.RedColor : AppColors.GreenColor,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ).paddingSymmetric(vertical: 15),

                                        /// Progress Bar ==>
                                        Row(
                                          children: [
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.only(right: 10),
                                              width: 100,
                                              height: 3,
                                              child: LineWidthExample(
                                                value: fiiDifference,
                                                lineColor: isNegative ? AppColors.RedColor : AppColors.GreenColor,
                                              ),
                                            ).paddingOnly(right: 5),
                                            Container(
                                              height: 3,
                                              width: 100,
                                              child: LineWidthExample(
                                                value: diiDifference,
                                                lineColor: isNegative2 ? AppColors.RedColor : AppColors.GreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                                separatorBuilder: (BuildContext context, int index) => Divider(height: 0, color: AppColors.greyColor300),
                              ).paddingAll(10);
                            }
                          }
                        },
                      ),
                    )
                  : Expanded(
                      child: FutureBuilder<List<FiiDiiDetails>>(
                        future: ApiService().fetchFiiDiiDetailsMonthly(type: "cash").then((data) {
                          final parsedData = (data)['result'] as List<dynamic>;
                          return parsedData.map((item) => FiiDiiDetails.fromJson(item)).toList();
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            final fiiDiiDetails = snapshot.data!;
                            return ListView.separated(
                              itemCount: fiiDiiDetails.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        text: 'Date',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CommonText(
                                        text: 'FII',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CommonText(
                                        text: 'DII',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ).paddingAll(8);
                                } else {
                                  final detail = fiiDiiDetails[index - 1];
                                  final isNegativeFii = detail.cashFiiNetPurchaseSales.startsWith('-');
                                  final isNegativeDii = detail.cashDiiNetPurchaseSales.startsWith('-');
                                  double decimalPercentage =
                                      calculateDecimalPercentage(10000, double.parse(detail.cashFiiNetPurchaseSales.replaceAll('-', '')));
                                  log('decimalPercentage :: ${decimalPercentage}');
                                  DateTime inputDate = DateFormat('MMMM yyyy').parse(detail.cashDate);
                                  String formattedDate = DateFormat('MMM yyyy').format(inputDate);
                                  return Column(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CommonText(
                                                text: formattedDate,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  CommonText(
                                                    text: detail.cashFiiNetPurchaseSales,
                                                    color: isNegativeFii ? AppColors.RedColor : AppColors.GreenColor,
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  CommonText(
                                                    text: detail.cashDiiNetPurchaseSales,
                                                    color: isNegativeDii ? AppColors.RedColor : AppColors.GreenColor,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ).paddingSymmetric(vertical: 15),

                                      /// Progress Bar ==>
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            padding: EdgeInsets.only(right: 10),
                                            width: 100,
                                            height: 2,
                                            child: LineWidthExample(
                                              value: decimalPercentage,
                                              lineColor: isNegativeFii ? AppColors.RedColor : AppColors.GreenColor,
                                            ),
                                          ).paddingOnly(right: 5),
                                          Container(
                                            height: 3,
                                            width: 100,
                                            child: LineWidthExample(
                                              value: double.parse(detail.cashDiiNetPurchaseSales),
                                              lineColor: isNegativeDii ? AppColors.RedColor : AppColors.GreenColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }
                              },
                              separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
                            ).paddingAll(10);
                          }
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class FnOFiiDII extends StatefulWidget {
  const FnOFiiDII({super.key});

  @override
  State<FnOFiiDII> createState() => _FnOFiiDIIState();
}

class _FnOFiiDIIState extends State<FnOFiiDII> {
  bool _isDailySelected = true;
  int isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      persistentFooterButtons: [
        Visibility(
          visible: !_isDailySelected,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomSelectionButton(
                isSelected: isSelected == 0,
                text: 'Stock',
                onPressed: () {
                  setState(() {
                    isSelected = 0;
                  });
                },
              ),
              CustomSelectionButton(
                isSelected: isSelected == 1,
                text: 'Index',
                onPressed: () {
                  setState(() {
                    isSelected = 1;
                  });
                },
              )
            ],
          ),
        )
      ],
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  CustomSelectionButton(
                    isSelected: _isDailySelected,
                    text: 'Daily',
                    onPressed: () {
                      setState(() {
                        _isDailySelected = true;
                      });
                    },
                  ).paddingOnly(right: 15.w),
                  CustomSelectionButton(
                    isSelected: !_isDailySelected,
                    text: 'Monthly',
                    onPressed: () {
                      setState(() {
                        _isDailySelected = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            _isDailySelected
                ? Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: ApiService().fetchFiiDiiDetails(),
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasError)
                            return CommonText(text: 'Error: ${snapshot.error}');
                          else {
                            var data = snapshot.data!.entries.toList();
                            data.sort((a, b) => b.key.compareTo(a.key)); // sort in descending order

                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.separated(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                            text: 'Date',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CommonText(
                                            text: 'Net Purchase/Sale',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    var itemIndex = index - 1;
                                    var date = data[itemIndex].key;
                                    var inputFormat = DateFormat('yyyy-MM-dd');
                                    var inputDate = inputFormat.parse(date);
                                    var outputFormat = DateFormat('dd MMM yyyy');
                                    var outputDate = outputFormat.format(inputDate);
                                    var fiiDifference = data[itemIndex].value['fii_buy_sell_difference'];
                                    var diiDifference = data[itemIndex].value['dii_buy_sell_difference'];
                                    var diiFnOAmountWise = data[itemIndex].value['dii_fnoDii_amount_wise'];
                                    bool isNegative = fiiDifference.toString().startsWith('-');
                                    bool isNegative2 = diiDifference.toString().startsWith('-');
                                    bool isNegative3 = diiFnOAmountWise.toString().startsWith('-');

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                CommonText(
                                                  text: outputDate,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                CommonText(
                                                  text: diiFnOAmountWise.toStringAsFixed(2),
                                                  color: isNegative3 ? Colors.red : Colors.green,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(vertical: 15);
                                  }
                                },
                                separatorBuilder: (BuildContext context, int index) => Divider(height: 0, color: AppColors.greyColor300),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: FutureBuilder<List<FiiData>>(
                      future: isSelected == 0
                          ? ApiService().fetchStockAndIndexData(type: "fo_stocks")
                          : ApiService().fetchStockAndIndexData(type: "fo_index"),
                      builder: (BuildContext context, AsyncSnapshot<List<FiiData>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: CommonText(text: 'No data available'));
                        } else {
                          var data = snapshot.data!;
                          return ListView.separated(
                            itemCount: data.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      text: 'Date',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CommonText(
                                      text: 'Net Purchase/Sale (Fut)',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ).paddingAll(8);
                              } else {
                                var itemIndex = index - 1;
                                var fiiData = data[itemIndex];

                                // var inputFormat = DateFormat('yyyy-MM-dd');
                                // var inputDate = inputFormat.parse(fiiData.foDate);
                                //
                                // var outputFormat = DateFormat('dd MMM yyyy');
                                // var outputDate = outputFormat.format(inputDate);

                                bool isNegative3 = fiiData.fiiNetPurchaseSalesFut.toString().startsWith('-');

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CommonText(
                                              text: fiiData.foDate,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CommonText(
                                              text: fiiData.fiiNetPurchaseSalesFut,
                                              color: isNegative3 ? AppColors.RedColor : AppColors.GreenColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 15);
                              }
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(height: 0, color: AppColors.greyColor300),
                          ).paddingAll(10);
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  bool _isDailySelected = true;
  int isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      persistentFooterButtons: [
        Visibility(
          visible: !_isDailySelected,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomSelectionButton(
                isSelected: isSelected == 0,
                text: 'Stock',
                onPressed: () {
                  setState(() {
                    isSelected = 0;
                  });
                },
              ),
              CustomSelectionButton(
                isSelected: isSelected == 1,
                text: 'Index',
                onPressed: () {
                  setState(() {
                    isSelected = 1;
                  });
                },
              ),
            ],
          ),
        )
      ],
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                CustomSelectionButton(
                  isSelected: _isDailySelected,
                  text: 'Daily',
                  onPressed: () {
                    setState(() => _isDailySelected = true);
                  },
                ).paddingOnly(right: 15.w),
                CustomSelectionButton(
                  isSelected: !_isDailySelected,
                  text: 'Monthly',
                  onPressed: () {
                    setState(() => _isDailySelected = false);
                  },
                ),
              ],
            ),
            _isDailySelected
                ? Expanded(
                    child: FutureBuilder<FiiHistoryData>(
                      future: ApiService().fetchFiiDiiDetails1(),
                      builder: (BuildContext context, AsyncSnapshot<FiiHistoryData> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasError)
                            return CommonText(text: 'Error: ${snapshot.error}');
                          else {
                            var data = snapshot.data!.success.data.entries.toList();
                            data.sort((a, b) => b.key.compareTo(a.key)); // sort in descending order

                            return ListView.separated(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(text: 'Date', fontWeight: FontWeight.bold),
                                      CommonText(text: 'Call', fontWeight: FontWeight.bold),
                                      CommonText(text: 'Put', fontWeight: FontWeight.bold),
                                    ],
                                  ).paddingAll(8);
                                } else {
                                  var itemIndex = index - 1;
                                  var date = data[itemIndex].key;
                                  var inputFormat = DateFormat('yyyy-MM-dd');
                                  var inputDate = inputFormat.parse(date);
                                  var outputFormat = DateFormat('dd MMM yyyy');
                                  var outputDate = outputFormat.format(inputDate);
                                  var Call = data[itemIndex].value.option.fii.call.netOiChange;
                                  var Put = data[itemIndex].value.option.fii.put.netOiChange;
                                  bool isNegative1 = Call.toString().startsWith('-');
                                  bool isNegative2 = Put.toString().startsWith('-');
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              CommonText(
                                                text: outputDate,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CommonText(
                                                text: Call.toStringAsFixed(2),
                                                color: isNegative1 ? AppColors.RedColor : AppColors.GreenColor,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CommonText(
                                                text: Put.toStringAsFixed(2),
                                                color: isNegative2 ? AppColors.RedColor : AppColors.GreenColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 15);
                                }
                              },
                              separatorBuilder: (BuildContext context, int index) => Divider(height: 0, color: AppColors.greyColor300),
                            ).paddingAll(10);
                          }
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: FutureBuilder<List<FiiData>>(
                      future: isSelected == 0
                          ? ApiService().fetchStockAndIndexData(type: "fo_stocks")
                          : ApiService().fetchStockAndIndexData(type: "fo_index"),
                      builder: (BuildContext context, AsyncSnapshot<List<FiiData>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: CommonText(text: 'No data available'));
                        } else {
                          var data = snapshot.data!;
                          return ListView.separated(
                            itemCount: data.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      text: 'Date',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CommonText(
                                      text: 'Net Purchase/Sale (Fut)',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ).paddingAll(8);
                              } else {
                                var itemIndex = index - 1;
                                var fiiData = data[itemIndex];

                                // var inputFormat = DateFormat('yyyy-MM-dd');
                                // var inputDate = inputFormat.parse(fiiData.foDate);
                                //
                                // var outputFormat = DateFormat('dd MMM yyyy');
                                // var outputDate = outputFormat.format(inputDate);

                                bool isNegative3 = fiiData.fiiNetPurchaseSalesFut.toString().startsWith('-');

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CommonText(
                                              text: fiiData.foDate,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CommonText(
                                              text: fiiData.fiiNetPurchaseSalesOp,
                                              color: isNegative3 ? AppColors.RedColor : AppColors.GreenColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 15);
                              }
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(height: 0, color: AppColors.greyColor300),
                          ).paddingAll(10);
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class LineWidthExample extends StatelessWidget {
  final double value; // This is your value
  final double maxValue = 10000; // This is the value to compare against
  final double maxLineWidth = 100; // Maximum line width
// The Y value at which the line should be drawn
  final Color lineColor; // Color of the line
  final double strokeWidth; // Thickness of the line

  LineWidthExample({
    required this.value,
    this.lineColor = Colors.red,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    double ratio = value / maxValue;
    double lineWidth = math.max(0, maxLineWidth * ratio);

    return Center(
      child: Container(
        width: lineWidth,
        // Fixed height for the line
        color: lineColor, // Line color
      ),
    );
  }
}
