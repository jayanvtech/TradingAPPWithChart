// ignore_for_file: duplicate_import, unused_element

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/market_watch_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/holding_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/portfolio_screen.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Profile/UserProfile/screen/profilepage_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/market_watch_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/portfolio_screen.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Profile/UserProfile/screen/profilepage_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    balanceRefresher();
    SubscribeInstrument();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    // Make Flutter draw behind navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<String?> balanceRefresher() async {
    await ApiService().GetBalance();

    setState(() {});
    return 'done';
  }

  Future<void> SubscribeInstrument() async {
    await ApiService()
        .MarketInstrumentSubscribe(1.toString(), 26000.toString());
    await ApiService()
        .MarketInstrumentSubscribe(11.toString(), 26065.toString());
    await ApiService()
        .MarketInstrumentSubscribe(1.toString(), 26001.toString());
    await ApiService()
        .MarketInstrumentSubscribe(1.toString(), 26003.toString());
    await ApiService()
        .MarketInstrumentSubscribe(1.toString(), 26004.toString());
  }

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      HoldingScreen(),
      MarketWatchScreen(),
      PositionScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        onSelectedTabPressWhenNoScreensPushed: () {
          HapticFeedback.mediumImpact();
        },
        screen: DashboardScreen(),
        item: ItemConfig(
          activeForegroundColor: AppColors.primaryColor,
          icon: Icon(HugeIcons.strokeRoundedDashboardCircle),
          inactiveForegroundColor: AppColors.primaryColorDark2,
          title: "Dashboard",
          textStyle: TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        onSelectedTabPressWhenNoScreensPushed: () {
          HapticFeedback.mediumImpact();
        },
        screen: HoldingScreen(), // Assuming MarketScreen for "Market" tab
        item: ItemConfig(
          activeForegroundColor: AppColors.primaryColor,
          icon: Icon(HugeIcons
              .strokeRoundedShoppingBag01), // Consider a more suitable icon
          title: "Portfolio", textStyle: TextStyle(fontSize: 11),
          inactiveForegroundColor: AppColors.primaryColorDark2,
        ),
      ),
      PersistentTabConfig(
        onSelectedTabPressWhenNoScreensPushed: () {
          HapticFeedback.mediumImpact();
        },
        screen: MarketWatchScreen(),
        item: ItemConfig(
          activeForegroundColor: AppColors.primaryColor,
          icon: const Icon(HugeIcons.strokeRoundedBookmark02),
          title: "Watchlist",
          textStyle: TextStyle(fontSize: 11),
          inactiveForegroundColor: AppColors.primaryColorDark2,
        ),
      ),
      PersistentTabConfig(
        onSelectedTabPressWhenNoScreensPushed: () {
          HapticFeedback.mediumImpact();
        },
        screen: PositionScreen(),
        item: ItemConfig(
          activeForegroundColor: AppColors.primaryColor,
          icon: const Icon(HugeIcons.strokeRoundedPresentationBarChart01),
          title: "Position",
          textStyle: TextStyle(fontSize: 11),
          inactiveForegroundColor: AppColors.primaryColorDark2,
        ),
      ),
      PersistentTabConfig(
        onSelectedTabPressWhenNoScreensPushed: () {
          HapticFeedback.mediumImpact();
        },
        screen: ProfileScreen(),
        item: ItemConfig(
          activeForegroundColor: AppColors.primaryColor,
          textStyle: TextStyle(fontSize: 11),
          icon: const Icon(HugeIcons.strokeRoundedUser),
          inactiveForegroundColor: AppColors.primaryColorDark2,
          title: "Profile",
        ),
      ),
    ];
  }

  Widget build(BuildContext context) => PersistentTabView(
        selectedTabContext: (p0) {
          // HapticFeedback.heavyImpact();
        },
        animatedTabBuilder:
            (context, index, animationValue, newIndex, oldIndex, child) {
          final double yOffset = newIndex > index
              ? -animationValue
              : (newIndex < index
                  ? animationValue
                  : (index < oldIndex
                      ? animationValue - 1
                      : 1 - animationValue));
          return FractionalTranslation(
            translation: Offset(yOffset, 0),
            child: child,
          );
        },
        tabs: _tabs(),
        onTabChanged: (index) {
          HapticFeedback.mediumImpact();
        },
        navBarBuilder: (navBarConfig) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Color.fromARGB(76, 112, 146, 164),
                    width: 0.5), // Top divider line
              ),
            ),
            child: Style1BottomNavBar(
              navBarDecoration: NavBarDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              navBarConfig: navBarConfig,
            ),
          ),
        ),
      );
}
