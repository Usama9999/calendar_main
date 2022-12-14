import 'dart:developer';

import 'package:calendar/controllers/get_event_controller.dart';
import 'package:calendar/utils/constants.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalendarController extends GetxController {
  final googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope],
  );
  // insert event
  insertEvent(event) async {
    try {
      //get current user instance
      GoogleSignInAccount? account = googleSignIn.currentUser;
      if (account != null) {
        // getting http client to authenticate
        final auth.AuthClient? client =
            await googleSignIn.authenticatedClient();
        var calendar = CalendarApi(client!);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            Get.snackbar('Hurry!', 'Event added to the calendar',
                colorText: AppConstants.white);
            log('Event added in google calendar');
            Get.find<GetEventController>().getEvents();
          } else {
            log("Unable to add event in google calendar");
          }
        });
      }
    } catch (e) {
      log('Error creating event $e');
    }
  }
}
