import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tradingapp/Profile/CustomerSupport/screen/ticket_screen.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';

class TicketGenereatedScreen extends StatefulWidget {
  final String ticketId;
  const TicketGenereatedScreen({super.key, required this.ticketId});

  @override
  State<TicketGenereatedScreen> createState() => _TicketGenereatedScreenState();
}

class _TicketGenereatedScreenState extends State<TicketGenereatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Genereated'),
        backgroundColor: AppColors.primaryBackgroundColor,
        centerTitle: false,
      ),
      body: Container(
        color: AppColors.primaryBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [Text('Ticket Submited'),
                  Icon(
                    Icons.check_circle,
                    size: 100,
                    color: AppColors.primaryColor,
                  ),
                  Text(
                    '#${widget.ticketId}',
                    style: TextStyle(
                      color: AppColors.primaryColorDark,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your ticket has been genereated successfully',
                    style: TextStyle(
                      color: AppColors.primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(textAlign: TextAlign.center,
                    'Ticket ID #${widget.ticketId} has been successfully assigned to our Support. We will get back to you soon.',
                    style: TextStyle(
                      color: AppColors.primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      isLoading: false,
                      text: "Got It! Thanks",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RaiseTicketScreen()));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
