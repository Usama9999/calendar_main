import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiManager {
  static var client = http.Client();
  static String apiUrl = 'https://healercare-b6b7f.el.r.appspot.com';

  // static String apiUrl = 'https://192.168.250.64:5000';

  static Future<String> fetchPost(url, var body) async {
    var response = await client.post(
        Uri.parse('https://healercare-b6b7f.el.r.appspot.com/events/addevents'),
        headers: {"Content-Type": "application/json"},
        body: body);
    log(response.body.toString());
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return jsonString;
    }
    return '404';
  }
}
