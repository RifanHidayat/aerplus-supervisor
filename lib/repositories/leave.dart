import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/models/permission.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class LeaveRepository {
  final LEAVE_API_URL = "${base_url}/api/leave-applications";

  Future<List<PermissionModel>> fetchLeaveEmployee(num id) async {
    var response = await http.get(Uri.parse("${LEAVE_API_URL}"));
    var data = json.decode("${response.body}");
    List<PermissionModel> list = PermissionModel.fromJsonToList(data['data']);

    return list;
  }

  Future<void> leaveSubmission({
    required String dates,
    required String description,
    required String employeeId,
    required BuildContext context,
  }) async {
    print("id ${employeeId}");
    final response = await http.post(Uri.parse("${LEAVE_API_URL}"), body: {
      "employee_id": employeeId.toString(),
      "leave_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "note": description,
    });
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
     Navigator.pop(context,'update');
    } else {
      print("error ${res.toString()}");
      throw Exception("message ${res['message'].toString()}");
    }
  }

  // Future<void> leaveSubmission(
  //     {required String dates,
  //       required String description,
  //       required String employeeId,
  //       required String numberOfDayes}) async {
  //   final response =
  //   await http.post(Uri.parse("${LEAVE_API_URL}"), body: {
  //     "employee_id": employeeId,
  //     "dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
  //     "number_of_days": numberOfDayes,
  //     "description": description,
  //     "status": "pending"
  //   });
  //   final res = jsonDecode(response.body);
  //   if (res['code'] == 200) {
  //     Get.back();
  //   } else {
  //     throw Exception("${res['message'].toString()}");
  //   }
  // }

  // Future<void> editleaveSubmission(
  //     {
  //       required String id,
  //       required String dates,
  //       required String description,
  //       required String employeeId,
  //       required String numberOfDayes}) async {
  //   final response =
  //   await http.post(Uri.parse("${LEAVE_API_URL}"), body: {
  //     "employee_id": employeeId,
  //     "dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
  //     "number_of_days": numberOfDayes,
  //     "description": description,
  //     "status": "pending"
  //   });
  //   final res = jsonDecode(response.body);
  //   if (res['code'] == 200) {
  //     Get.back();
  //   } else {
  //     throw Exception("${res['message'].toString()}");
  //   }
  // }

  Future<void> EditleaveSubmission({
    required String dates,
    required String description,
    required String employeeId,
    required String id,
    required String date,
    required BuildContext context
  }) async {
    print("id ${employeeId.toString()}");
    final response =
        await http.post(Uri.parse("${LEAVE_API_URL}/${id}"), body: {
      "employee_id": employeeId.toString(),
      "leave_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
      "note": description,
      "date": date.toString()
    });
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context,'update');
    } else {
      print("error ${res.toString()}");
      throw Exception("message ${res['message'].toString()}");
    }
  }

  Future<void> deleteLeaveSubmission({
    required String id,
    required BuildContext context
  }) async {
    final response = await http.delete(Uri.parse("${LEAVE_API_URL}/${id}"));

    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context,'update');
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
    // if (res['code'] == 200) {
    //   Get.back();
    // } else {
    //   throw Exception("${res['message'].toString()}");
    // }
  }
}
