import 'package:calendar/controllers/get_event_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/sign_in_screen.dart';
import 'calenderController.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  if (message.data.containsKey('screen')) {
    if (message.data['screen'] == 'getEvent') {
      Firebase.initializeApp();

      var event = Get.put(GetEventController());
      var calendar = Get.put(CalendarController());

      await calendar.googleSignIn.signInSilently();
      if (calendar.googleSignIn.currentUser != null) {
        event.getEvents();
      }
    }
  }
}

class CalenderAppController extends GetxController {
  late TabController tabController;

  int tabIndex = 0;
  String email = '';
  String name = '';
  String pic = '';

  // get user locally saved data
  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    pic = sharedPreferences.getString('pic') ?? '';
    name = sharedPreferences.getString('name') ?? '';
    email = sharedPreferences.getString('email') ?? '';
    update();
  }

  changeIndex(int index) {
    tabIndex = index;
    update();
  }

  signout() async {
    await GoogleSignIn().signOut();
    Get.offAll(() => const SignIn());
  }

  Future<void> pushNotifications() async {
    // 2. Instantiate Firebase Messaging
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {
      print('User declined or has not accepted permission');
    }
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    var token = await _messaging.getToken();
    print('token $token');
  }
}
