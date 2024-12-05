import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/ipo_details_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Utils/utils.dart';

class Viewalliposcreen extends StatefulWidget {
  const Viewalliposcreen({super.key});

  @override
  State<Viewalliposcreen> createState() => _ViewalliposcreenState();
}

class _ViewalliposcreenState extends State<Viewalliposcreen> {
  dynamic arguments = Get.arguments;
  String name = "";
  final ApiService _apiService = ApiService();
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;

  @override
  void initState() {
    super.initState();

    name = arguments["name"];
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    openIPO = _apiService.fetchOpenIpoDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                name == "Open IPO" ? openIPOsList() : upcomingIPOs(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blue));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
                  text: 'Error: ${snapshot.error}', color: Colors.black));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final ipo = data[index];
                    return InkWell(
                      onTap: () {
                        Get.to(const IPODetailsScreen(),
                            arguments: ({
                              'name': name,
                              'data': ipo,
                            }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
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
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                  ),
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
                                                child: Text(ipo.name)
                                              ),
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
                                                      text:
                                                          ipo.biddingStartDate,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingEndDate,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                              Container(
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors
                                                      .deepPurpleAccent.shade700
                                                      .withOpacity(0.1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                                      color:
                                          const Color.fromRGBO(27, 82, 52, 1.0),
                                    ),
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
                    );
                  },
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Center(
                      child: Utils.text(
                          text: "No Data Found!",
                          color: Colors.black,
                          fontSize: 15),
                    )
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
                  text: 'Error: ${snapshot.error}', color: Colors.black));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final ipo = data[index];
                    return InkWell(
                      onTap: () {
                        Get.to(const IPODetailsScreen(),
                            arguments: ({
                              'name': name,
                              'data': ipo,
                            }));
                      },
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
                                                          BorderRadius.circular(
                                                              10),
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
                                                SizedBox(
                                                  width: 180,
                                                  child: Utils.text(
                                                    text: ipo.name,
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
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
                                                        text: ipo
                                                            .biddingStartDate,
                                                        style:
                                                            GoogleFonts.poppins(
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
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                            ipo.biddingEndDate,
                                                        style:
                                                            GoogleFonts.poppins(
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
                                                          BorderRadius.circular(
                                                              05),
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
                                                      color: Colors.deepPurple,
                                                      fontSize: 09,
                                                    ),
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
                    );
                  },
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Center(
                      child: Utils.text(
                          text: "No Data Found!",
                          color: Colors.black,
                          fontSize: 15),
                    ),
                  ],
                );
        } else {
          return Center(
              child:
                  Utils.text(text: 'No data available', color: Colors.black));
        }
      },
    );
  }
}
