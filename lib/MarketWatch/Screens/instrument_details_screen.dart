import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/model/corporate_info_model.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/instrument_details_common_card.dart';
import 'package:url_launcher/url_launcher.dart';

class InstrumentDetailsScreen extends StatefulWidget {
  final ExchangeInstrumentID;
  final displayname;
  final ExchangeInstrumentName;

  const InstrumentDetailsScreen({Key? key, this.ExchangeInstrumentID, this.ExchangeInstrumentName, required this.displayname}) : super(key: key);

  @override
  State<InstrumentDetailsScreen> createState() => _InstrumentDetailsScreenState();
}

class _InstrumentDetailsScreenState extends State<InstrumentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(text: widget.displayname),
        backgroundColor: AppColors.primaryBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: CorporateInfoPage(
        ExchangeInstrumentID: widget.ExchangeInstrumentID,
        displayname: widget.displayname,
        ExchangeInstrumentName: widget.ExchangeInstrumentName,
      ),
    );
  }
}

class CorporateInfoPage extends StatefulWidget {
  final ExchangeInstrumentID;
  final displayname;
  final ExchangeInstrumentName;

  const CorporateInfoPage({super.key, this.ExchangeInstrumentID, this.ExchangeInstrumentName, this.displayname});

  @override
  _IRCTCPageState createState() => _IRCTCPageState();
}

