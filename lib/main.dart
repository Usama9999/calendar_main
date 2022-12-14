import 'package:calendar/screens/main_app.dart';
import 'package:calendar/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'utils/app_theme_input_dec.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  // await Firebase.initializeApp();
  // checking of user is already logged in
  bool isSignIn = false;
  isSignIn = await GoogleSignIn().isSignedIn();
  runApp(MyApp(
    isSignedIn: isSignIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;
  const MyApp({super.key, required this.isSignedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calender App',
        theme: AppTheme.data(),
        home: isSignedIn ? const CalendarApp() : const SignIn(),
      );
    });
  }
}
