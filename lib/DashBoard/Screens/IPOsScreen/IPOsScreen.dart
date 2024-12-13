import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/ipo_details_screen.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/view_all_ipo_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';
import 'package:tradingapp/Utils/utils.dart';

class IpoDashboardScreen extends StatefulWidget {
  const IpoDashboardScreen({super.key});

  @override
  State<IpoDashboardScreen> createState() => _IpoDashboardScreenState();
}

class _IpoDashboardScreenState extends State<IpoDashboardScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;

  String equity = "";
  DateTime now = DateTime.now();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void loadData() {
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    openIPO = _apiService.fetchOpenIpoDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: buildAppBar(),
      body: TabBarView(
        clipBehavior: Clip.hardEdge,
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: "Open IPOs",
                        fontWeight: FontWeight.bold,
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Get.to(
                            const Viewalliposcreen(),
                            arguments: ({
                              "name": "Open IPO",
                            }),
                          );
                        },
                        child: CommonText(
                          text: "View All",
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        openIPOsList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming IPO",
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Get.to(const Viewalliposcreen(),
                              arguments: ({
                                "name": "Upcoming IPO",
                              }));
                        },
                        child: Text(
                          "View All",
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    child: Column(
                      children: [
                        upcomingIPOs(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build AppBar ==>
  AppBar buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: CommonText(text: "IPOs"),
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
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(1)),
          child: TabBar(
            onTap: (index) => HapticFeedback.mediumImpact(),
            dividerColor: Colors.transparent,
            indicatorColor: AppColors.primaryColor,
            controller: _tabController,
            isScrollable: true,
            splashFactory: InkRipple.splashFactory,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'IPO'),
              Tab(text: 'Bid Details'),
            ],
          ),
        ),
      ),
      /*TabBar(
        onTap: (index) {
          HapticFeedback.mediumImpact();
        },
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        automaticIndicatorColorAdjustment: true,
        controller: _tabController,
        tabs: const [
          Tab(text: 'IPO'),
          Tab(text: 'Bid Details'),
        ],
      ),*/
      backgroundColor: AppColors.primaryBackgroundColor,
      iconTheme: IconThemeData(color: AppColors.blackColor),
    );
  }

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: CommonText(
              text: 'Error: ${snapshot.error}',
              color: AppColors.blackColor,
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length > 3 ? 3 : data.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final ipo = data[index];
              return InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  HapticFeedback.mediumImpact();
                  Get.to(
                    const IPODetailsScreen(),
                    arguments: ({
                      'name': "open IPO",
                      'data': ipo,
                    }),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: AppColors.primaryBackgroundColor,
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.grey[200]!),
                                            ),
                                            child: Center(
                                              child: CommonText(
                                                text: "${index + 1}",
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 180,
                                            child: CommonText(
                                              text: ipo.name,
                                              fontWeight: FontWeight.w600,
                                              maxLines: 2,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              text: 'Bid Start Date:- ',
                                              style: TextStyle(
                                                color: AppColors.primaryColorDark1,
                                                fontSize: 10,
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: ipo.biddingStartDate,
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              text: 'Bid End Date:- ',
                                              style: TextStyle(
                                                color: AppColors.primaryColorDark1,
                                                fontSize: 10,
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: ipo.biddingEndDate,
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            height: 15,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: AppColors.deepPurpleAccentColor.withOpacity(0.1),
                                            ),
                                            child: CommonText(
                                              text: ipo.ipoType,
                                              color: AppColors.deepPurpleColor,
                                              fontSize: 9,
                                            ).paddingSymmetric(horizontal: 5),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              CustomSelectionButton(
                                text: "Apply",
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                isSelected: true,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Utils.text(text: 'No data available', color: Colors.black, fontSize: 15));
        }
      },
    );
  }

  Widget upcomingIPOs() {
    return FutureBuilder<IpoDetailsResponse>(
      future: upcomingIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color.fromRGBO(27, 82, 52, 1.0),
          ));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
            text: 'Error: ${snapshot.error}',
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length > 3 ? 3 : data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final ipo = data[index];
                    return InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Get.to(
                          const IPODetailsScreen(),
                          arguments: ({'name': "upcoming IPO", 'data': ipo}),
                        );
                      },
                      child: Container(
                        child: Card(
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.grey.shade800.withOpacity(0.1))),
                                                    child: Center(
                                                      child: Utils.text(
                                                        text: "${index + 1}",
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Utils.text(text: ipo.name, color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      text: 'Bid Start Date ',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: ipo.biddingStartDate,
                                                          style: GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      text: 'Bid End Date ',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: ipo.biddingEndDate,
                                                          style: GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(05),
                                                        color: Colors.deepPurpleAccent.shade700.withOpacity(0.1)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                      child: Utils.text(text: ipo.ipoType, color: Colors.deepPurple, fontSize: 09),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Utils.text(text: "No Data Found!", color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                );
        } else {
          return Center(child: Utils.text(text: 'No data available', color: Colors.black, fontSize: 15));
        }
      },
    );
  }
}
