// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tradingapp/Authentication/Login_bloc/login_bloc.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_event.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_state.dart';
import 'package:tradingapp/Authentication/Screens/tpin_screen.dart';
import 'package:tradingapp/Authentication/Screens/forget_password_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_images_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  final _passwordController = TextEditingController(text: 'Xts@9876');

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
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/AppIcon/TradeMaster.svg",
                              height: 200,
                            ),
                          ],
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.inter(
                              color: AppColors.appCommonColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Welcome back to the app",
                          style: GoogleFonts.inter(
                            color: AppColors.textGreyColor,
                            fontSize: 17,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Username",
                              style: GoogleFonts.inter(
                                color: AppColors.textBlackColor,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                            Text(
                              "Password",
                              style: GoogleFonts.inter(
                                color: AppColors.textBlackColor,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
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
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.to(() => ForgetPasswordScreen(
                                      username: _usernameController.text));
                                },
                                child: Text(
                                  "Forget Password? ",
                                  style: GoogleFonts.inter(
                                      color: AppColors.greenTextColor,
                                      fontSize: 13),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: AppColors.commonButtonColor,
                              value: keepMeSigning,
                              onChanged: (value) {
                                setState(() {
                                  keepMeSigning = value ?? false;
                                });
                              },
                            ),
                            Text(
                              "Keep me signed in",
                              style: GoogleFonts.inter(
                                  color: AppColors.textGreyColor, fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            if (state is LoginLoading) {
                              setState(() {
                                isLogin(isLogin: false);
                              });
                            }
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginUserEvent(
                                    userID: _usernameController.text,
                                    password: _passwordController.text,
                                  ));
                              isLogin(
                                isLogin: true,
                              );
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
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                stops: [0.1, 0.5, 0.7, 0.9],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue[300]!,
                                  Colors.blue,
                                  Colors.blue[400]!,
                                  Colors.blue[400]!,
                                ],
                              ),
                            ),
                            child: Center(
                              child: _isLoading // Step 3: Check if loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.textWhiteColor),
                                    )
                                  : Text(
                                      "Login",
                                      style: GoogleFonts.inter(
                                          color: AppColors.textWhiteColor,
                                          fontSize: 18),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
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
