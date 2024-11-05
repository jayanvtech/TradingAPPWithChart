// ignore_for_file: duplicate_import, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:tradingapp/DashBoard/Screens/DashBoardScreen/dashboard_screen.dart';
import 'package:tradingapp/GetApiService/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/MarketWatchScreen/market_watch_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/holding_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/portfolio_screen.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Profile/Screens/ProfileScreen/profilepage_screen.dart';
import 'package:tradingapp/MarketWatch/Screens/MarketWatchScreen/market_watch_screen.dart';
import 'package:tradingapp/Portfolio/Screens/PortfolioScreen/portfolio_screen.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Profile/Screens/ProfileScreen/profilepage_screen.dart';

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
        screen: DashboardScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.pie_chart),
          title: "Dashboard",
        ),
      ),
      PersistentTabConfig(
        screen: HoldingScreen(), // Assuming MarketScreen for "Market" tab
        item: ItemConfig(
          icon: const Icon(Icons.attach_money), // Consider a more suitable icon
          title: "Portfolio",
        ),
      ),
      PersistentTabConfig(
        screen: MarketWatchScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.watch),
          title: "Watchlist",
        ),
      ),
      PersistentTabConfig(
        screen: PositionScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.podcasts),
          title: "Position",
        ),
      ),
      PersistentTabConfig(
        screen: ProfileScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.person),
          title: "Profile",
        ),
      ),
    ];
  }

  Widget build(BuildContext context) => PersistentTabView(
        tabs: _tabs(),
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
            child: Style6BottomNavBar(
              navBarConfig: navBarConfig,
            ),
          ),
        ),
      );
}
