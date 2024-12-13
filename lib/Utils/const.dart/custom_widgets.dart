// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';

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
    return Container(
      height: 47,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.primaryColorDark2,
          fontSize: 15,
        ),
        strutStyle: StrutStyle(),
        controller: controller,
        focusNode: FocusNode(),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
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
          labelText: labelText,
          suffixIcon: IconButton(onPressed: onClick, icon: Icon(icon, color: AppColors.primaryColorDark2)),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $errorMessage';
          }
          return null;
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
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
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: AppColors.primaryColorLight3,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
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

class AnimatedDoughnutChart extends StatefulWidget {
  const AnimatedDoughnutChart({Key? key}) : super(key: key);

  @override
  State<AnimatedDoughnutChart> createState() => _AnimatedDoughnutChartState();
}

class _AnimatedDoughnutChartState extends State<AnimatedDoughnutChart> {
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    data = [
      _ChartData('Equity', 23, const Color(0xFF7086FD)),
      _ChartData('MF', 25, const Color(0xFF6FD195)),
      _ChartData('Bond', 5, const Color(0xFF07DBFA)),
      _ChartData('Liquid', 10, const Color(0xFFFFAE4C)),
      _ChartData('SGB', 10, const Color(0xFF1F94FF)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SfCircularChart(
          backgroundColor: Colors.transparent,
          legend: Legend(
            textStyle: const TextStyle(color: Colors.black),
            iconHeight: 7,
            iconWidth: 7,
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.right,
          ),
          series: <CircularSeries>[
            // Doughnut Chart Series
            DoughnutSeries<_ChartData, String>(
              legendIconType: LegendIconType.circle,
              dataSource: data,
              dataLabelMapper: (_ChartData data, _) => data.category,
              xValueMapper: (_ChartData data, _) => data.category,
              yValueMapper: (_ChartData data, _) => data.value,
              pointColorMapper: (_ChartData data, _) => data.color,
              dataLabelSettings: const DataLabelSettings(
                alignment: ChartAlignment.far,
                labelIntersectAction: LabelIntersectAction.shift,
                //  /   connectorLineSettings: ConnectorLineSettings(length: '0%'),
                isVisible: true, labelPosition: ChartDataLabelPosition.outside,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
              ),
              enableTooltip: true,
              animationDuration: 1500, // Animation for doughnut
              explode: true, // Explodes the first segment
              explodeIndex: 0, // Default exploded section
              innerRadius: '45%', // This makes it a doughnut chart
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedDoughnutChart(),
  ));
}

class customBoxDecoration extends StatelessWidget {
  final Widget child;
  const customBoxDecoration({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBackgroundColor,
            AppColors.tertiaryGrediantColor1.withOpacity(1),
            AppColors.tertiaryGrediantColor1.withOpacity(1),
          ],
          stops: [0.5, 1, 0.5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(1),
      ),
      child: child,
    );
  }
}

class CustomSelectionButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onPressed;
   final TextStyle? style;
final double? width ;
  CustomSelectionButton({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onPressed,
        this.style,
        this.width

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width?? 100,
        padding: EdgeInsets.all(10),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(7),
          gradient: LinearGradient(
            stops: [0.002, 0.7, 0.9],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSelected
                ? [
                    AppColors.primaryGrediantColor1,
                    AppColors.primaryGrediantColor2,
                    AppColors.primaryGrediantColor2,
                  ]
                : [
                    AppColors.primaryBackgroundColor,
                    AppColors.primaryColorUnselected,
                    AppColors.primaryColorUnselected,
                  ],
          ),
        ),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style:style ??  TextStyle(
            color: isSelected ? AppColors.primaryColorLight3 : AppColors.primaryColorFontUnselected,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class CustomReportContainer extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  GestureTapCallback onTap;

  CustomReportContainer({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.57),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  leadingIcon,
                  size: 35,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primaryColorDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColorDark2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              trailingIcon,
              color: AppColors.primaryColorDark2,
            ),
          ],
        ),
      ),
    );
  }
}




class CustomBuySellnButton extends StatelessWidget {
  final bool isBuy;
  final String text;
  final VoidCallback onPressed;
   final TextStyle? style;
final double? width ;
  CustomBuySellnButton({
    Key? key,
    required this.isBuy,
    required this.text,
    required this.onPressed,
        this.style,
        this.width

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width?? 100,
        padding: EdgeInsets.all(12),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(7),
          gradient: LinearGradient(
            stops: [0.002, 0.7],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isBuy
                ? [
                    AppColors.BuyGreenGredient1,
                    AppColors.BuyGreenGredient2,
             
                  ]
                : [
                    AppColors.SellRedGredient1,
                    AppColors.SellRedGredient2,
            
                  ],
          ),
        ),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style:style ??  TextStyle(
            color: AppColors.primaryBackgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
