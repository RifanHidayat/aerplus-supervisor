import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/nav.dart';
import 'package:superviso/pages/track/track.dart';
import 'package:superviso/repositories/api.dart';
import 'package:superviso/sesion/sesion.dart';

class AuthRepository {
  Session session = new Session();

  Future<void> auth(
      {required String username, required String password}) async {
    try {
      print("data");
      final body = jsonEncode({
        "username": "${username.toString()}",
        "password": "${password.toString()}"
      });
      final response = await http.post(
          Uri.parse("$base_url/api/hrd-auth/mobile/signin/admin"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: body);

      final data = jsonDecode(response.body);
      print("data ${data}");

      if (data['code'] == 200) {
        session.saveData(username.toString(), "", data['data']['id'], true,
            data['data']['name']);
        final service = FlutterBackgroundService();
        service.start();
        Get.offAll(Nav());

        // if (data['data']['credential']['mobileAccessType'] == "regular") {
        //   Get.offAll(Nav());
        // } else {
        //   throw "Have no access to this app";
        // }
      } else {
        throw "${data['message']}";
      }
    } on Exception catch (e) {
      throw "${e}";
    }
  }
}