class _IRCTCPageState extends State<CorporateInfoPage> {
  late Future<StockCorporateDetailModel?> futureIRCTCData;
  Map<int, bool> _isExpanded = {};

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    futureIRCTCData = ApiService().getCorporateStockDetailsData(widget.displayname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: FutureBuilder<StockCorporateDetailModel?>(
        future: futureIRCTCData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: CommonText(text: 'Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            StockCorporateDetailModel data = snapshot.data!;

            /// filter Year For Corporate Action
            Map<String, List<CorporateAction>> groupEventsByYear() {
              Map<String, List<CorporateAction>> groupedEvents = {};
              for (var event in data.corporateActions) {
                final year = event.exDate.split('-').last;
                if (!groupedEvents.containsKey(year)) {
                  groupedEvents[year] = [];
                }
                groupedEvents[year]!.add(event);
              }
              return groupedEvents;
            }

            final groupedEvents = groupEventsByYear();
            final years = groupedEvents.keys.toList();

            /// filter Yer for Latest Announcements
            Map<String, List<Announcement>> groupEventsByYearLatestAnnouncements() {
              final Map<String, List<Announcement>> groupedEvents = {};
              for (var event in data.latestAnnouncements) {
                final year = event.broadcastDate.split('-').last.split(' ').first;
                if (!groupedEvents.containsKey(year)) {
                  groupedEvents[year] = [];
                }
                groupedEvents[year]?.add(event);
              }
              return groupedEvents;
            }

            final groupedEventsAnnouncements = groupEventsByYearLatestAnnouncements();
            final yearsAnnouncements = groupedEventsAnnouncements.keys.toList();

            return ListView(
              children: [
                /// Latest Announcements View ==>
                if (data.latestAnnouncements.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: 'Latest Announcements',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          CommonText(text: 'View All', fontSize: 14.sp),
                        ],
                      ).paddingSymmetric(vertical: 10.h),
                      /* ...List.generate(
                        4,
                        (index) {
                          var element = data.latestAnnouncements[index];
                          DateTime parsedDate = DateFormat("dd-MMM-yyyy HH:mm:ss").parse(element.broadcastDate);
                          String formattedDate = DateFormat("d MMM").format(parsedDate);
                          return CustomDetailsCard(
                            title: element.subject,
                            onTap: () {},
                            leadingText: formattedDate,
                            isShowLeadingText: true,
                            padding: element.subject.length < 35 ? EdgeInsets.all(20) : null,
                          ).paddingOnly(bottom: 10.h);
                        },
                      ),*/

                      ///
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: yearsAnnouncements.length,
                        // itemCount: yearsAnnouncements.length,
                        itemBuilder: (context, index) {
                          final year = yearsAnnouncements[index];
                          final yearAnnouncements = groupedEventsAnnouncements[year]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: year,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ).paddingOnly(bottom: 8.h, left: 5.w),
                              ...List.generate(
                                yearAnnouncements.length,
                                (eventIndex) {
                                  final element = yearAnnouncements[eventIndex];
                                  DateTime date = DateFormat("dd-MMM-yyyy").parse(element.broadcastDate ?? '');
                                  String formattedDate = DateFormat("dd\nMMM").format(date);
                                  return CustomDetailsCard(
                                    padding: EdgeInsets.all(20),
                                    title: element.subject,
                                    onTap: () {},
                                    leadingText: formattedDate,
                                    isShowLeadingText: true,
                                  ).paddingOnly(bottom: 10.h);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15.w),

                /// Corporate Actions View ==>
                if (data.corporateActions.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: 'Corporate Actions',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          CommonText(text: 'View All', fontSize: 14.sp),
                        ],
                      ).paddingSymmetric(vertical: 10.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        // itemCount: years.length,
                        itemBuilder: (context, index) {
                          final year = years[index];
                          final yearEvents = groupedEvents[year]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: year,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ).paddingOnly(bottom: 8.h, left: 5.w),
                              ...List.generate(
                                yearEvents.length,
                                (eventIndex) {
                                  final element = yearEvents[eventIndex];
                                  DateTime date = DateFormat("dd-MMM-yyyy").parse(element.exDate);
                                  String formattedDate = DateFormat("dd\nMMM").format(date);
                                  return CustomDetailsCard(
                                    padding: EdgeInsets.all(20),
                                    title: element.purpose,
                                    onTap: () {},
                                    leadingText: formattedDate,
                                    isShowLeadingText: true,
                                  ).paddingOnly(bottom: 10.h);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15.w),

                CommonText(
                  text: 'Shareholdings Patterns',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ).paddingOnly(left: 15.w),

                /// Share holding pattern chart ==>
                Container(
                  height: 170,
                  child: buildShareholdingPatternChart(
                    promoter: double.parse(data.shareholdingPatterns.entries.first.value.first.percentage),
                    public: double.parse(data.shareholdingPatterns.entries.first.value[1].percentage),
                    shareByEmployee: double.parse(data.shareholdingPatterns.entries.first.value[2].percentage),
                  ),
                ),
                if (data.financialResults.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: 'Financial Results',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ).paddingOnly(left: 15.w),
                      ...List.generate(
                        data.financialResults.length,
                        (index) {
                          var element = data.financialResults[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
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
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CommonText(
                                          text: element.fromDate,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonText(text: "To").paddingSymmetric(horizontal: 8),
                                        CommonText(
                                          text: element.toDate,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CommonText(text: "Income:- "),
                                        CommonText(
                                          text: element.income,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonText(text: "Expenditure:-"),
                                        CommonText(
                                          text: element.expenditure,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CommonText(text: "audited:- "),
                                        CommonText(
                                          text: element.audited,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launch(
                                          element.naAttachment.toString(),
                                        );
                                      },
                                      child: CommonText(
                                        text: "Download PDF",
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),

                /// financial
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: data.financialResults
                //       .map(
                //         (action) => Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 4.0),
                //           child: Container(
                //             height: 85,
                //             padding: EdgeInsets.all(10),
                //             width: double.infinity,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5), color: Colors.white),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Row(
                //                       children: [
                //                         Text("From: "),
                //                         Text(
                //                           action.fromDate,
                //                           style: TextStyle(fontWeight: FontWeight.normal),
                //                         ),
                //                       ],
                //                     ),
                //                     Row(
                //                       children: [
                //                         Text("To: "),
                //                         Text(
                //                           action.toDate,
                //                           overflow: TextOverflow.ellipsis,
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Row(
                //                       children: [
                //                         Text("Income: "),
                //                         Text(
                //                           action.income,
                //                           style: TextStyle(fontWeight: FontWeight.normal),
                //                         ),
                //                       ],
                //                     ),
                //                     Row(
                //                       children: [
                //                         Text("Expenditure: "),
                //                         Text(
                //                           action.expenditure,
                //                           overflow: TextOverflow.ellipsis,
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Row(
                //                       children: [
                //                         Text("audited: "),
                //                         Text(
                //                           action.audited,
                //                           overflow: TextOverflow.ellipsis,
                //                         ),
                //                       ],
                //                     ),
                //                     InkWell(
                //                       onTap: () {
                //                         launch(
                //                           action.naAttachment.toString(),
                //                         );
                //                       },
                //                       child: Text(
                //                         "Download PDF",
                //                         style: TextStyle(color: Colors.blue),
                //                       ),
                //                     ),
                //                   ],
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //       .toList(),
                // ).paddingSymmetric(horizontal: 15.w),
                /*ListTile(
                  title: Text('Financial Results', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: data.financialResults.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.financialResults
                              .map((action) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Container(
                                      height: 85,
                                      padding: EdgeInsets.all(10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5), color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("From: "),
                                                  Text(
                                                    action.fromDate,
                                                    style: TextStyle(fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("To: "),
                                                  Text(
                                                    action.toDate,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Income: "),
                                                  Text(
                                                    action.income,
                                                    style: TextStyle(fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Expenditure: "),
                                                  Text(
                                                    action.expenditure,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("audited: "),
                                                  Text(
                                                    action.audited,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    launch(
                                                      action.naAttachment.toString(),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Download PDF",
                                                    style: TextStyle(color: Colors.blue),
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
                ),*/

                /// Board Meeting
                /*ListTile(
                  title: Text('Board Meetings'),
                  subtitle: data.boardMeetings.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.boardMeetings.asMap().entries.map((entry) {
                              int index = entry.key;
                              var action = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(5), color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isExpanded[index] = !(_isExpanded[index] ?? false);
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
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                ),*/
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildShareholdingPatternChart({double promoter = 0, double public = 0, double shareByEmployee = 0}) {
    List<_ChartData> data = [
      _ChartData('Promoter', promoter, const Color(0xFF7086FD)),
      _ChartData('Public', public, const Color(0xFF6FD195)),
      _ChartData('Shares held by Employee', shareByEmployee, const Color(0xFFFFAE4C)),
    ];
    return SfCircularChart(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.all(0),
      legend: Legend(
        textStyle: const TextStyle(color: Colors.black),
        iconHeight: 7,
        iconWidth: 7,
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.auto,
      ),
      series: <CircularSeries>[
        DoughnutSeries<_ChartData, String>(
          legendIconType: LegendIconType.circle,
          dataSource: data,
          dataLabelMapper: (_ChartData data, _) => data.category,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            alignment: ChartAlignment.far,
            labelIntersectAction: LabelIntersectAction.shift,
            isVisible: false,
            labelPosition: ChartDataLabelPosition.outside,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
          ),
          enableTooltip: true,
          animationDuration: 1500,
          explode: true,
          explodeIndex: 0,
          innerRadius: '45%', // This makes it a doughnut chart
        ),
      ],
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}
