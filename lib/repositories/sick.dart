import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/models/sick.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class SickRepository {
  final SICK_API_URL = "${base_url}/api/sick-applications";

  Future<List<SickModel>> fetchSickEmployee(num id) async {
    var response = await http.get(Uri.parse("${SICK_API_URL}"));
    var data = json.decode("${response.body}");
    List<SickModel> list = SickModel.fromJsonToList(data['data']);

    return list;
  }

  Future<void> sickSubmission(
      {required String dates,
      required String description,
      required String employeeId,
      required String attahment,
      required String numberOfDayes,
      required BuildContext context}) async {
    try {
      print("photo ${attahment}");
      if (attahment == null || attahment == "null" ) {
        var request =
            http.MultipartRequest("POST", Uri.parse("${SICK_API_URL}"));
        request.fields['employee_id'] = employeeId.toString();
        request.fields['sick_dates'] =
            dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), '');
        request.fields['note'] = description.toString();

        request.fields['date'] =
            DateFormat("yyyy-MM-dd").format(DateTime.now());

        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        // throw "${response.stream}";
        print("data ${respStr}");
        if (response.statusCode == 200) {
          Navigator.pop(context, 'update');
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
      } else {
        var request =
            http.MultipartRequest("POST", Uri.parse("${SICK_API_URL}"));
        request.fields['employee_id'] = employeeId.toString();
        request.fields['sick_dates'] =
            dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), '');
        request.fields['note'] = description.toString();

        request.fields['date'] =
            DateFormat("yyyy-MM-dd").format(DateTime.now());

        var picture =
            await http.MultipartFile.fromPath('attachment', attahment);

        request.files.add(picture);
        // print("${DateFormat("yyyy-mm-dd HH:mm:ss").format(DateTime.now())}");

        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        // throw "${response.stream}";
        print("data ${respStr}");
        if (response.statusCode == 200) {
          Navigator.pop(context, 'update');
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
    // final response = await http.post(Uri.parse("${SICK_API_URL}"), body: {
    //   "employee_id": employeeId.toString(),
    //   "sick_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
    //   "note": description,
    //   "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    //   // 'attachment': 'null',
    // });

    // //print(response);
    // final res = jsonDecode(response.body);
    // print("error ${res}");
    // if (response.statusCode == 200) {
    //   Get.back();
    // } else {
    //   throw Exception("erro ${res['errors'].toString()}");
    // }
  }

  Future<void> editSickSubmission(
      {required String dates,
      required String date,
      required String description,
      required String employeeId,
      required String numberOfDayes,
      required String attahment,
      required String id,
      required BuildContext context}) async {
    try {

      var request =
          http.MultipartRequest("POST", Uri.parse("${SICK_API_URL}/${id}"));
      request.fields['employee_id'] = employeeId.toString();
      request.fields['sick_dates'] =
          dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), '');
      request.fields['note'] = description.toString();

      request.fields['date'] = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var picture = await http.MultipartFile.fromPath('attachment', attahment);

      request.files.add(picture);
      // print("${DateFormat("yyyy-mm-dd HH:mm:ss").format(DateTime.now())}");

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      // throw "${response.stream}";
      print("data ${respStr}");

      if (response.statusCode == 200) {
        Navigator.pop(context, 'update');
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
    // print(employeeId.toString());
    // final response = await http.post(Uri.parse("${SICK_API_URL}/${id}"), body: {
    //   "employee_id": employeeId.toString(),
    //   "sick_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
    //   "note": description,
    //   "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    //   // 'attachment': 'null',
    // });
    //
    // //print(response);
    // final res = jsonDecode(response.body);
    // print("error ${res}");
    // if (response.statusCode == 200) {
    //   Get.back();
    // } else {
    //   throw Exception("erro ${res['errors'].toString()}");
    // }
  }

  // Future<void> editSubmission(
  //     {required int id,
  //     required String dates,
  //     required String description,
  //     required String employeeId,
  //     required String numberOfDayes}) async {
  //   final response =
  //       await http.patch(Uri.parse("${SICK_API_URL}/${id}"), body: {
  //     "employeeId": employeeId,
  //     "sickDates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
  //     "note": description,
  //     "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //     'attachment': 'null',
  //   });
  //   //print(response);
  //   final res = jsonDecode(response.body);
  //   if (res['code'] == 200) {
  //     Get.back();
  //   } else {
  //     throw Exception("${res['message'].toString()}");
  //   }
  // }

  Future<void> deleteSickSubmission(
      {required String id, required BuildContext context}) async {
    final response = await http.delete(Uri.parse("${SICK_API_URL}/${id}"));

    final res = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.pop(context, 'update');
      Fluttertoast.showToast(
          msg: "Data berhasil dihapus",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      throw Exception("${res['message'].toString()}");
    }
  }

  Future<List<SickModel>> sicks(var id) async {
    var response = await http.get(Uri.parse("${SICK_API_URL}"));
    final data = jsonDecode(response.body);
    print("data ${data}");
    List<SickModel> list = SickModel.fromJsonToList(data['data']);
    return list;
  }
}
