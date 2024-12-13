import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tradingapp/Utils/common_text.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

class CustomDetailsCard extends StatelessWidget {
  final String? title;
  final String? leadingText;
  final String? subtitle;
  final GestureTapCallback onTap;
  final bool? isShowLeadingText;
  final EdgeInsetsGeometry? padding;

  CustomDetailsCard({
    this.title,
    this.subtitle,
    required this.onTap,
    this.leadingText,
    this.isShowLeadingText,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          !(isShowLeadingText ?? false)
              ? SizedBox()
              : Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greyColor.withOpacity(0.57),
                        spreadRadius: 0,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBackgroundColor,
                        AppColors.tertiaryGrediantColor3,
                        AppColors.tertiaryGrediantColor1.withOpacity(1),
                        AppColors.primaryBackgroundColor,
                        AppColors.tertiaryGrediantColor3,
                      ],
                      stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: CommonText(
                      text: leadingText ?? '',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          Flexible(
            child: Container(
              padding: padding ?? EdgeInsets.all(15.h),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyColor.withOpacity(0.57),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor3,
                    AppColors.tertiaryGrediantColor1.withOpacity(1),
                    AppColors.primaryBackgroundColor,
                    AppColors.tertiaryGrediantColor3,
                  ],
                  stops: [0.1, 0.9, 0.9, 0.4, 0.51],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title ?? '',
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    fontSize: 14.sp,
                  ),
                  if (subtitle?.isNotEmpty ?? false)
                    CommonText(
                      text: subtitle ?? '',
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      color: AppColors.primaryColorDark2,
                    ),
                ],
              ),
              /*ListTile(
                  title: CommonText(
                    text: title ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  subtitle: CommonText(
                    text: subtitle ?? '',
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                    textColor: AppColors.primaryColorDark2,
                  ),
                )*/
            ),
          ),
        ],
      ),
    );
  }
}
