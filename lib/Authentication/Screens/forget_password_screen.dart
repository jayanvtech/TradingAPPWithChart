import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_images_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String username;
  const ForgetPasswordScreen({super.key, required this.username});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController usernameController;
  late TextEditingController dateController;
  late TextEditingController panCardController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController = TextEditingController();
    panCardController = TextEditingController();

    usernameController = TextEditingController(text: widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.primaryBackgroundColor,
        leadingWidth: 80,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            enableFeedback: false,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 15,
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedArrowLeft01,
                      color: Colors.black,
                      size: 17,
                    ),
                    Text("Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/LoginScreenImages/Password_illustration.svg",
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: AppColors.primaryColorDark,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "Please fill these details, We will send you New Password on registered email.",
                style: TextStyle(
                  color: AppColors.primaryColorDark2,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedMail01,
                    color: AppColors.primaryColorDark2,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Username",
                    style: GoogleFonts.inter(
                      color: AppColors.primaryColorDark2,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                controller: usernameController,
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
                    HugeIcons.strokeRoundedCalendar04,
                    color: AppColors.primaryColorDark2,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Date of Birth",
                    style: GoogleFonts.inter(
                      color: AppColors.primaryColorDark2,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
             
              Container(height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "12/03/2002",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: AppColors.primaryColorDark2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: AppColors.primaryColorDark2),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          dateController.text =
                              DateFormat('dd-MMM-yyyy').format(date);
                        }
                      },
                      icon:  Icon(HugeIcons.strokeRoundedCalendarAdd01,color: AppColors.primaryColorDark2,),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedDocumentValidation,
                    color: AppColors.primaryColorDark2,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Pan Number",
                    style: GoogleFonts.inter(
                      color: AppColors.primaryColorDark2,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                
                
                controller: panCardController,
                hintText: "FSDPP3387F",
                errorMessage: 'Pan Number',
                obscureText: false,
              ),
              // TextFormField(
              //   keyboardType: TextInputType.text,
              //   textInputAction: TextInputAction.next,
              //   controller: panCardController,
              //   decoration: InputDecoration(
              //     hintText: "FSDPP3387F",
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(5.0),
              //       ),
              //       borderSide: BorderSide(color: AppColors.primaryColorDark2),
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(5.0),
              //       ),
              //       borderSide: BorderSide(color: AppColors.primaryColorDark2),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                isLoading: false,
                onPressed: () {
                  // showAboutDialog(
                  //   context: context,
                  //   applicationIcon: Icon(Icons.person),
                  // );
                },
                text: 'Verify',
              ),
            ],
          ),
        ),
      ),
      // body: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Column(children: [
      //       TextFormField(
      //           controller: usernameController,
      //           decoration: const InputDecoration(
      //             prefixIcon: Icon(Icons.person),
      //             labelText: 'Username',
      //           )),
      //       TextFormField(
      //         keyboardType: TextInputType.datetime,
      //         textInputAction: TextInputAction.next,
      //         controller: dateController,
      //         decoration: InputDecoration(
      //           prefixIcon: const Icon(Icons.date_range_outlined),
      //           labelText: 'Date of Birth',
      //           suffixIcon: IconButton(
      //             onPressed: () async {
      //               final date = await showDatePicker(
      //                 context: context,
      //                 initialDate: DateTime.now(),
      //                 firstDate: DateTime(1900),
      //                 lastDate: DateTime.now(),
      //               );
      //               if (date != null) {
      //                 dateController.text =
      //                     DateFormat('dd-MMM-yyyy').format(date);
      //               }
      //             },
      //             icon: const Icon(Icons.calendar_today),
      //           ),
      //         ),
      //       ),
      //       TextFormField(
      //         textInputAction: TextInputAction.next,
      //         decoration: const InputDecoration(
      //           prefixIcon: Icon(Icons.edit_document),
      //           labelText: 'Pan Number',
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       SizedBox(
      //           width: double.infinity,
      //           height: 50.0,
      //           child: ElevatedButton(
      //               onPressed: () {
      //                 showDialog(
      //                     context: context,
      //                     builder: (context) {
      //                       return AlertDialog(
      //                         //title: Text('Verification'),
      //                         content: SizedBox(
      //                           height: 350,
      //                           child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               // Text('Verification'),
      //
      //                               Image.asset(
      //                                 'assets/done.png',
      //                                 width: 200,
      //                                 height: 200,
      //                               ),
      //                               const SizedBox(
      //                                 height: 10,
      //                               ),
      //                               const Text(
      //                                 "Congratulations!",
      //                                 style: TextStyle(
      //                                     fontSize: 20,
      //                                     fontWeight: FontWeight.bold),
      //                               ),
      //                               const Center(
      //                                 child: Text(
      //                                     textAlign: TextAlign.center,
      //                                     'An email has been sent to your registered email address. Please check your email and follow the instructions to reset your password.'),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         actions: [
      //                           TextButton(
      //                               onPressed: () {
      //                                 Navigator.pop(context);
      //                               },
      //                               child: const Text('OK'))
      //                         ],
      //                       );
      //                     });
      //                 // showAboutDialog(
      //                 //   context: context,
      //                 //   applicationIcon: Icon(Icons.person),
      //                 // );
      //               },
      //               style: ButtonStyle(
      //                   foregroundColor:
      //                       MaterialStateProperty.all(Colors.white),
      //                   backgroundColor: MaterialStateProperty.all(Colors.blue),
      //                   shape:
      //                       MaterialStateProperty.all<RoundedRectangleBorder>(
      //                           RoundedRectangleBorder(
      //                               borderRadius:
      //                                   BorderRadius.circular(15.0)))),
      //               child: const Text('Verify')))
      //     ])),
    );
  }
}
