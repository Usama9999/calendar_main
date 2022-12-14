import 'dart:developer';

import 'package:calendar/components/primary_button.dart';
import 'package:calendar/screens/pin_screen.dart';
import 'package:calendar/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage you calendar with easy steps.',
              style: headingText(18),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Please login to continue',
              style: normalText(16),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(label: 'Sign in', onPress: _signin),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signin() async {
    {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[CalendarApi.calendarScope, 'email'],
      );
      GoogleSignInAccount? acc = await googleSignIn.signIn();
      if (acc != null) {
        saveData(acc).whenComplete(() {
          Get.to(() => const PinScreen());
        });
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            content: Text('Error while sign in pLease try again')));
      }
    }
  }

// saving user info locally
  Future<void> saveData(GoogleSignInAccount acc) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('email', acc.email);
    log(acc.email);
    if (acc.displayName != null) {
      await sharedPreferences.setString('name', acc.displayName.toString());
    }
    if (acc.photoUrl != null) {
      await sharedPreferences.setString('pic', acc.photoUrl.toString());
    }
  }
}
