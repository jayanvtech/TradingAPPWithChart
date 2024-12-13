import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tradingapp/DrawerScreens/equity_market_screen.dart';
import 'package:tradingapp/MarketWatch/Provider/corporate_info_provider.dart';
import 'package:tradingapp/Profile/Reports/screens/ledger_report_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

import 'package:tradingapp/master/MasterServices.dart';
import 'package:tradingapp/master/nscm_database.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_bloc.dart';
import 'package:tradingapp/Authentication/Screens/login_screen.dart';
import 'package:tradingapp/Authentication/Screens/tpin_screen.dart';
import 'package:tradingapp/Notification/NotificationController/NotificationController.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/changenotifier.dart';
// import 'package:tradingapp/Utils/firebase_messeging.dart';
import 'package:tradingapp/market_screen.dart';
import 'package:tradingapp/master/nscm_provider.dart';

// void _instanceId() async {
//   // await Firebase.initializeApp();
//   // FirebaseMessaging.instance.getInitialMessage();
//   // FirebaseMessaging.instance.sendMessage();
//   // var token = await FirebaseMessaging.instance.getToken();
//   // print("Print Instance Token ID: " + token!);
// }
Future<bool> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  return status == PermissionStatus.granted;
}

Future<bool> requestBackgroundServicePermission() async {
  // For Android
  final status = await Permission.backgroundRefresh.request();
  return status == PermissionStatus.granted;
}

Future<void> requestPermissions() async {
  // Request permission to show notifications
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    // This opens a dialog for the user to confirm notification permissions
    isAllowed =
        await AwesomeNotifications().requestPermissionToSendNotifications();

    if (!isAllowed) {
      // Handle the case where the user declines the permissions
      print("Notification permission denied.");
    }
  }
}

void main() async {
  HttpClient client = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  WidgetsFlutterBinding.ensureInitialized();
  await ApiServiceMaster().checkAndFetchInstruments();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(
  //   (message) {
  //     print("onBackgroundMessage: $message");
  //     return Future<void>.value();
  //   },
  // );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  MarketFeedSocket marketFeedSocket = MarketFeedSocket();
  await InteractiveSocketFeed().initSocket();
  requestBackgroundServicePermission();
  requestBackgroundServicePermission();
  requestPermissions();
  //await ApiService().GetNSCEMMaster();
  // marketFeedSocket.connect();
  // await NscmDataProvider().fetchAndStoreData();

  //MarketFeedSocket marketFeedSocket = MarketFeedSocket();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InteractiveSocketFeed()..initSocket(),
          child: MyApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => TopLoosersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TopGainersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostBoughtProvider(),
        ),
        ChangeNotifierProvider(create: (context) => Week52HighLowProvider()),
        ChangeNotifierProvider.value(
          value: marketFeedSocket,
        ),
        ChangeNotifierProvider(create: (context) => CorporateInfoProvider()),
        ChangeNotifierProvider<InteractiveSocketFeed>(
          create: (contex) => InteractiveSocketFeed(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketFeedSocket()..connect(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => TradeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HoldingProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token != null;
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

// final PushNotificationService _notificationService = PushNotificationService();

class _MyAppState extends State<MyApp> {
  bool? isLoginValue = false;

  @override
  void initState() {
    super.initState();

    // _instanceId();
    //_notificationService.initialize();
    NotificationController.startListeningNotificationEvents();
    isLogin();
    // FirebaseInAppMessaging.instance.triggerEvent("");

    // FirebaseMessaging.instance.sendMessage();

    // FirebaseMessaging.instance.getInitialMessage();
    init();
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoginValue = prefs.getBool('isLogin');
    return isLoginValue != null;
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
    InteractiveSocketFeed().initSocket();
  }

  void startBackgroundService() {
    final service = FlutterBackgroundService();
    print("Starting background service");
    service.startService();
  }

  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }

  // final PushNotificationService _notificationService =
  //     PushNotificationService();
  @override
  Widget build(BuildContext context) {
    //_notificationService.initialize();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(1.0),
      ),
      child: GetMaterialApp(
        theme: ThemeData(
          colorSchemeSeed: AppColors.primaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        title: 'My App',
        navigatorKey: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MarketWatchManager(),
              child: MyApp(),
            ),
            ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
            ChangeNotifierProvider(
              create: (context) => NscmDataProvider(),
            ),
            ChangeNotifierProvider<InteractiveSocketFeed>(
              create: (contex) => InteractiveSocketFeed(),
            ),
            ChangeNotifierProvider(create: (_) => PositionProvider()),
            //ChangeNotifierProvider(create: (contex) => InteractiveSocketFeed()..interactiveSocket()),
          ],
          child: ChangeNotifierProvider(
            create: (_) => MarketFeedSocket()..connect(),
            // child: isLoginValue == false ? LoginScreen() : ValidPasswordScreen(),
            child: FutureBuilder<bool>(
              future: isLogin(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  print("isLoginValue: $isLoginValue");
                  print("snapshot.data: ${snapshot.data}");
                  if (snapshot.data == true && isLoginValue == true) {
                    // return MainScreen();
                    return ValidPasswordScreen(
                      isFromMainScreen: "true",
                    );
                  } else {
                    return LoginScreen();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> backgroundHandler(RemoteMessage message) async {
  //   print('Handling a background message ${message.messageId}');
  // }
}

// class PushNotificationService {
//   Future<void> backgroundHandler(RemoteMessage message) async {
//     print('Handling a background message ${message.messageId}');
//   }

//   FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   Future initialize() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(backgroundHandler);

//     // Get the token
//     await getToken();
//   }

//   Future<String?> getToken() async {
//     String? token = await _fcm.getToken();
//     print('Token: $token');
//     return token;
//   }
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
