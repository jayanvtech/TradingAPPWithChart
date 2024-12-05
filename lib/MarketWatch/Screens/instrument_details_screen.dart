// ignore_for_file: unnecessary_import

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/model/corporate_info_model.dart';
import 'package:tradingapp/MarketWatch/Provider/corporate_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InstrumentDetailsScreen extends StatefulWidget {
  final ExchangeInstrumentID;
  final displayname;
  final ExchangeInstrumentName;
  const InstrumentDetailsScreen(
      {Key? key,
      this.ExchangeInstrumentID,
      this.ExchangeInstrumentName,
      required this.displayname})
      : super(key: key);

  @override
  State<InstrumentDetailsScreen> createState() =>
      _InstrumentDetailsScreenState();
}

class _InstrumentDetailsScreenState extends State<InstrumentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.displayname),backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white!),
            child: Expanded(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: CorporateInfoPage(
                        ExchangeInstrumentID: widget.ExchangeInstrumentID,
                        displayname: widget.displayname,
                        ExchangeInstrumentName: widget.ExchangeInstrumentName,
                      )),
                  // Container(
                  //     padding: EdgeInsets.all(1),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5),
                  //       color: Colors.white,
                  //     ),
                  //     child: Expanded(
                  //       child: Column(
                  //         children: [
                  //           // Row(
                  //           //   children: [
                  //           //     Container(
                  //           //         height: 40,
                  //           //         width: 40,
                  //           //         decoration: BoxDecoration(
                  //           //           borderRadius: BorderRadius.circular(10),
                  //           //           color: Colors.green.withOpacity(0.2),
                  //           //         ),
                  //           //         child: Center(
                  //           //             child: Icon(Icons.trending_up_rounded))),
                  //           //     SizedBox(
                  //           //       width: 10,
                  //           //     ),
                  //           //     Column(
                  //           //       mainAxisAlignment: MainAxisAlignment.center,
                  //           //       crossAxisAlignment: CrossAxisAlignment.start,
                  //           //       children: [
                  //           //         Text("Overall Gain"),
                  //           //         Row(
                  //           //           children: [Text("3.10"), Text("(10.00%)")],
                  //           //         )
                  //           //       ],
                  //           //     ),
                  //           //   ],
                  //           // ),
                  //         ],
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     padding: EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white,
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Container(
                  //               width: MediaQuery.of(context).size.width * 0.4,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.white,
                  //               ),
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text("Invested"),
                  //                   Text("₹5000"),
                  //                 ],
                  //               ),
                  //             ),
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: [
                  //                 Text("Market Value"),
                  //                 Text("₹5000"),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //         Container(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text("Qantity"),
                  //                   Text("700"),
                  //                 ],
                  //               ),
                  //               Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   Text("ATP"),
                  //                   Text("₹902"),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     )),

                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //     child: Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           padding: EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.white,
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text("Today's Gain"),
                  //                   Row(
                  //                     children: [
                  //                       Text("₹5000"),
                  //                       Text("(1.0%)"),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //               Text("data")
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.white,
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text("Indian Rail Tour Corp Ltd"),
                  //           GestureDetector(
                  //             onTap: () {},
                  //             child: Row(
                  //               children: [
                  //                 Text("Stock Details"),
                  //                 SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 Icon(
                  //                   Icons.arrow_forward_ios,
                  //                   size: 12,
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey[300]!),
                  //           shape: BoxShape.rectangle,
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: [
                  //                   Text("Open"),
                  //                   Text("1124"),
                  //                 ],
                  //               ),
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: [
                  //                   Text("High"),
                  //                   Text("1124"),
                  //                 ],
                  //               ),
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: [
                  //                   Text("Low"),
                  //                   Text("1124"),
                  //                 ],
                  //               ),
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: [
                  //                   Text("Prev Close"),
                  //                   Text("1124"),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text("Average traded Price"),
                  //               Text("1124"),
                  //             ],
                  //           ),
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text("Volume"),
                  //               Text("17.90 L"),
                  //             ],
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.white,
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Center(
                  //           child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(Icons.bar_chart),
                  //           SizedBox(
                  //             width: 10,
                  //           ),
                  //           Text("View Chart", style: TextStyle()),
                  //         ],
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Expanded(child: Container(
                  //   height: 100,
                  // ),),
                  // Container(
                  //   height: 60,
                  //   width: double.infinity,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           height: 50,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.green,
                  //           ),
                  //           child: Center(
                  //               child: Text("BUY",
                  //                   style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 18))),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           height: 50,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.red,
                  //           ),
                  //           child: Center(
                  //               child: Text("SELL",
                  //                   style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 18))),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )),
      ),
    );
  }
}

class CorporateInfoPage extends StatefulWidget {
  final ExchangeInstrumentID;
  final displayname;
  final ExchangeInstrumentName;

  const CorporateInfoPage(
      {super.key,
      this.ExchangeInstrumentID,
      this.ExchangeInstrumentName,
      this.displayname});
  @override
  _IRCTCPageState createState() => _IRCTCPageState();
}

class _IRCTCPageState extends State<CorporateInfoPage> {
  late Future<IRCTCData?> futureIRCTCData;
  Map<int, bool> _isExpanded = {};

  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    futureIRCTCData = ApiService().fetchIRCTCData(widget.displayname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<IRCTCData?>(
        future: futureIRCTCData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            IRCTCData data = snapshot.data!;

            return ListView(
              children: [
                ListTile(
                  title: Text('Latest Announcements'),
                  subtitle: data.latestAnnouncements.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.latestAnnouncements
                              .map((announcement) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            announcement.broadcastDate,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(announcement.subject),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : Text('No data'),
                ),
                ListTile(
                  title: Text('Corporate Actions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: data.corporateActions.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.corporateActions
                              .map((action) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.all(10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            action.exDate,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            action.purpose,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : Text('No data'),
                ),
                ListTile(
                  title: Text('Shareholding Patterns'),
                  subtitle: Text(data.shareholdingPatterns.keys.isNotEmpty
                      ? data.shareholdingPatterns.keys.first
                      : 'No data'),
                ),
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Shareholding Patterns'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries>[
                    LineSeries<ShareholdingPattern, String>(
                      enableTooltip: true,
                      dataSource: data.shareholdingPatterns.entries
                          .expand((entry) =>
                              entry.value.map((pattern) => ShareholdingPattern(
                                    key: entry.key,
                                    category: pattern.category,
                                    percentage: pattern.percentage,
                                  )))
                          .toList(),
                      xValueMapper: (ShareholdingPattern data, _) => data.key,
                      yValueMapper: (ShareholdingPattern data, _) =>
                          double.parse(data.percentage),
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      name: 's',
                      width: 2,
                      color: Colors.blue, // Customize color
                    ),
                    // Add more LineSeries for other categories
                  ],
                ),
                SfCircularChart(
                  title: ChartTitle(text: 'Shareholding Patterns'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries>[
                    PieSeries<ShareholdingPattern, String>(
                      dataSource: data.shareholdingPatterns.entries
                          .expand((entry) =>
                              entry.value.map((pattern) => ShareholdingPattern(
                                    key: entry.key,
                                    category: pattern.category,
                                    percentage: pattern.percentage,
                                  )))
                          .toList(),
                      xValueMapper: (ShareholdingPattern data, _) =>
                          data.category,
                      yValueMapper: (ShareholdingPattern data, _) =>
                          double.parse(data.percentage),
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      name: 'Shareholding',
                    ),
                  ],
                ),
                ListTile(
                  title: Text('Board Meetings'),
                  subtitle: Text(data.boardMeetings.isNotEmpty
                      ? data.boardMeetings[0].meetingDate
                      : 'No data'),
                ),
                ListTile(
                  title: Text('Finacial Results',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: data.financialResults.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.financialResults
                              .map((action) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      height: 85,
                                      padding: EdgeInsets.all(10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("From: "),
                                                  Text(
                                                    action.fromDate,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("To: "),
                                                  Text(
                                                    action.toDate,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Income: "),
                                                  Text(
                                                    action.income,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Expenditure: "),
                                                  Text(
                                                    action.expenditure,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("audited: "),
                                                  Text(
                                                    action.audited,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    launch(
                                                      action.naAttachment
                                                          .toString(),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Download PDF",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : Text('No data'),
                ),
                ListTile(
                  title: Text('Board Meetings'),
                  subtitle: data.boardMeetings.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                data.boardMeetings.asMap().entries.map((entry) {
                              int index = entry.key;
                              var action = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isExpanded[index] =
                                                !(_isExpanded[index] ?? false);
                                          });
                                        },
                                        child: Text(
                                          action.meetingDate,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _isExpanded[index] ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(action.purpose),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : Text('No data'),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
