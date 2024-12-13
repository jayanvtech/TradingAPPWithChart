import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_bloc.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_event.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_state.dart';
import 'package:tradingapp/Authentication/Screens/tpin_screen.dart';
import 'package:tradingapp/Authentication/Screens/forget_password_screen.dart';
import 'package:tradingapp/Authentication/Screens/unblock_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_images_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ChagepasswordScreen extends StatefulWidget {
  const ChagepasswordScreen({super.key});

  @override
  State<ChagepasswordScreen> createState() => _ChagepasswordScreenState();
}

class _ChagepasswordScreenState extends State<ChagepasswordScreen> {
  @override


final _formKey = GlobalKey<FormState>();
  bool isPasswordShow = false;
  bool keepMeSigning = false;
  bool _isLoading = false; // Step 1: Declare this at the class level
  void isLogin({required bool isLogin}) {
    setState(() {
      _isLoading = isLogin;
    });
  }

  final _usernameController = TextEditingController(text: 'A0033');
  final _OldpasswordController = TextEditingController(text: 'Xts@9876');
  final _newpasswordController = TextEditingController(text: 'Xts@9876');
  final _confirmpasswordController = TextEditingController(text: 'Xts@9876');

  String erorrname = 'HUP';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: RadialGradient(
              colors: [
                Colors.white,
                Colors.white70,
                Colors.white,
              ],
              center: Alignment.topLeft,
              radius: 5.0,
              tileMode: TileMode.clamp,
            )),
            child:
                BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
              print(state);
              if (state is LoginSuccess) {
                // Get.snackbar('Success', state.message.toString());
                // Get.to(() =>
                //     ValidPasswordScreen(userID: _usernameController.text));
                // Get.to(() => MainScreen());
              } else if (state is LoginFailure) {
                Get.snackbar('Error', state.error.toString());
              }
            }, builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Text(
                          "Change Password",
                          style:TextStyle(
                              color: AppColors.primaryColorDark,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Your new password must be unique from those previously used.",
                          style: GoogleFonts.inter(
                            color: AppColors.primaryColorDark2,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedMail02,
                              color: AppColors.primaryColorDark2,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Username",
                              style: GoogleFonts.inter(
                                color: AppColors.primaryColorDark11,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          controller: _usernameController,
                          labelText: '',
                          errorMessage: 'username',
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedSquareLock01,
                              color: AppColors.primaryColorDark2,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Old Password",
                              style: TextStyle(
                                color: AppColors.primaryColorDark11,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          controller: _OldpasswordController,
                          labelText: '',
                          errorMessage: 'Password',
                          icon: isPasswordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onClick: () {
                            setState(() {
                              isPasswordShow = !isPasswordShow;
                            });
                          },
                          obscureText: isPasswordShow ? true : false,
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedSquareLock01,
                              color: AppColors.primaryColorDark2,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "New Password",
                              style: GoogleFonts.inter(
                                color: AppColors.primaryColorDark11,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          controller: _newpasswordController,
                          labelText: '',
                          errorMessage: 'Password',
                          icon: isPasswordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onClick: () {
                            setState(() {
                              isPasswordShow = !isPasswordShow;
                            });
                          },
                          obscureText: isPasswordShow ? true : false,
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedSquareLock01,
                              color: AppColors.primaryColorDark2,
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Confirm Password",
                              style: GoogleFonts.inter(
                                color: AppColors.primaryColorDark11,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          controller: _confirmpasswordController,
                          labelText: '',
                          errorMessage: 'Password',
                          icon: isPasswordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onClick: () {
                            setState(() {
                              isPasswordShow = !isPasswordShow;
                            });
                          },
                          obscureText: isPasswordShow ? true : false,
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        
                       
                     
                        InkWell(
                          onTap: () async {
                            if (state is LoginLoading) {
                              setState(() {
                                // isLogin(isLogin: false);
                              });
                            }
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginUserEvent(
                                    userID: _usernameController.text,
                                    password: _newpasswordController.text,
                                  ));
                              // isLogin(
                              //   isLogin: true,
                              // );
                              //   var response =
                              //       await loginUser("A0031", "Xts@987");
                              //   if (response['status']) {
                              //     Get.to(() => ValidPasswordScreen(
                              //       userID: username,
                              //       isFromMainScreen: "true",
                              //     ));
                              //   } else {
                              //     Get.snackbar('Error', response['message']);
                              //   }
                              //   print(response);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                stops: [0.002, 0.7, 0.9],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryGrediantColor1,
                                  AppColors.primaryGrediantColor2,
                                  AppColors.primaryGrediantColor2,
                                ],
                              ),
                            ),
                            child: Center(
                              child: _isLoading // Step 3: Check if loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryColor),
                                    )
                                  : Text("Change Password",
                                      style: TextStyle(
                                          color: AppColors.primaryColorLight3,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        
                        
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            InkWell(
                              onTap: () async {
                                Get.to(() => ForgetPasswordScreen(username: _usernameController.text,));
                              },
                              child: Text(
                                style: TextStyle(
                                    color: AppColors.primaryColor1,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColor1),
                                "Forgot Password?",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            }),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> loginUser(String userID, String password) async {
    try {
      var url =
          Uri.parse('http://14.97.72.10:3000/enterprise/auth/validateuser');
      var response = await http.post(
        url,
        body: jsonEncode({
          "userID": userID.toString(),
          "password": password.toString(),
          "source": "EnterpriseWEB"
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['type'] == 'success') {
          print(jsonResponse['description']);

          Get.to(() => ValidPasswordScreen(userID: userID));
          return {'status': true, 'message': 'Login successful'};
        } else {
          return {'status': false, 'message': jsonResponse['description']};
        }
      } else {
        print(response.body);
        throw Exception('Failed to load API response');
      }
    } catch (e) {
      print(e.toString());
      return {'status': false, 'message': 'An error occurred'};
    }
  }
}
