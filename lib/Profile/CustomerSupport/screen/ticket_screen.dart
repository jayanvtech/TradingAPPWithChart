import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/comment_ticket_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/fetch_ticket_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/screen/hime_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          title: Text('Help Desk'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<FetchTicketModelResponse>(
                future: ApiService().FetchSupportTicket(),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return CircularProgressIndicator();
                  // }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data;
                    return Expanded(
                      child: Skeletonizer(
                        enabled: snapshot.connectionState == ConnectionState.waiting,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var data1 = data[index];
                            var SupportTicketDetails = data1;
                            return Stack(
                              children: [
                                Container(
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
                                    border: Border.all(color: AppColors.primaryColorDark3.withOpacity(0.5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColorDark3,
                                        blurRadius: 1,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("#${SupportTicketDetails.ticket_id.toString()}"),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            HugeIcons.strokeRoundedClock01,
                                                            size: 12,
                                                            color: AppColors.primaryColorDark1,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            SupportTicketDetails.createdAt.subtract(Duration(hours: 5, minutes: 30)).toString(),
                                                            style: TextStyle(fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 250,
                                                        child: Text(SupportTicketDetails.title, overflow: TextOverflow.ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: SimpleCircularProgressBar(
                                                          animationDuration: 0,
                                                          progressStrokeWidth: 5,
                                                          backStrokeWidth: 4,
                                                          progressColors: const [Colors.grey],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [Text(SupportTicketDetails.category_name),Text(SupportTicketDetails.subcategory_name)],
                                                ),
                                                Container(
                                                  width: 100,
                                                  padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                                                    color: AppColors.primaryColorLight3,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(SupportTicketDetails.status, textAlign: TextAlign.center),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.VerticalLineColor1,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 100,
                                  width: 7,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                  isLoading: false,
                  text: "Create Ticket",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HelpDeskScreen()));
                  }),
            ],
          ),
        ));
  }
}
