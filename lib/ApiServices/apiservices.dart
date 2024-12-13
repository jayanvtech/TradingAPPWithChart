// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/bid_request_model.dart';
import 'package:tradingapp/DashBoard/Screens/IPOsScreen/model/ipo_model.dart';
import 'package:tradingapp/DashBoard/Screens/HighestReturnScreens/Model/sector_theme_model.dart';
import 'package:tradingapp/DrawerScreens/topgainers_model.dart';
import 'package:tradingapp/DashBoard/Screens/FII/DII/Model/fiiHistoryDataModel.dart';
import 'package:tradingapp/DashBoard/Screens/FII/DII/Model/stocksAndIndexDataModel.dart';
import 'package:tradingapp/MarketWatch/model/corporate_info_model.dart';
import 'package:tradingapp/MarketWatch/SearchOperations/Model/searchby_string_model.dart';
import 'package:tradingapp/Notification/NotificationController/NotificationController.dart';
import 'package:tradingapp/Position/Screens/PositionScreen/position_screen.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/catagory_fetch_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/create_ticket_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/comment_ticket_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/fetch_ticket_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/screen/ticket_genereated_screen.dart';
import 'package:tradingapp/Profile/Reports/Models/ledger_report_model.dart';
import 'package:tradingapp/Profile/UserProfile/model/userProfile_model.dart';
import 'package:tradingapp/Profile/Reports/Models/voucher_bill_model.dart';
import 'package:tradingapp/Profile/Reports/screens/ledger_report_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_config.dart';
import 'package:tradingapp/Utils/const.dart/app_variables.dart';
import 'package:tradingapp/Utils/log_utils.dart';
import 'package:tradingapp/master/MasterServices.dart';
import 'package:tradingapp/model/instrumentbyid_model.dart';
import 'package:tradingapp/model/trade_balance_model.dart';
import 'package:tradingapp/sqlite_database/dbhelper.dart';

class ApiService extends ChangeNotifier {
  final String baseUrl = AppConfig.baseUrl;
  final String fiidiiserver = AppConfig.fiidiiserver;
  final String iposerver = AppConfig.iposerver;

