import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {

  static Widget text(
      {String? text,
      FontWeight? fontWeight,
      double? fontSize,
      Color? color,
      TextAlign? textAlign,
      TextOverflow? textOverFlow,
      int? maxLines}) {
    return Text(
      text ?? "",
      style: GoogleFonts.poppins(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      overflow: textOverFlow,
      maxLines: maxLines,
    );
  }

  static showLoadingDialogue(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  static void showNoInternetDialog(BuildContext context)  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}


