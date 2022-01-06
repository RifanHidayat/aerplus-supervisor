import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/pages/track/track.dart';
import 'package:superviso/sesion/sesion.dart';

Session session = new Session();

class Repositories {
  var base_url = "https://ec4b-202-80-217-113.ngrok.io";

  Future<void> loginEmployee(
      BuildContext context, var username, var password) async {
    try {
      final body = jsonEncode({
        "username": "${username.toString()}",
        "password": "${password.toString()}"
      });
      final response = await http.post("$base_url/api/hrd-auth/signin",
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: body);

      final data = jsonDecode(response.body);

      if (data['code'] == 200) {
        session.saveData(username.toString(), "", data['data']['id']);
        if (data['data']['credential']['mobileAccessType'] == "regular") {
          Get.to(TrackPage());
        } else {}
      } else {
        print("ts${data['message']}");
      }
    } on Exception catch (e) {
      print("error ${e}");
    }
  }
}