  Future<List<dynamic>> searchInstrumentsMain(String query) async {
    print("Search called with query: $query");

    if (query.length < 2) {
      print("Query too short");
      return [];
    }

    final String? apiToken = await getToken();
    if (apiToken == null) {
      print("API Token is null");
      throw Exception('Authentication token is not available.');
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/apimarketdata/search/instruments?searchString=$query'),
          headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'});

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          return data['result'];
        } else {
          print("Data retrieval success but no results");
          return [];
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments ssswith status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<List<StockModel>> searchInstrumentByString(String query) async {
    print("Search called with query: $query");

    if (query.length < 2) {
      print("Query too short");
      return [];
    }

    final String? apiToken = await getToken();
    if (apiToken == null) {
      print("API Token is null");
      throw Exception('Authentication token is not available.');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/apimarketdata/search/instruments?searchString=$query'),
        headers: {
          'Authorization': '$apiToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          return (data['result'] as List).map((item) => StockModel.fromJson(item)).toList();
        } else {
          print("Data retrieval success but no results");
          return [];
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> searchInstruments(String query) async {
    if (query.length < 2) {
      print("Query too short");
      return [];
    }
    if (query.contains(" ")) {
      var partone = query.split(" ");
      String partone1 = partone[0];
      String part2 = partone[1];
      final dbHelper = DatabaseHelper.instance;
      final List<Map<String, dynamic>> localResults = await dbHelper.searchInDatabaseWith2Params(partone1, part2);
      if (localResults.isNotEmpty) {
        print("Found ${localResults.length} results in local database.");
        return localResults;
      }
    }
    final dbHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> localResults = await dbHelper.searchInDatabase(query);
    if (localResults.isNotEmpty) {
      print("Found ${localResults.length} results in local database.");
      return localResults;
    }

    final List<dynamic> apiResults = await searchInstrumentsMain(query);
    await dbHelper.storeInstrumentsInDatabase(apiResults);
    return apiResults;
  }

  Future<dynamic> GetBhavCopy(String exchangeInstrumentID, String exchangeSegment) async {
    final String? apiToken = await getToken();
    if (apiToken == null) {
      throw Exception('Authentication token is not available.');
    }

    try {
      var headers = {'Authorization': apiToken, 'Content-Type': 'application/json'};
      var body = json.encode({
        "source": "WebAPI",
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ]
      });

      var response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/search/instrumentsbyid'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          final closeValue = data['result'][0]['Bhavcopy']['Close'];

          return closeValue.toString();
        } else {
          print("Data retrieval success but no resultsin Bhavcopy");
          return "0";
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<dynamic> GetDisplayName(int exchangeInstrumentID, String exchangeSegment) async {
    final String? apiToken = await getToken();
    if (apiToken == null) {
      throw Exception('Authentication token is not available.');
    }

    try {
      var headers = {'Authorization': apiToken, 'Content-Type': 'application/json'};
      var body = json.encode({
        "source": "WebAPI",
        "instruments": [
          {"exchangeSegment": 1.toInt(), "exchangeInstrumentID": exchangeInstrumentID.toInt()}
        ]
      });

      var response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/search/instrumentsbyid'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          final displayName = data['result'][0]["DisplayName"];

          //  AppVariables.HodlingDisplayNameMain.add(displayName);
          //  print(AppVariables.HodlingDisplayNameMain);
          print(displayName);
          return displayName;
        } else {
          print("Data retrieval success but no resultsin DisplayName");
          return "0";
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<dynamic> GetDisplayNameforLogo(int exchangeInstrumentID, String exchangeSegment) async {
    final String? apiToken = await getToken();
    if (apiToken == null) {
      throw Exception('Authentication token is not available.');
    }

    try {
      var headers = {'Authorization': apiToken, 'Content-Type': 'application/json'};
      var body = json.encode({
        "source": "WebAPI",
        "instruments": [
          {"exchangeSegment": 1.toInt(), "exchangeInstrumentID": exchangeInstrumentID.toInt()}
        ]
      });

      var response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/search/instrumentsbyid'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          final displayName = data['result'][0]["DisplayName"];

          AppVariables.HodlingDisplayName.add(displayName);

          print(AppVariables.HodlingDisplayName);
          return displayName;
        } else {
          print("Data retrieval success but no resultsin DisplayName");
          return "0";
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments ($exchangeInstrumentID) with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<dynamic> MarketInstrumentSubscribe(String exchangeSegment, String exchangeInstrumentID) async {
    String? apiToken = await getToken();
    try {
      final body = json.encode({
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ],
        "xtsMessageCode": 1502
      });

      final response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/instruments/subscription'),
        body: body,
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      // print(apiToken);
      // print(response.body);
      if (response.statusCode == 200) {
        print("Subscribed");
        return true;
      } else {
        print("Data retrieval success ($exchangeSegment) but no  results In Subscribe API");
        return "0";
      }
    } catch (e) {
      print("Exception caught In Subscribe API : $e");
      rethrow;
    }
  }

  Future<dynamic> MarketInstrumentSubscribe1505(String exchangeSegment, String exchangeInstrumentID) async {
    String? apiToken = await getToken();
    try {
      final body = json.encode({
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ],
        "xtsMessageCode": 1505
      });

      final response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/instruments/subscription'),
        body: body,
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      // print(apiToken);
      // print(response.body);
      if (response.statusCode == 200) {
        // print("Subscribed");
        return true;
      } else {
        print("Data retrieval success ($exchangeSegment) but no  results In Subscribe API");
        return "0";
      }
    } catch (e) {
      print("Exception caught In Subscribe API : $e");
      rethrow;
    }
  }

  Future<dynamic> UnsubscribeMarketInstrument(String exchangeSegment, String exchangeInstrumentID) async {
    String? apiToken = await getToken();
    try {
      final body = json.encode({
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ],
        "xtsMessageCode": 1502
      });
      final response = await http.put(
        Uri.parse('$baseUrl/apimarketdata/instruments/subscription'),
        body: body,
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("Unsubscribed");
        return true;
      } else {
        print("Data retrieval success but no results");
        return "0";
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchFiiDiiDetailsMonthly({String? type}) async {
    final response = await http.get(Uri.parse('$fiidiiserver/v1/get_fii_data_cash_fo_index_stocks/?type=$type'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load FII/DII data');
    }
  }

  Future<dynamic> GetNSCEMMaster() async {
    String? apiToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiamF5M2NoYXVoYW4iLCJleHAiOjE3MTU3ODM4NjB9.YxaJvTtjvMf_cNr9yYg1g16M7TYEb7onWae4b8IH37M";
    try {
      final response = await http.post(
        Uri.parse('http://192.168.102.251:5001/v1/dbcontractEQ'),
        headers: {'AuthToken': '$apiToken', 'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['data'] != null) {
          print("Datagotit");

          return data['data'];
        } else {
          print("Data retrieval success but no results");
          return "0";
        }
      } else {
        print("Data retrieval success but no results");
        return "0";
      }
    } catch (e) {
      print("Exception caught: $e");
      rethrow;
    }
  }

  Future<dynamic> GetPosition() async {
    String? apiToken = await getToken1();
    String? userId = await getUserId();
    String? clientId = await getClientId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/portfolio/positions?dayOrNet=NetWise'),
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      print("${response.body}");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          for (var item in data['result']['positionList']) {}
          return data['result']['positionList'];
        } else {
          print("Data retrieval success but no results in GetPosition");
          return [];
        }
      } else {
        print("Data retrieval success but no results in GetPosition");
        return [];
      }
    } catch (e) {
      print("Exception caughdddt: $e");
      return [];
    }
  }

// Future<dynamic> GetHolding() async {
//     String? apiToken = await getToken1();
//     String? userId = await getUserId();
//     String? clientId = await getClientId();
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/interactive/portfolio/holdings?clientID=A0886'),
//         headers: {
//           'Authorization': '$apiToken',
//           'Content-Type': 'application/json'
//         },
//       );
//       print("${response.body}");
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         if (data['type'] == 'success' && data['result'] != null) {
//           for (var item in data['result']['positionList']) {}
//           return data['result']['positionList'];
//         } else {
//           print("Data retrieval success but no results in GetPosition");
//           return [];
//         }
//       } else {
//         print("Data retrieval success but no results in GetPosition");
//         return [];
//       }
//     } catch (e) {
//       print("Exception caughdddt: $e");
//       return [];
//     }
//   }

  Future<dynamic> GetTrades() async {
    String? apiToken = await getToken1();
    String? userId = await getUserId();
    String? clientId = await getClientId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/orders/trades'),
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          for (var item in data['result']) {}
          return data['result'];
        } else {
          print("Data retrieval success but no results in GetPosition");
          return [];
        }
      } else {
        print("Data retrieval success but no results in GetPosition");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<dynamic> GetOrder() async {
    String? apiToken = await getToken1();
    String? userId = await getUserId();
    String? clientId = await getClientId();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/orders'),
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      print("66666666666666666666${response.body}");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          for (var item in data['result']) {}
          notifyListeners();
          return data['result'];
        } else {
          print("Data retrieval success but no results in GetOrder");
          return data['result'];
        }
      } else {
        print("Data retrieval success but no results in GetOrder");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<dynamic> GetOrderHistroy(String OptionType, String FromDate, String ToDate) async {
    String? apiToken = await getToken();
    String? userId = await getUserId();
    String? clientId = await getClientId();
//2024-05-21
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enterprise/reports/trade?clientID=A0033&userID=A0033&exchangeSegment=$OptionType&fromDate=$FromDate&toDate=$ToDate'),
        headers: {
          'Authorization': '$apiToken',
          'Content-Type': 'application/json',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          print("Data retrieval success in GetOrderHistroy");
          for (var item in data['result']['tradeReportList']) {}
          print("45678965434567876543234567${data['result']['tradeReportList']}");
          return data['result']['tradeReportList'];
        } else {
          print("Data retrieval success but no results in GetOrderHistroy");
          return [];
        }
      } else {
        print("Data retrieval success but no results in GetOrderHistroy");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<dynamic> GetHoldings() async {
    String? apiToken = await getToken1();
    String? userId = await getUserId();
    String? clientId = await getClientId();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/portfolio/holdings?clientID=A0031'),
        headers: {'Authorization': '$apiToken', 'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          Map<String, dynamic> holdings = data['result']['RMSHoldings']['Holdings'];
          Map<String, dynamic> finalHoldings = {};
          DatabaseHelperMaster dbHelper = DatabaseHelperMaster();

          for (var isin in holdings.keys) {
            var holding = holdings[isin];

            List<Map<String, dynamic>> instruments = await dbHelper.getInstrumentsByISIN(isin.toString());

            // print('Instruments-------------------: $instruments');
            if (instruments.isNotEmpty) {
              holding['DisplayName'] = instruments.first['displayName'];
            } else {
              holding['DisplayName'] = 'Unknown'; // Fallback in case ISIN not found
            }

            finalHoldings[isin] = holding;
          }

          return finalHoldings;
        } else {
          print("Data retrieval success but no results in Holdings");
          return {};
        }
      } else {
        print("Data retrieval failed with status code ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Exception caught: $e");
      return {};
    }
  }

  Future<Result> GetInstrumentByID(String exchangeInstrumentID, String exchangeSegment) async {
    final String? apiToken = await getToken();
    if (apiToken == null) {
      throw Exception('Authentication token is not available.');
    }

    try {
      var headers = {'Authorization': apiToken, 'Content-Type': 'application/json'};
      var body = json.encode({
        "source": "WebAPI",
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ]
      });

      var response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/search/instrumentsbyid'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          Map<String, dynamic> result = data['result'][0];
          return Result.fromJson((result));
        } else {
          print("Data retrieval success but no resultsin SerachInsturmentBYId in portfolio");
          return Result();
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught in SerachInsturmentBYId: $e");
      rethrow;
    }
  }

  Future<dynamic> GetInstrumentDisplayName(String exchangeInstrumentID, String exchangeSegment) async {
    final String? apiToken = await getToken();
    if (apiToken == null) {
      throw Exception('Authentication token is not available.');
    }

    try {
      var headers = {'Authorization': apiToken, 'Content-Type': 'application/json'};
      var body = json.encode({
        "source": "WebAPI",
        "instruments": [
          {"exchangeSegment": exchangeSegment, "exchangeInstrumentID": exchangeInstrumentID}
        ]
      });

      var response = await http.post(
        Uri.parse('$baseUrl/apimarketdata/search/instrumentsbyid'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['type'] == 'success' && data['result'] != null) {
          return data['result'][0]["DisplayName"].toString();
        } else {
          print("Data retrieval success but no resultsin SerachInsturmentBYId in portfolio");
          return "0";
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials or token validity.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: Please check the URL.');
      } else {
        throw Exception('Failed to load instruments with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught in SerachInsturmentBYId: $e");
      rethrow;
    }
  }

  Future<void> placeOrder(Map<String, dynamic> orderDetails, String? displayName, BuildContext context) async {
    try {
      print("tryis calling");
      final String? apiToken = await getToken1();
      final response = await http.post(
        Uri.parse('$baseUrl/interactive/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': apiToken.toString(),
        },
        body: jsonEncode(orderDetails),
      );
      print(apiToken);
      print(orderDetails);
      print("$baseUrl/interactive/orders");
      print("hfhsdshdjshdjshjdsjdsjdsjdhsj${response.body}");
      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        final String descriptionMessage = responseBody['description'] ?? 'Order Rejected or Cancelled';
        Get.snackbar('Order Rejected or Cancelled', descriptionMessage);
        throw Exception('Failed to place order');
      } else {
        print("Orderdddddddd placed successfully");
        final responseBody = jsonDecode(response.body);
        final String descriptionMessage = responseBody['description'] ?? 'Order placed successfully';

        Get.snackbar(descriptionMessage, 'Order placed successfully');
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return PositionScreen();
            },
          ),
        );
        Get.offAll(() => MainScreen());
        PositionProvider().getPosition();

        try {
          final response = await GetOrder();
          Map<String, dynamic>? lastMap;

          for (var i = 0; i < response.length; i++) {
            lastMap = response[i];
          }
          // print("lambo report 6 jo ${lastMap}");

          if (lastMap?['OrderStatus'] == "Filled") {
            // NotificationController.createNewNotification(
            //     title: "Order placed successfully",
            //     description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} Successfully"
            // );
          } else if (lastMap?['OrderStatus'] == "Rejected") {
            // NotificationController.createNewNotification(
            //     title: "Order is Rejected",
            //     description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Rejected because ${lastMap?['CancelRejectReason']}"
            // );
          } else if (lastMap?['OrderStatus'] == "Cancelled") {
            // NotificationController.createNewNotification(
            //     title: "Order is Cancelled",
            //     description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Cancelled because ${lastMap?['CancelRejectReason']}"
            // );
          } else {
            // NotificationController.createNewNotification(
            //     title: "Order is Rejected",
            //     descrip==============8tion: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Rejected because ${lastMap?['CancelRejectReason']}"
            // );
          }
        } catch (e) {
          // NotificationController.createNewNotification(
          //     title: "Order isn't placed",
          //     description: "Internal Server Error!"
          // );
        }
      }
    } catch (e) {
      print("gggggggg$e");
    }
  }

  Future<void> ModifyOrder(Map<String, dynamic> orderDetails, String? displayName, BuildContext context) async {
    try {
      print("tryis calling");
      final String? apiToken = await getToken1();
      final response = await http.put(
        Uri.parse('$baseUrl/interactive/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': apiToken.toString(),
        },
        body: jsonEncode(orderDetails),
      );
      print(response.body);
      print(orderDetails);
      print("hfhsdshdjshdjshjdsjdsjdsjdhsj${response.body}");
      if (response.statusCode != 200) {
        throw Exception('Failed to place order');
      } else {
        print("Orderdddddddd placed successfully");
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return PositionScreen();
            },
          ),
        );
        //Get.offAll(() => MainScreen());
        //PositionProvider().getPosition();
        // Get.snackbar('Order Placed', 'Order placed successfully');
        try {
          final response = await GetOrder();
          Map<String, dynamic>? lastMap;
          for (var i = 0; i < response.length; i++) {
            lastMap = response[i];
          }
          // print("lambo report 6 jo ${lastMap}");

          if (lastMap?['OrderStatus'] == "Filled") {
            NotificationController.createNewNotification(
                title: "Order placed successfully",
                description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} Successfully");
          } else if (lastMap?['OrderStatus'] == "Rejected") {
            // NotificationController.createNewNotification(
            //     title: "Order is Rejected",
            //     description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Rejected because ${lastMap?['CancelRejectReason']}"
            // );
          } else if (lastMap?['OrderStatus'] == "Cancelled") {
            NotificationController.createNewNotification(
                title: "Order is Cancelled",
                description:
                    "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Cancelled because ${lastMap?['CancelRejectReason']}");
          }
          // else{
          //   NotificationController.createNewNotification(
          //       title: "Order is Rejected",
          //       description: "A ${orderDetails['orderQuantity']} $displayName ${orderDetails['orderSide']} is Rejected because ${lastMap?['CancelRejectReason']}"
          //   );
          // }
        } catch (e) {
          NotificationController.createNewNotification(title: "Order isn't placed", description: "Internal Server Error!");
        }
      }
    } catch (e) {
      print("gggggggg$e");
    }
  }

  Future<void> cancelOrder(String appOrderID) async {
    try {
      final url = '$baseUrl/interactive/orders?appOrderID=$appOrderID'; // Replace with your actual URL
      final String? apiToken = await getToken1();

      // Check if API token is null or empty
      if (apiToken == null || apiToken.isEmpty) {
        throw Exception('API token is missing or invalid');
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': apiToken,
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        return jsonDecode(response.body);
      } else {
        // If the server returns an unexpected response, throw an error.
        throw Exception('Failed to cancel order: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle potential errors here
      if (error is http.ClientException) {
        // Handle network errors
        print('Network error occurred: ${error.message}');
      } else if (error is Exception) {
        // Handle other exceptions
        print('Error occurred: ${error.toString()}');
      } else {
        // Handle unexpected errors
        print('Unexpected error: ${error.toString()}');
      }

      // Rethrow the error or handle it appropriately based on your application's requirements
      rethrow; // Or handle the error here
    }
  }

  Future<List<dynamic>> fetchMarketUpdatesData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/enterprise/common/holidaylist'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        // and return the list of market updates.
        List<dynamic> marketUpdates = jsonDecode(response.body);
        return marketUpdates;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load market updates');
      }
    } catch (e) {
      // Handle error
      print('Error fetching market updates: $e');
      throw Exception('Failed to load market updates');
    }
  }

  Future<Map<String, Map<String, double>>> fetchFiiDiiDetails() async {
    try {
      print("fetchFiiDiiDetails");
      final response = await http.post(Uri.parse(
              // 'https://api.sensibull.com/v1/fii_dii_details_v2?year_month=2024-May'
              '$fiidiiserver/v1/get_fii_history_data/'),
          body: jsonEncode(
            {},
          ),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          });
//  'http://192.168.130.48:9010/v1/get_fii_history_data/'
      print("------------${response.body}");
      if (response.statusCode == 200) {
        Map<String, Map<String, double>> result = {};
        final jsonData = jsonDecode(response.body);
        final successData = jsonData['success'];
        final data = successData['data'];

        data.forEach((key, value) {
          final cashFii = value['cash']['fii'];
          final cashDii = value['cash']['dii'];
          final fnoFiiquantitywise = value['future']['fii'];
          final fnoDiiAmountwise = value['future']['fii']['amount-wise']['net_oi'];
          final fiiBuySellDifference = cashFii['buy_sell_difference'];
          final diiBuySellDifference = cashDii['buy_sell_difference'];

          result[key] = {
            'fii_buy_sell_difference': fiiBuySellDifference,
            'dii_buy_sell_difference': diiBuySellDifference,
            'dii_fnoDii_amount_wise': fnoDiiAmountwise,
          };
        });

        return result;
      } else
        return throw Exception('Failed to load data IN FII DII');
    } catch (e) {
      throw Exception('Failed to load data IN FII DII');
      // print("Exception caught in FII DII API: $e");
    }
  }

  Future<FiiHistoryData> fetchFiiDiiDetails1() async {
    try {
      final response = await http.post(
        Uri.parse('$fiidiiserver/v1/get_fii_history_data/'),
        body: jsonEncode({}),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        return FiiHistoryData.fromJson(jsonData['success']);
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<FiiData>> fetchStockAndIndexData({String? type}) async {
    final String apiUrl = '$fiidiiserver/v1/get_fii_data_cash_fo_index_stocks/?type=$type';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['result'];
      List<FiiData> fiiDataList = jsonResponse.map((json) => FiiData.fromJson(json)).toList();
      return fiiDataList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Balance> GetBalance() async {
    String? token = await getToken1();
    if (token == null) {
      throw Exception('User is not logged in');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/user/balance?clientID=A0031'),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final balanceList = responseData['result']['BalanceList'];
        final filteredBalances = Balance.filterBalances(balanceList);
        if (filteredBalances.isEmpty) {
          throw Exception('No balance with limitHeader "ALL|ALL|ALL" found');
        }

        return filteredBalances.first;
      } else {
        if (response.statusCode == 401) {
          throw Exception('Unauthorized');
        }
        throw Exception('Failed to load user Balance ');
      }
    } catch (e) {
      print('Caught error: $e');
      throw Exception('Failed to load user Balance due to an error: $e');
    }
  }

  Future<dynamic> GetUserProfile(String clientID, String userID) async {
    String? Token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enterprise/user/profile?clientID=A0031&userID=A0031'),
        headers: {
          'Authorization': Token.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['type'] == 'success') {
          return jsonData['result'];
        } else {
          final error = 'Error: ${jsonData['description']}';
          return error;
        }
      } else {
        return 'Error: Failed to fetch data. Status code: ${response.statusCode}';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  Future<UserProfile>? fetchUserProfile() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('User is not logged in');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/interactive/user/profile?clientID=A0031'),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        if (response.statusCode == 401) {
          throw Exception('Unauthorized');
        }

        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      // This will catch any exceptions thrown from the try block
      print('Caught error: $e');
      throw Exception('Failed to load user profile due to an error: $e');
    }
  }

  Future<UserProfile?> fetchDUserProfile(String clientID, String userID) async {
    final String apiUrl =
        // '$baseUrl/enterprise/user/profile?clientID=$clientID&userID=$userID';
        '$baseUrl/interative/user/profile?clientID=A0031';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON data
        final jsonData = json.decode(response.body);
        if (jsonData['type'] == 'success') {
          // Convert JSON data to UserProfile object
          return UserProfile.fromJson(jsonData);
        } else {
          print('Error: ${jsonData['description']}');
          return null;
        }
      } else {
        print('Error: Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<IpoDetailsResponse> fetchUpcomingIpoDetails() async {
    try {
      String baseUrl = '$iposerver/ipo/v1/get-ipo-details?source=mobile_app';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'condition': 'upcoming',
        }),
      );

      if (response.statusCode == 200) {
        return IpoDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load IPO details');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<IpoDetailsResponse> fetchOpenIpoDetails() async {
    try {
      String baseUrl = '$iposerver/ipo/v1/get-ipo-details?source=mobile_app';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'condition': 'current',
        }),
      );
      print("${response.body}");
      if (response.statusCode == 200) {
        return IpoDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load IPO details');
      }
    } catch (e) {
      throw Exception('Failed to load IPO details $e');
    }
  }

