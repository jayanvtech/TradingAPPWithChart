import 'package:tradingapp/ordersocketvalues_model.dart';

class AppVariables {
  static int isFirstTimeApiCalling = 0;
  static List<OrderSocketValues> dataList = [];
  static List<dynamic> HodlingDisplayName = [];
  static List<dynamic> HodlingDisplayNameMain = [];
  static Map<String, String> topGainers = {};

  static List<dynamic> TopLoosers = [];
  static List<dynamic> MostActive = [];
  static List<dynamic> week52HighLow = [];
  static Object TotalBalance = 0.0;
  static List<Map<String, String>> exchangeData = [];
}
