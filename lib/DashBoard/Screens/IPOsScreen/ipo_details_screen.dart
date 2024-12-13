import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/apply_ipo_screen.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';
import 'package:tradingapp/Utils/utils.dart';

class IPODetailsScreen extends StatefulWidget {
  const IPODetailsScreen({super.key});

  @override
  State<IPODetailsScreen> createState() => _IPODetailsScreenState();
}

class _IPODetailsScreenState extends State<IPODetailsScreen> {
  dynamic arguments = Get.arguments;
  String name = "";
  IpoDetails? data;
  int issueSize = 0;
  double minPriceValue = 0.0;
  double totalIssueSize = 0.0;

  int minBidQty = 0;
  double minPriceValue1 = 0.0;
  double minimumInvestment = 0.0;

  int maxBidQty = 0;
  double maxPriceValue = 0.0;
  double maximumInvestment = 0.0;

  @override
  void initState() {
    super.initState();

    name = arguments["name"];
    data = arguments['data'];
    int issueSize = int.parse(data?.issueSize ?? "");
    minPriceValue = double.parse(data?.cutoffPrice ?? "");
    totalIssueSize = issueSize * minPriceValue;

    minBidQty = int.parse(data?.minBidQuantity ?? "");
    minPriceValue1 = double.parse(data?.minPrice ?? "");
    minimumInvestment = minBidQty * minPriceValue1;

    maxBidQty = int.parse(data?.minBidQuantity ?? "");
    maxPriceValue = double.parse(data?.cutoffPrice ?? "");
    maximumInvestment = minBidQty * maxPriceValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: buildBoxDecoration(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          text: data?.name ?? "",
                          color: AppColors.blackColor,
                          fontSize: 16,
                          maxLines: 2,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.deepPurpleAccentColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
                          child: CommonText(
                            text: data?.ipoType ?? "",
                            color: Colors.deepPurple,
                            fontSize: 09,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.deepPurpleAccentColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          child: CommonText(
                            text: data?.bse == 'Y' ? 'BSE' : 'NSE',
                            color: Colors.deepPurple,
                            fontSize: 09,
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 10),
                      if (data?.bse == 'Y' && data?.nse == 'Y')
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: AppColors.deepPurpleAccentColor.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            child: CommonText(
                              text: 'NSE',
                              color: Colors.deepPurple,
                              fontSize: 09,
                            ),
                          ),
                        )
                    ],
                  ),
                  Divider(height: 15, color: AppColors.greyColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: 'Bid Range',
                            color: AppColors.greyColor,
                          ),
                          CommonText(
                            text: '₹ ${data?.minPrice} - ₹ ${data?.cutoffPrice}',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonText(
                            text: 'Issue Size',
                            color: AppColors.greyColor,
                          ),
                          CommonText(
                            text: "₹ ${formatIndianCurrency(totalIssueSize)}",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: 'Min Investment',
                            color: AppColors.greyColor,
                          ),
                          CommonText(
                            text: '₹ ${minimumInvestment}',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonText(
                            text: 'Max Investment',
                            color: AppColors.greyColor,
                          ),
                          CommonText(
                            text: "₹ ${formatIndianCurrency(totalIssueSize)}",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CommonText(
              text: 'IPO Issue Details',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: buildBoxDecoration(),
              child: Column(
                children: [
                  buildIPOIssueDetails(title: 'Bid Open Date', value: '${data?.biddingStartDate}, 10:00 AM'),
                  buildDivider().paddingSymmetric(horizontal: 5),
                  buildIPOIssueDetails(title: 'Bid Clos Date', value: '${data?.biddingEndDate}, 05:00 PM'),
                  buildDivider().paddingSymmetric(horizontal: 5),
                  buildIPOIssueDetails(title: 'IPO Issue Size', value: '₹ ${formatIndianCurrency(totalIssueSize)}'),
                  buildDivider().paddingSymmetric(horizontal: 5),
                  buildIPOIssueDetails(title: 'Bid Price Range', value: '₹ ${data?.minPrice} - ₹ ${data?.cutoffPrice}'),
                  buildDivider().paddingSymmetric(horizontal: 5),
                  buildIPOIssueDetails(title: 'Min Lot Size', value: '${data?.minBidQuantity} Shares'),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              isLoading: false,
              text: 'Apply',
              onPressed: () {
                Get.to(
                  const Applyiposcreen(),
                  arguments: ({
                    "name": data?.name,
                    "bidPrice": data?.cutoffPrice,
                    "maxValue": double.parse(data?.cutoffPrice ?? ""),
                    "minValue": double.parse(data?.minPrice ?? ""),
                    "lotSize": double.parse(data?.lotSize ?? ""),
                    "categories": data?.categories,
                    "symbol": data?.symbol
                  }),
                );
              },
            )
          ],
        ).paddingSymmetric(horizontal: 15),
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      height: 20,
      color: AppColors.greyColor.withOpacity(0.5),
    );
  }

  Widget buildIPOIssueDetails({String title = '', String value = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: title,
          // color: AppColors.greyColor,
        ),
        CommonText(
          text: value,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
      borderRadius: BorderRadius.circular(10),
      color: AppColors.primaryBackgroundColor,
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
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 2,
      scrolledUnderElevation: 2,
      shadowColor: AppColors.blackColor,
      title: CommonText(
        text: "IPO Details",
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  String formatIndianCurrency(double amount) {
    if (amount >= 1e7) {
      double crore = amount / 1e7;
      return '${crore.toStringAsFixed(2)} Cr';
    } else if (amount >= 1e5) {
      double lakh = amount / 1e5;
      return '${lakh.toStringAsFixed(2)} Lakh';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}
