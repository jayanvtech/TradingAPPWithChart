// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  String? labelText;
  String? hintText;
  IconData? icon;
  VoidCallback? onClick;
  String? errorMessage;
  bool obscureText = false;

  CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.icon,
    this.hintText,
    this.onClick,
    this.errorMessage,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      strutStyle: const StrutStyle(height: 1.0),
      controller: controller,
      focusNode: FocusNode(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.black),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.black),
        ),
        labelText: labelText,
        suffixIcon: IconButton(onPressed: onClick, icon: Icon(icon)),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $errorMessage';
        }
        return null;
      },
    );
  }
}



class SvgPictureClass extends StatelessWidget {
  final String stockSymbol;

  SvgPictureClass({required this.stockSymbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CircleAvatar(
        child: ClipOval(
          child: FutureBuilder(
            future: _checkSvgUrl("https://ekyc.arhamshare.com/img//trading_app_logos//$stockSymbol.svg"),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.data!) {
                return Icon(Icons.error, size: 50);
              } else {
                return SvgPicture.network(
                  "https://ekyc.arhamshare.com/img//trading_app_logos//$stockSymbol.svg",
                  fit: BoxFit.fill,
                  height: 50,
                  semanticsLabel: 'Network SVG',
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _checkSvgUrl(String url) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final result = await response.close();
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
