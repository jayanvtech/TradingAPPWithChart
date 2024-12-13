import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_media_flutter/social_media_flutter.dart';
import 'package:tradingapp/Authentication/Screens/chagepassword_screen.dart';
import 'package:tradingapp/Authentication/Screens/change_password_screen.dart';
import 'package:tradingapp/Authentication/Screens/login_screen.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/Profile/CustomerSupport/screen/ticket_screen.dart';
import 'package:tradingapp/Profile/UserProfile/model/userProfile_model.dart';
import 'package:tradingapp/Profile/Reports/screens/fund_transcation_screen.dart';
import 'package:tradingapp/Profile/Reports/screens/ledger_report_screen.dart';
import 'package:tradingapp/Profile/Reports/screens/download_report_screen.dart';
import 'package:tradingapp/Profile/UserProfile/screen/user_details_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';
import 'package:tradingapp/model/trade_balance_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  bool isExpanded = false;
  bool isLoading = false;

  Future<String?> balanceRefresher() async {
    await ApiService().GetBalance();

    setState(() {});
    return 'done';
  }

  @override
  void initState() {
    balanceRefresher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDashboard1(),
      drawerEnableOpenDragGesture: true,
      endDrawer: DrawerDashboard2(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(HugeIcons.strokeRoundedSearchList01),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {HapticFeedback.mediumImpact(

          //  );
          //       Get.to(() => ChagepasswordScreen(
          //           // userID: userID,

          //           ));
          //     },
          //     child: Text('Change Password')),
          // ElevatedButton(
          //   onPressed: () async {HapticFeedback.mediumImpact(

          //  );
          //     await logout();
          //     Get.offAll(() => LoginScreen());
          //   },
          //   child: Text('Logout'),
          // ),
          // IconButton(
          //     onPressed: () async {HapticFeedback.heavyImpact(

          //  );
          //       String? token = await getToken();
          //       print(token);
          //     },
          //     icon: Icon(Icons.sort_by_alpha_outlined))
        ],
        title: const Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await balanceRefresher();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
              child: FutureBuilder<UserProfile>(
                future: ApiService().fetchUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error :: ${snapshot.error}');
                  }
                  // else if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return Text('Error: ${snapshot.error}');
                  // }

                  else {
                    return Skeletonizer(
                      enabled: snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.none ||
                          snapshot.hasError,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.57),
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    child: SvgPicture.asset(
                                      'assets/AppIcon/User_illustration.svg',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => UserProfileScreen(userProfile: snapshot.data!));
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data?.clientName}',
                                          style: TextStyle(
                                            color: AppColors.primaryColorDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Client ID: ${snapshot.data?.clientId}',
                                          style: TextStyle(
                                            color: AppColors.primaryColorDark2,
                                            decorationThickness: 3,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          HapticFeedback.heavyImpact();
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Hodlding",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.08))),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.57),
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
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.57),
                                  //     spreadRadius: 0,
                                  //     blurRadius: 3,
                                  //     offset: Offset(
                                  //         0, 2), // changes position of shadow
                                  //   ),
                                  // ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Ledger",
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColorDark2,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (context) => BalanceProvider()..GetBalance(),
                                            child: Consumer<BalanceProvider>(
                                              builder: (context, provider, child) {
                                                if (provider.balance == null) {
                                                  return Text("₹ 0");
                                                }
                                                if (provider.balance!.isNotEmpty) {
                                                  var balance = provider.balance!.first;
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        "₹ ${double.parse(balance.netMarginAvailable).toStringAsFixed(2)}",
                                                        // Replace `cashAvailable` with your actual field
                                                        style:
                                                            TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Text(
                                                    "0",
                                                    style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      //  SizedBox(width:MediaQuery.of(context).size.width/0.5),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Utilized",
                                            style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "374677.90",
                                            style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Collateral",
                                            style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "167537.90",
                                            style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Net",
                                        style: TextStyle(color: AppColors.primaryColorDark, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "167537.90",
                                        style: TextStyle(color: AppColors.primaryColorDark, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.heavyImpact();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryBackgroundColor,
                                                border: Border.all(color: AppColors.primaryColor),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "WITHDRAWAL",
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor1,
                                                    AppColors.primaryColor2,
                                                    AppColors.primaryColor3,
                                                  ],
                                                  stops: [0.1, 0.9, 0.9],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "ADD FUNDS",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.57),
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                                border: Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.08))),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryBackgroundColor,
                                    AppColors.tertiaryGrediantColor3,
                                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                                    AppColors.primaryBackgroundColor,
                                    AppColors.tertiaryGrediantColor3,
                                  ],
                                  stops: [0.2, 1, 0.1, 0.1, 1],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Holdings",
                                          style: TextStyle(color: AppColors.primaryColorDark, fontSize: 17, fontWeight: FontWeight.bold)),
                                      Text("82748932.90/-",
                                          style: TextStyle(color: AppColors.primaryColorDark, fontSize: 17, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Container(height: 200, child: AnimatedDoughnutChart()),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.08))),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.57),
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
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.57),
                                  //     spreadRadius: 0,
                                  //     blurRadius: 3,
                                  //     offset: Offset(
                                  //         0, 2), // changes position of shadow
                                  //   ),
                                  // ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Commodity",
                                            style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "8123677.90",
                                            style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      //  SizedBox(width:MediaQuery.of(context).size.width/0.5),

                                      // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Ledger",
                                            style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "167537.90",
                                            style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryBackgroundColor,
                                                border: Border.all(color: AppColors.primaryColor),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "WITHDRAWAL",
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor1,
                                                    AppColors.primaryColor2,
                                                    AppColors.primaryColor3,
                                                  ],
                                                  stops: [0.1, 0.9, 0.9],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "ADD FUNDS",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.08))),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.57),
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
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.57),
                                    //     spreadRadius: 0,
                                    //     blurRadius: 3,
                                    //     offset: Offset(
                                    //         0, 2), // changes position of shadow
                                    //   ),
                                    // ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "MTF Available Units",
                                              style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "8123677.90",
                                              style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        //  SizedBox(width:MediaQuery.of(context).size.width/0.5),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "MTF Margin Blocked",
                                              style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "374677.90",
                                              style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "MTF Opening Balance",
                                              style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "90777.90",
                                              style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        //  SizedBox(width:MediaQuery.of(context).size.width/0.5),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "MTF Withdrawal limit",
                                              style: TextStyle(color: AppColors.primaryColorDark2, fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "2314677.90",
                                              style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 50,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryBackgroundColor,
                                                  border: Border.all(color: AppColors.primaryColor),
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Text(
                                                "WITHDRAWAL",
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 16,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 50,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppColors.primaryColor1,
                                                      AppColors.primaryColor2,
                                                      AppColors.primaryColor3,
                                                    ],
                                                    stops: [0.1, 0.9, 0.9],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Text(
                                                "ADD FUNDS",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Container(
                            //   padding: EdgeInsets.all(15),
                            //   decoration: BoxDecoration(
                            //       border: Border.fromBorderSide(BorderSide(
                            //           color: Colors.grey.withOpacity(0.08))),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.57),
                            //           spreadRadius: 0,
                            //           blurRadius: 1,
                            //           offset: Offset(
                            //               0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //       gradient: LinearGradient(
                            //         colors: [
                            //           AppColors.primaryBackgroundColor,
                            //           AppColors.tertiaryGrediantColor3,
                            //           AppColors.tertiaryGrediantColor1
                            //               .withOpacity(1),
                            //           AppColors.primaryBackgroundColor,
                            //           AppColors.tertiaryGrediantColor3,
                            //         ],
                            //         stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                            //         begin: Alignment.topCenter,
                            //         end: Alignment.bottomCenter,
                            //       ),
                            //       // boxShadow: [
                            //       //   BoxShadow(
                            //       //     color: Colors.grey.withOpacity(0.57),
                            //       //     spreadRadius: 0,
                            //       //     blurRadius: 3,
                            //       //     offset: Offset(
                            //       //         0, 2), // changes position of shadow
                            //       //   ),
                            //       // ],
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 "Commodity",
                            //                 style: TextStyle(
                            //                     color:
                            //                         AppColors.primaryColorDark2,
                            //                     fontSize: 13,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //               Text(
                            //                 "0",
                            //                 style: TextStyle(
                            //                     color:
                            //                         AppColors.primaryColorDark1,
                            //                     fontSize: 15,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //           //  SizedBox(width:MediaQuery.of(context).size.width/0.5),

                            //           // SizedBox(width:MediaQuery.of(context).size.width/3),
                            //           Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.end,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.end,
                            //             children: [
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     'assets/AppIcon/danger_icon.svg',
                            //                     height: 30,
                            //                     width: 30,
                            //                   ),
                            //                   Container(
                            //                     width: MediaQuery.of(context)
                            //                             .size
                            //                             .width /
                            //                         2.15,
                            //                     child: Text(
                            //                       textAlign: TextAlign.end,
                            //                       "commodities Trading is not activeted in this account",
                            //                       style: TextStyle(
                            //                           color: AppColors
                            //                               .primaryColorDark2,
                            //                           fontSize: 13,
                            //                           fontWeight:
                            //                               FontWeight.bold),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         height: 10,
                            //       ),
                            //       Row(
                            //         children: [
                            //           Expanded(
                            //             child: InkWell(
                            //               onTap: () {},
                            //               child: Container(
                            //                 height: 50,
                            //                 width: 150,
                            //                 decoration: BoxDecoration(
                            //                     gradient: LinearGradient(
                            //                       colors: [
                            //                         AppColors.primaryColor1,
                            //                         AppColors.primaryColor2,
                            //                         AppColors.primaryColor3,
                            //                       ],
                            //                       stops: [0.1, 0.9, 0.9],
                            //                       begin: Alignment.topCenter,
                            //                       end: Alignment.bottomCenter,
                            //                     ),
                            //                     borderRadius:
                            //                         BorderRadius.circular(10)),
                            //                 child: Center(
                            //                     child: Text(
                            //                   "Active Commodities",
                            //                   style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 16,
                            //                   ),
                            //                 )),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.08))),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.57),
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
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.57),
                                  //     spreadRadius: 0,
                                  //     blurRadius: 3,
                                  //     offset: Offset(
                                  //         0, 2), // changes position of shadow
                                  //   ),
                                  // ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pledge Holding",
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColorDark2,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "0",
                                            style: TextStyle(color: AppColors.primaryColorDark1, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      //  SizedBox(width:MediaQuery.of(context).size.width/0.5),

                                      // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: Text(
                                                  textAlign: TextAlign.end,
                                                  "Pledge stocks or Mutual Funds to increase trading balance",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColorDark2,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor1,
                                                    AppColors.primaryColor2,
                                                    AppColors.primaryColor3,
                                                  ],
                                                  stops: [0.1, 0.9, 0.9],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "Pledge Stocks",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(
                                      color: Colors.grey.withOpacity(0.08))),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.57),
                                      spreadRadius: 0,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryBackgroundColor,
                                      AppColors.tertiaryGrediantColor3,
                                      AppColors.tertiaryGrediantColor1
                                          .withOpacity(1),
                                      AppColors.primaryBackgroundColor,
                                      AppColors.tertiaryGrediantColor3,
                                    ],
                                    stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.57),
                                  //     spreadRadius: 0,
                                  //     blurRadius: 3,
                                  //     offset: Offset(
                                  //         0, 2), // changes position of shadow
                                  //   ),
                                  // ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pay Later(MTF)",
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColorDark2,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "0",
                                            style: TextStyle(
                                                color:
                                                    AppColors.primaryColorDark1,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      //  SizedBox(width:MediaQuery.of(context).size.width/0.5),

                                      // SizedBox(width:MediaQuery.of(context).size.width/3),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: Text(
                                                  textAlign: TextAlign.end,
                                                  "View and Analyze your MTF Stocks",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColorDark2,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor1,
                                                    AppColors.primaryColor2,
                                                    AppColors.primaryColor3,
                                                  ],
                                                  stops: [0.1, 0.9, 0.9],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "View Stocks",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reports & Statements",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "Morden Back office for investors and traders"),

                                SizedBox(
                                  height: 10,
                                ),

                                  CustomReportContainer(
                                  onTap: (){
                                    Get.to(() => LedgerReportScreen());
                                  },
                                  title: "Statement/Ledger",
                                  subtitle: "Your transaction history",
                                  leadingIcon:
                                      HugeIcons.strokeRoundedAnalytics01,
                                  trailingIcon:
                                      HugeIcons.strokeRoundedArrowRight01,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                               CustomReportContainer(
                                  onTap: (){
                                   Get.to(() => FundTranscationScreen());
                                  },
                                  title: "Fund Transactions",
                                  subtitle: "Add Funds and Withdraws histroy",
                                  leadingIcon:
                                      HugeIcons.strokeRoundedWallet01,
                                  trailingIcon:
                                      HugeIcons.strokeRoundedArrowRight01,
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                               CustomReportContainer(
                                  onTap: (){},
                                  title: "Profit & Loss",
                                  subtitle: "Analyse your profit and loss",
                                  leadingIcon:
                                      HugeIcons.strokeRoundedAutoConversations,
                                  trailingIcon:
                                      HugeIcons.strokeRoundedArrowRight01,
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                CustomReportContainer(
                                  onTap: (){
                                   Get.to(() => DownloadReportsScreen());
                                  },
                                  title: "Download Reports",
                                  subtitle: "In PDF and Excel format",
                                  leadingIcon:
                                      HugeIcons.strokeRoundedAlignBoxMiddleLeft,
                                  trailingIcon:
                                      HugeIcons.strokeRoundedArrowRight01,
                                ),

                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Help & Support",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor),
                                          ),
                                          Text(
                                              "Raise a ticket for any query or issue"),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RaiseTicketScreen()));
                                                    },
                                                    child: Container(
                                                        height: 85,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.57),
                                                              spreadRadius: 0,
                                                              blurRadius: 1,
                                                              offset: Offset(0,
                                                                  1), // changes position of shadow
                                                            ),
                                                          ],
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              AppColors
                                                                  .primaryBackgroundColor,
                                                              AppColors
                                                                  .tertiaryGrediantColor3,
                                                              AppColors
                                                                  .tertiaryGrediantColor1
                                                                  .withOpacity(
                                                                      1),
                                                              AppColors
                                                                  .primaryBackgroundColor,
                                                              AppColors
                                                                  .tertiaryGrediantColor3,
                                                            ],
                                                            stops: [
                                                              0.1,
                                                              0.9,
                                                              0.9,
                                                              0.4,
                                                              0.51
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    "Your Tickets",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Icon(
                                                                  HugeIcons
                                                                      .strokeRoundedTicket01,
                                                                  size: 30,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "Create and manage tickets for your questions",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      height: 85,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.57),
                                                            spreadRadius: 0,
                                                            blurRadius: 1,
                                                            offset: Offset(0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            AppColors
                                                                .primaryBackgroundColor,
                                                            AppColors
                                                                .tertiaryGrediantColor3,
                                                            AppColors
                                                                .tertiaryGrediantColor1
                                                                .withOpacity(1),
                                                            AppColors
                                                                .primaryBackgroundColor,
                                                            AppColors
                                                                .tertiaryGrediantColor3,
                                                          ],
                                                          stops: [
                                                            0.1,
                                                            0.9,
                                                            0.9,
                                                            0.4,
                                                            0.51
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Contact Us",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Icon(
                                                                HugeIcons
                                                                    .strokeRoundedContact,
                                                                size: 30,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              "Connect with customer support",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                )
                                              ]),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DownloadReportsScreen()));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.57),
                                                    spreadRadius: 0,
                                                    blurRadius: 1,
                                                    offset: Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors
                                                        .primaryBackgroundColor,
                                                    AppColors
                                                        .tertiaryGrediantColor3,
                                                    AppColors
                                                        .tertiaryGrediantColor1
                                                        .withOpacity(1),
                                                    AppColors
                                                        .primaryBackgroundColor,
                                                    AppColors
                                                        .tertiaryGrediantColor3,
                                                  ],
                                                  stops: [
                                                    0.1,
                                                    0.9,
                                                    0.9,
                                                    0.4,
                                                    0.51
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        HugeIcons
                                                            .strokeRoundedAlignBoxMiddleLeft,
                                                        size: 35,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "FAQs",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: AppColors
                                                                        .primaryColorDark),
                                                              ),
                                                              Text(
                                                                  "Get solution to common queries",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: AppColors
                                                                          .primaryColorDark2))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    HugeIcons
                                                        .strokeRoundedArrowRight01,
                                                    color: AppColors
                                                        .primaryColorDark2,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          CustomButton(
                                              isLoading: false,
                                              text: "Log Out",
                                              onPressed: () {
                                                logout();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              })
                                        ]))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInkWell extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icons;

  CustomInkWell({required this.onTap, required this.title, required this.subtitle, required this.icons});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(
                        icons,
                        color: AppColors.primaryColor,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomBasicInkWell extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icons;

  CustomBasicInkWell({required this.onTap, required this.title, required this.icons});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(
                        icons,
                        color: AppColors.primaryColor,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BalanceProvider with ChangeNotifier {
  List<Balance>? _balance;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  String searchTerm = '';

  List<Balance>? get balance => _balance;

  Future<void> GetBalance() async {
    var response = await ApiService().GetBalance();

    if (response != null && response is Balance) {
      _balance = [response]; // Wrap the Balance instance in a list
    } else {
      var error = 'Error fetching balance $e';
      print(error);
      // Handle the case when response is null or not a Balance instance
    }

    print(response);
    notifyListeners();
    if (!_disposed) {
      notifyListeners();
    }
  }

  void setSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }
}
