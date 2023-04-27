import 'dart:convert';
import 'dart:developer';

import 'package:calendar/api.dart';
import 'package:calendar/controllers/calenderController.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEventController extends GetxController {
  late Events events;
  List<Event> event = [];

  getEvents() async {
    log('message');
    try {
      var controller = Get.put(CalendarController());
      await controller.googleSignIn.signInSilently();
      GoogleSignInAccount? account = controller.googleSignIn.currentUser;
      var t = await account!.authentication;

      log(t.accessToken!);
      if (account != null) {
        final auth.AuthClient? client =
            await controller.googleSignIn.authenticatedClient();
        var calendar = CalendarApi(client!);
        String calendarId = "primary";
        calendar.events.list(calendarId).then((value) async {
          events = value;
          event = value.items!;
          log('Number of events${event.length}');

          event.removeAt(0);
          event = event.reversed.toList();
          update();
          List<Map> localevents = [];

          for (var element in event) {
            localevents.add({
              'name': element.summary,
              'start':
                  '${DateFormat.yMEd().format(element.start!.dateTime!)} at ${DateFormat.jm().format(element.start!.dateTime!)}',
              'end':
                  '${DateFormat.yMEd().format(element.end!.dateTime!)} at ${DateFormat.jm().format(element.end!.dateTime!)}'
            });
          }
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          var name = sharedPreferences.getString('name') ?? '';
          var email = sharedPreferences.getString('email') ?? '';
          var pin = sharedPreferences.getInt('pin') ?? 0;
          var token = await FirebaseMessaging.instance.getToken();

          String res = await ApiManager.fetchPost(
              'events/addevents',
              jsonEncode({
                "name": name,
                'email': email,
                'events': localevents,
                'pin': pin,
                'token': token
              }));
          log(res.toString());
        });
      }
    } catch (e) {
      log('Error creating event $e');
    }
  }
}
