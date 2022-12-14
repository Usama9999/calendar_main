import 'package:calendar/components/otp/src/otp_pin_field_input_type.dart';
import 'package:calendar/screens/main_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/text_styles.dart';
import '../components/otp/src/otp_pin_field_style.dart';
import '../components/otp/src/otp_pin_field_widget.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double otpwidth = size.width / 9;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Pin',
              style: headingText(17),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 31),
              child: OtpPinField(
                otpPinFieldInputType: OtpPinFieldInputType.none,
                onSubmit: (text) {
                  pinController.text = text;
                },
                otpPinFieldStyle: const OtpPinFieldStyle(
                  defaultFieldBorderColor: Colors.white,
                  activeFieldBorderColor: Colors.white,

                  defaultFieldBackgroundColor: Colors.transparent,
                  activeFieldBackgroundColor: Colors
                      .transparent, // Background Color for active/focused Otp_Pin_Field
                ),
                maxLength: 6,
                highlightBorder: false,
                fieldWidth: otpwidth,
                fieldHeight: otpwidth,
                keyboardType: TextInputType.number,
                autoFocus: true,
                otpPinFieldDecoration:
                    OtpPinFieldDecoration.defaultPinBoxDecoration,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  await sharedPreferences.setInt(
                      'pin', int.parse(pinController.text.trim()));
                  Get.offAll(() => const CalendarApp());
                },
                child: const Text('Create Pin'))
          ],
        ),
      ),
    );
  }
}
