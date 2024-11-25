// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradingapp/DashBoard/Models/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/ipo_details_screen.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/view_all_ipo_screen.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/Utils/utils.dart';

class IpoDashboardScreen extends StatefulWidget {
  const IpoDashboardScreen({super.key});

  @override
  State<IpoDashboardScreen> createState() => _IpoDashboardScreenState();
}

class _IpoDashboardScreenState extends State<IpoDashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;

  String equity = "";
  DateTime now = DateTime.now();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          "IPOs",
        ),
        bottom: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          tabs: const [
            Tab(text: 'IPO'),
            Tab(text: 'Bid Details'),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Open IPO",
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const Viewalliposcreen(),
                              arguments: ({
                                "name": "Open IPO",
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
                  child: SizedBox(
                    child: Column(
                      children: [
                        openIPOsList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
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

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
           
          ));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
            text: 'Error: ${snapshot.error}',
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length > 3 ? 3 : data.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final ipo = data[index];

              return InkWell(
                onTap: () {
                  Get.to(const IPODetailsScreen(),
                      arguments: ({
                        'name': "open IPO",
                        'data': ipo,
                      }));
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey[200]!),
                                            ),
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
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 180,
                                              child: Text(
                                                ipo.name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          const SizedBox(height: 5),
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
                                                  style: GoogleFonts.poppins(
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
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
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: Colors
                                                  .deepPurpleAccent.shade700
                                                  .withOpacity(0.1),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Utils.text(
                                                text: ipo.ipoType,
                                                color: Colors.deepPurple,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Center(
                                    child: Utils.text(
                                      text: "Apply",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
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
          return Center(
              child: Utils.text(
                  text: 'No data available',
                  color: Colors.black,
                  fontSize: 15));
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
                        Get.to(const IPODetailsScreen(),
                            arguments: ({'name': "upcoming IPO", 'data': ipo}));
                      },
                      child: Container(
                        child: Card(
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade800
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: Center(
                                                      child: Utils.text(
                                                        text: "${index + 1}",
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Utils.text(
                                                      text: ipo.name,
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      text: 'Bid Start Date ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: ipo
                                                              .biddingStartDate,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: ipo
                                                              .biddingEndDate,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(05),
                                                        color: Colors
                                                            .deepPurpleAccent
                                                            .shade700
                                                            .withOpacity(0.1)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                      child: Utils.text(
                                                          text: ipo.ipoType,
                                                          color:
                                                              Colors.deepPurple,
                                                          fontSize: 09),
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
                      child: Utils.text(
                          text: "No Data Found!",
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                );
        } else {
          return Center(
              child: Utils.text(
                  text: 'No data available',
                  color: Colors.black,
                  fontSize: 15));
        }
      },
    );
  }
}