  Future<BidResponse> submitBid(
    BidRequest request,
  ) async {
    try {
      final String? token = await getToken();

      final url = Uri.parse('$iposerver/ipo/v1/bid/bidSubmit?client_code=A0031&source=connect');
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'authToken': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return BidResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to submit bid');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<TopGainersNLosers> fetchTopGainers() async {
    final response = await http.get(Uri.parse('http://180.211.116.158:8080/mobile/api/v1/all-stocks-performance/top-gainers-loosers?index=gainers'));
    if (response.statusCode == 200) {
      return TopGainersNLosers.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load top gainers');
    }
  }

  Future<StockCorporateDetailModel?> getCorporateStockDetailsData(String Symbol) async {
    final url = '${AppConfig.localVasu}/api/v1/stock-analysis/top-corp-info-equity?symbol=$Symbol';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log('jsonData :: ${jsonData}');
      // LogUtil.successLog(jsonData);
      return StockCorporateDetailModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<TicketData?> createTicketApiService() async {
    try {
      TicketData ticketAPIModel = TicketData();
      var url = '${AppConfig.baseUrl2}/category/fetch';
      var uri = Uri.parse(url);
      var responce = await http.get(uri);
      log("responce body ::${responce.body} status code :: ${responce.statusCode}");
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        var data = jsonDecode(responce.body), ticketAPIModel = TicketData.fromJson(data['data']);
        log('ticketAPIModel :: ${ticketAPIModel.toJson()}');
        return ticketAPIModel;
      } else {
        return null;
      }
    } on Exception catch (e, st) {
      log('createTicket Api :: $e :: ST :: $st');
      rethrow;
    }
  }

  Future<List<SectorThemeModel>> fetchSectorStock() async {
    final url = '${AppConfig.baseUrl2}/api/v1/sector-industry-analysis/sector-stocks?sector=all';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      List<dynamic> sectorStocksJson = jsonData['data']; // Adjust the key based on your actual JSON structure
      List<SectorThemeModel> sectorStocks = sectorStocksJson.map((data) => SectorThemeModel.fromJson(data)).toList();
      return sectorStocks;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<LedgerReportModel>> fetchLedgerReportDetails(String FromDate, String ToDate) async {
    try {
      final token1 = await getToken1();
      String baseUrl = '${AppConfig.baseUrl2}/api/v1/ledger/statement';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': '$token1',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "clientId": "A0044",
          "from_date": FromDate.toString(),
          "to_date": ToDate.toString(),
          "cocd": "BSE_CASH,NSE_CASH,CD_NSE,MF_BSE,NSE_DLY,NSE_FNO,NSE_SLBM,MTF",
          "trans_type": "all"
        }),
      );

      if (response.statusCode == 200) {
        // Parse the list of transactions
        List<dynamic> jsonData = jsonDecode(response.body)['data'][0]['DATA'];
        List<LedgerReportModel> transactions = jsonData.map((data) => LedgerReportModel.fromJson(data)).toList();

        return transactions;
      } else {
        throw Exception('Failed to load ledger report details');
      }
    } catch (e) {
      throw Exception('Failed to load ledger report details: $e');
    }
  }

  Future<List<FundtransaferModel>> fetchFundTransactionReportDetailsRecipt(String FromDate, String ToDate) async {
    try {
      final token1 = await getToken1();
      String baseUrl = '${AppConfig.baseUrl2}/api/v1/ledger/statement';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': '$token1',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "clientId": "A0044",
          "from_date": FromDate.toString(),
          "to_date": ToDate.toString(),
          "cocd": "BSE_CASH,NSE_CASH,CD_NSE,MF_BSE,NSE_DLY,NSE_FNO,NSE_SLBM,MTF",
          "trans_type": "R"
        }),
      );
      print("===============================${response.body}");
      if (response.statusCode == 200) {
        // Parse the list of transactions
        List<dynamic> jsonData = jsonDecode(response.body)['data'][0]['DATA'];
        List<FundtransaferModel> transactions = jsonData.map((data) => FundtransaferModel.fromJson(data)).toList();

        return transactions;
      } else {
        throw Exception('Failed to load ledger report details');
      }
    } catch (e) {
      throw Exception('Failed to load ledger report details: $e');
    }
  }

  Future<List<FundtransaferModel>> fetchFundTransactionReportDetailsPAYout(String FromDate, String ToDate) async {
    try {
      final token1 = await getToken1();
      String baseUrl = '${AppConfig.baseUrl2}/api/v1/ledger/statement';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': '$token1',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "clientId": "A0044",
          "from_date": FromDate.toString(),
          "to_date": ToDate.toString(),
          "cocd": "BSE_CASH,NSE_CASH,CD_NSE,MF_BSE,NSE_DLY,NSE_FNO,NSE_SLBM,MTF",
          "trans_type": "P"
        }),
      );
      print("===============================${FromDate + ToDate}");
      print(response.body);
      if (response.statusCode == 200) {
        // Parse the list of transactions
        List<dynamic> jsonData = jsonDecode(response.body)['data'][0]['DATA'];
        List<FundtransaferModel> transactions = jsonData.map((data) => FundtransaferModel.fromJson(data)).toList();

        return transactions;
      } else {
        throw Exception('Failed to load ledger report details');
      }
    } catch (e) {
      throw Exception('Failed to load ledger report details: $e');
    }
  }

  Future<List<VoucherBillModel>> fetchVoucherBillDetails(
    String trade_date,
  ) async {
    try {
      final token1 = await getToken1();
      String baseUrl = '${AppConfig.baseUrl2}/api/v1/techexcel/get-scrip-summary';
      String formatDate(String dateStr) {
        DateTime dateTime = DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(dateStr);
        String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);

        return formattedDate;
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': '$token1',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"company_code": "NSE_FNO", "client_id": "A0044", "trade_date": formatDate(trade_date), "mkt_type": "FO"}),
      );
      print(formatDate(trade_date));
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body)['data'];
        List<VoucherBillModel> transactions = jsonData.map((data) => VoucherBillModel.fromJson(data)).toList();

        return transactions;
      } else {
        throw Exception('Failed to Load BIlL Voucher  report details');
      }
    } catch (e) {
      throw Exception('Failed to load BIlL Voucher  report details: $e');
    }
  }

  Future<void> CreateSupportTicket(
    CreateTicketModel request,
  ) async {
    try {
      final String? token = await getToken();

      final url = Uri.parse('${AppConfig.baseUrl3}ticket/create');
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          // 'authToken': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final ticketId = data['data']['ticket_id'].toString();
        Get.to(() => TicketGenereatedScreen(ticketId: ticketId));

        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit bid error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Internal Server Error! $e');
    }
  }

  Future<FetchTicketModelResponse> FetchSupportTicket() async {
    try {
      final String? token = await getToken();

      final url = Uri.parse('${AppConfig.baseUrl3}/ticket/fetch?client_id=A0031');
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          // 'authToken': token ?? '',

          'Content-Type': 'application/json',
        },
      );
      print("____________________________________${response.body}");
      if (response.statusCode == 200) {
        var response1 = FetchTicketModelResponse.fromJson(jsonDecode(response.body));
        return response1;
      } else {
        throw Exception('Failed to submit bid ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Internal Server Error! $e');
    }
  }
}
