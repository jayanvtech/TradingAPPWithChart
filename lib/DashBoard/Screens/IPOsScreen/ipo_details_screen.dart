import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/apply_ipo_screen.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Utils.text(
              text: "IPO Details",
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Utils.text(
                            text: data?.name ?? "",
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: Colors.deepPurpleAccent.shade700
                                  .withOpacity(0.1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Utils.text(
                              text: data?.ipoType ?? "",
                              color: Colors.deepPurple,
                              fontSize: 09,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(05),
                          border: Border.all(
                              color: Colors.grey.shade800.withOpacity(0.2))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Bid Start Date",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bid End Date",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "${data?.biddingStartDate}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "${data?.biddingEndDate}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Cutoff Price",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Symbol",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: "₹${data?.cutoffPrice}",
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                Utils.text(
                                  text: "${data?.symbol}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Bid Price",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Lot Size",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "₹${data?.minPrice}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "${data?.lotSize} Shares",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Retail Discount",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Issue Size",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "₹${data?.polDiscountPrice}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text:
                                      "₹ ${formatIndianCurrency(totalIssueSize)}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "IPO Type",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "ISIN",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "${data?.ipoType}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "${data?.isin}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Min Bid Quantity",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Min Price",
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "₹${data?.minBidQuantity}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "₹${data?.minPrice}",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Divider(
                                color: Colors.grey.shade800.withOpacity(0.15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Minimum Investment",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "₹$minimumInvestment / 1 Lot",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Maximum Investment",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text:
                                      "₹$maximumInvestment / ${data?.lotSize} Lots",
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Visibility(
                      visible: name == "open IPO",
                      child: InkWell(
                        onTap: () {
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
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),
                          child: Center(
                            child: Utils.text(
                                text: "Apply Now",
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
