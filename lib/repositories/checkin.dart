import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/models/checkin.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class CheckinRepository {

  Future<void> checkin(
      {required String employeeId,
      required String image,
      required String latitude,
      required String longitude,
      required String address,
      required String dateTime}) async {
    try {
      print("date time ${DateTime.now()}");
      print("employee id ${employeeId}");
      var request =
          http.MultipartRequest("POST", Uri.parse("$base_url/api/inspections"));
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['datetime'] = dateTime.toString();

      request.fields['address'] = address;
      request.fields['employee_id'] = employeeId;
      var picture = await http.MultipartFile.fromPath('image', image);

      request.files.add(picture);
      // print("${DateFormat("yyyy-mm-dd HH:mm:ss").format(DateTime.now())}");

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      // throw "${response.stream}";
      print("data ${respStr}");

      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Data has been saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: respStr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<List<CheckinModel>> fetchChecin(String employeeId) async {
    try {
      final response = await http.get(
          Uri.parse("$base_url/api/employees/${employeeId}/inspections"),
          headers: {'Content-Type': 'application/json; charset=utf-8'});

      final data = jsonDecode(response.body);
      List<CheckinModel> list = CheckinModel.fromJsonToList(data['data']);

      return list;
    } on Exception catch (e) {
      throw "${e}";
    }
  }

  Future<List<CheckinModel>> fetchChecinday(
      String employeeId, startDate, endDate) async {
    try {
      final response = await http.get(
          Uri.parse(
              "$base_url/api/employees/${employeeId}/inspections?start_date=${startDate}&end_date=${endDate}"),
          headers: {'Content-Type': 'application/json; charset=utf-8'});

      final data = jsonDecode(response.body);
      List<CheckinModel> list = CheckinModel.fromJsonToList(data['data']);

      return list;
    } on Exception catch (e) {
      throw "${e}";
    }
  }
}
