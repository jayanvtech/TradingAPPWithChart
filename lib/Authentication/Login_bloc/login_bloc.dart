import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_event.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_state.dart';
import 'package:tradingapp/Authentication/auth_services.dart';
import 'package:tradingapp/Authentication/biomatric_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_config.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var baseUrl =AppConfig.baseUrl;
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>((event, emit) async {
      emit(LoginLoading());
      var result = await loginUser(event.userID, event.password);
      if (result['status']) {
        emit(LoginSuccess(message: result['message'].toString()));
      } else if (!result['status']) {
        emit(LoginFailure(error: result['message'].toString()));
      }
      var result2 = await loginUserSession(event.userID, event.password);
      if (result2['status']) {
        emit(LoginSuccess(message: result2['message'].toString()));
      } else if (!result2['status']) {
        emit(LoginFailure(error: result2['message'].toString()));
      }
    });

    on<LoginSuccessEvent>((event, emit) {
      emit(LoginSuccess(message: event.message));
    });

    on<LoginErrorEvent>((event, emit) {
      emit(LoginFailure(error: event.error));
    });
  } //a0031
  String jsonString =
      r'{"secretKey": "Seqj466$KN", "appKey": "f9abb9466f50ae84119284", "source": "WebAPI"}';

  Future<Map<String, dynamic>> loginUser(String userID, String password) async {
    try {
      var url =
          Uri.parse('$baseUrl/apimarketdata/auth/login');
      var response = await http.post(
        url,
        body: jsonEncode({
          "secretKey": r'Seqj466$KN',
          "appKey": "f9abb9466f50ae84119284", "source": "WebAPI",
          //a0886
          // "secretKey": r'Jaha604$Y#',
          // "appKey": "a383102c9c88584ab61447",
          // "source": "WebAPI",
          // "userID": userID,
          // "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse['type'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (jsonResponse['result'] != null &&
              jsonResponse['result']['token'] != null) {
            // Assuming 'clientCodes' is an array and you're interested in the first element
            // String clientCode = jsonResponse['result']['clientCodes'] != null &&
            //         jsonResponse['result']['clientCodes'].isNotEmpty
            //     ? jsonResponse['result']['clientCodes'][0]
            //     : '';

            await prefs.setString('userID', "A0031");
            await prefs.setString('clientCode', "A0031");
            await prefs.setString('token', jsonResponse['result']['token']);

            // Navigate to MainScreen
            Get.offAll(() => PinAuthenticationScreen());

            return {
              'status': true,
              'message': 'Login successful',
              'data': jsonResponse['result']
            };
          } else {
            return {
              'status': false,
              'message': 'Token not found in the response'
            };
          }
        } else {
          return {'status': false, 'message': jsonResponse['description']};
        }
      } else {
        return {'status': false, 'message': 'Failed to connect to the server'};
      }
    } catch (e) {
      return {'status': false, 'message': 'An error occurred: $e'};
    }
  }
}

Future<Map<String, dynamic>> loginUserSession(
    String userID, String password) async {
      var baseUrl =AppConfig.baseUrl;
  try {
    var url =
        Uri.parse('$baseUrl/interactive/user/session');
    var response = await http.post(
      url,
      body: jsonEncode({
        // "secretKey": r"Sjdn870$9y",
        // "appKey": "5647cac2f14e34ef1a3619",
        // "source": "WebAPI"

        // Yash Mehta - A0031
        "secretKey": "Neae763#@w",
        "appKey": "0ba099c48f4fc0e2519862",
        "source": "WEBAPI"

        // "userID": userID,
        // "password": password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse['type'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (jsonResponse['result'] != null &&
            jsonResponse['result']['token'] != null) {
          //  Assuming 'clientCodes' is an array and you're interested in the first element
          // String clientCode = jsonResponse['result']['clientCodes'] != null &&
          //         jsonResponse['result']['clientCodes'].isNotEmpty
          //     ? jsonResponse['result']['clientCodes'][0]
          //     : '';

          await prefs.setString('userID', "A0031");
          await prefs.setString('clientCode', "A0031");
          await prefs.setString('token1', jsonResponse['result']['token']);
          // print(" Session token: ${jsonResponse['result']['token']}");
          // print("authtoken session called now ");
          // Navigate to MainScreen
          String? token = await getToken1();
          print("Session token printedd: $token");
          String? apiToken = await getToken();
          print("Main  token printedd: $apiToken");
          // Get.offAll(() => MainScreen());

          return {
            'status': true,
            'message': 'Login successful',
            'data': jsonResponse['result']
          };
        } else {
          return {
            'status': false,
            'message': 'Token not found in the response'
          };
        }
      } else {
        return {'status': false, 'message': jsonResponse['description']};
      }
    } else {
      return {'status': false, 'message': 'Failed to connect to the server'};
    }
  } catch (e) {
    return {'status': false, 'message': 'An error occurred: $e'};
  }
}
