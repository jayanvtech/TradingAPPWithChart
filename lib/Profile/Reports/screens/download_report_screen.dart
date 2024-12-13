import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/app_config.dart';
import 'package:tradingapp/Utils/const.dart/custom_widgets.dart';

class DownloadReportsScreen extends StatefulWidget {
  const DownloadReportsScreen({super.key});

  @override
  State<DownloadReportsScreen> createState() => _DownloadReportsScreenState();
}

class _DownloadReportsScreenState extends State<DownloadReportsScreen> {
  String? selectedItem = 'PnL Summary';
  bool isLoading = false;
  bool isVisible = false;
  final List<String> items = [
    'PnL Summary',
    'Ledger',
    'F&O',
    'Equity',
  ];
  DateTime fromDate = DateTime.now().subtract(Duration(days: 4));
  DateTime toDate = DateTime.now();

  String? selectedYear = "Apr 2024 - March 2025";
  List<String> financialYears = [
    "Apr 2024 - March 2025",
    "Apr 2023 - March 2024",
    "Apr 2022 - March 2023",
    "Apr 2021 - March 2022",
    "Apr 2020 - March 2021"
  ];
  TextEditingController financialYearsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    financialYearsController.text = selectedYear.toString();
  }

  final String baseurl = AppConfig.reportsUrl;

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate))
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: 
        PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
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
                borderRadius: BorderRadius.circular(1)),
              
            
        child: AppBar(backgroundColor: Colors.transparent,
          title: Text('Download Reports'),
        ),),
        
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiaryGrediantColor1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(selectedItem!),
                  trailing: isVisible
                      ? Icon(Icons.arrow_drop_down)
                      : Icon(Icons.arrow_drop_up),
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        child: Text(items[index]),
                        onTap: () {
                          setState(() {
                            selectedItem = items[index];
                            isVisible = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // TextFormField(
            //   readOnly: true,
            //   controller: TextEditingController(
            //       text: DateFormat('yyyy-MM-dd').format(fromDate)),
            //   decoration: InputDecoration(
            //     suffixIcon: Icon(Icons.calendar_month_outlined),
            //     labelText: 'From Date',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   onTap: () => selectDate(context, true),
            // ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: financialYearsController.text,
              ),
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_month_outlined),
                labelText: 'Financial Year',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () => _showBottomSheet(context, updateYear),
            ),
            SizedBox(
              height: 10,
            ),
             CustomButton(isLoading: isLoading, text: "Download", onPressed: () async {
                  await downloadFile();
                }),
          ],
        ),
      ),
    );
  }

  Future<File> downloadFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      var headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('$baseurl/v1/user/report/pnl?source=trading_app'));
      request.body = json.encode({
        "download_type": "PDF",
        "type": GetReportType(selectedItem),
        "client_code": "A0031",
        "year": int.parse(GetFinacialYear(selectedYear)),
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
print(response.statusCode);
      if (response.statusCode == 200) {
        var bytes = await response.stream.toBytes();
        Directory dir = (await getApplicationDocumentsDirectory());
        String newPath = '';
        if (Platform.isAndroid) {
          newPath = '${dir.path}/Download';
        } else if (Platform.isIOS) {
          newPath = '${dir.path}';
        }
        File file = new File('$newPath/report.pdf');
        setState(() {
          isLoading = false;
        });
        OpenFile.open(file.path);
        await file.writeAsBytes(bytes);
        print('File downloaded to $newPath');

        return file;
      
      } else {
        throw Exception('Failed to load file $e' );
      }
    } catch (e) {
      print(e);
      return File(e.toString());
    }
  }

  String GetReportType(selectedItem) {
    switch (selectedItem) {
      case "PnL Summary":
        return 'pnl';
      case "Ledger":
        return 'ledger';
      case "F&O":
        return 'fno';
      case "Equity":
        return 'eq';

      default:
        return 'Unknown';
    }
  }

  String GetFinacialYear(selectedYear) {
    switch (selectedYear) {
      case "Apr 2024 - March 2025":
        return '2024';
      case "Apr 2023 - March 2024":
        return '2023';
      case "Apr 2022 - March 2023":
        return '2022';
      case "Apr 2021 - March 2022":
        return '2021';
      case "Apr 2020 - March 2021":
        return '2020';

      default:
        return 'Unknown';
    }
  }

  void _showBottomSheet(BuildContext context, Function(String) updateYear) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: financialYears.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            trailing: selectedYear == financialYears[index]
                                ? Icon(Icons.check)
                                : null,
                            title: Text(financialYears[index]),
                            onTap: () {
                              setState(() {
                                selectedYear = financialYears[index];
                              });
                              updateYear(financialYears[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void updateYear(String year) {
    setState(() {
      financialYearsController.text = year;
    });
  }
}
