import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';

class ValidPasswordScreen extends StatefulWidget {
  final String? isFromMainScreen;
  final String? userID;

  ValidPasswordScreen({super.key, this.userID, this.isFromMainScreen});

  @override
  State<ValidPasswordScreen> createState() => _ValidPasswordScreenState();
}

class _ValidPasswordScreenState extends State<ValidPasswordScreen> {
  final TextEditingController pinController = TextEditingController();
  String userId = '';

  @override
  void initState() {
    super.initState();
    getId();
  }

  void getId() async {
    // userId = await getUserId() ?? "";
  }

  Future<Map<String, dynamic>> validatePin(String pin) async {
    try {
      var url =
          Uri.parse('http://14.97.72.10:3000/enterprise/auth/validatepin');
      var response = await http.post(
        url,
        body: jsonEncode({
          'userID': widget.isFromMainScreen == "true" ? userId : widget.userID,
          'pin': pin,
          'source': 'EnterpriseWeb',
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonResponse['type'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (jsonResponse['result'] != null &&
            jsonResponse['result']['token'] != null) {
          // storeUserId(userId: jsonResponse['result']['userID']);
          // storeClientId(clientId: jsonResponse['result']['clientCodes'][0]);
          await prefs.setString('token', jsonResponse['result']['token']);
          Get.offAll(() => MainScreen());
        }
        return {'status': true, 'message': 'Pin validation successful'};
      }
      return {'status': false, 'message': jsonResponse['description']};
    } catch (e) {
      return {'status': false, 'message': 'Internal Server Error!'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColors.primaryColorDark2),
    ));

    final submittedPinTheme = defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColors.primaryColor),
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isFromMainScreen == "true"
            ? const SizedBox()
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/LoginScreenImages/OTPScren_illustration.svg',
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ],
              ),
               SizedBox(height: MediaQuery.of(context).size.height * 0.257),
              Text(
                "Enter Your M Pin",
                style: GoogleFonts.inter(
                  color: AppColors.primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Please enter your valid pin",
                style: GoogleFonts.inter(
                  color: AppColors.primaryColorDark2,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Pinput(
                disabledPinTheme: defaultPinTheme,
                controller: pinController,
                length: 6,
                onCompleted: (pin) async {
                  var result = await validatePin(pin);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'])),
                  );
                },
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              
              CustomButton(isLoading: false, text: "Validate PIN", onPressed: ()async{
                 var result = await validatePin(pinController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'])),
                  );
        
              })
              ,
             
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot your pin?",
                    style: GoogleFonts.inter(
                      color: AppColors.primaryColorDark2,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                     
                    },
                    child: Text(
                      "Reset your Code",
                      style: TextStyle(decoration: TextDecoration.underline,
                        color: AppColors.primaryColor,
                        fontSize: 15,
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
  }
}
