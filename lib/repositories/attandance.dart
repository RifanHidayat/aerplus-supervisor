import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/models/attendance.dart';
import 'package:superviso/models/employee.dart';
import 'package:superviso/repositories/api.dart';

class AttendanceRepository {
  final ATTENDANCE_API_URL = "${base_url}/api/attendances";

  Future<List<AttendanceModel>> getAttendances() async {
    var response =
        await http.get(Uri.parse("${ATTENDANCE_API_URL}/api/v1/attendance"));
    final data = jsonDecode(response.body);
    List<AttendanceModel> list = AttendanceModel.fromJsonToList(data['data']);

    return list;
    // Iterable e = json.decode(response.body);
    // List<AttendanceModel> employees =
    //     e.map((e) => AttendanceModel.fromJson(e['data'])).toList();
    // return employees;
  }

  Future<EmployeeModel> getEmployeeByEmployee(num id) async {
    var response = await http.get(Uri.parse("$ATTENDANCE_API_URL/${id}"));
    var e = json.decode("${response.body}");

    print("dta ${response.body}");
    EmployeeModel employees = EmployeeModel.fromJson(e['data']);
    return employees;
  }

  Future<void> checkin(
      {required String employeeId,
      required latitude,
      required longitude,
      required status,
      required note,
      required image,
      required officeLatitude,
      required officeLongitude,
      required workingPatternId,required context}) async {
    final ipv4 = await Ipify.ipv4();

    if (image != null) {
      var request = http.MultipartRequest(
          "POST", Uri.parse("$ATTENDANCE_API_URL/action/clockin"));
      request.fields['employee_id'] = employeeId.toString();
      request.fields['working_pattern_id'] = workingPatternId.toString();
      request.fields['date'] =
          DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      request.fields['clock_in'] =
          DateFormat("HH:mm:dd").format(DateTime.now()).toString();
      request.fields['clock_in_at'] =
          DateFormat("yyyy-MM-dd HH:mm:dd").format(DateTime.now());
      request.fields['clock_in_device_detail'] = "1";
      request.fields['clock_in_ip_address'] = "1";
      request.fields['clock_in_latitude'] = latitude.toString();
      request.fields['clock_in_longitude'] = longitude.toString();
      request.fields['clock_in_office_latitude'] = officeLongitude.toString();
      request.fields['clock_in_office_longitude'] = officeLongitude.toString();
      request.fields['note'] = note;
      var picture = await http.MultipartFile.fromPath('attachment', image);
      request.files.add(picture);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      // throw "${response.stream}";
      print("data ${respStr}");

      if (response.statusCode == 200) {
        Get.back();
        Navigator.pop(context,'back');
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

      final data = jsonEncode({
        "employee_id": "9",
        "clock_in_latitude": latitude,
        "clock_in_longitude": longitude,
        "note": note,
        "working_pattern_id": workingPatternId.toString(),
        // "attachment": image,
        "clock_in_ip_address": ipv4.toString(),
        "clock_in_office_latitude": officeLatitude,
        "clock_in_office_longitude": officeLongitude,
        "clock_in_device_detail": "Redmi note 2",
        "date": DateFormat("yyy-MM-dd").format(DateTime.now()),
        "clock_in": DateFormat("HH:mm:dd").format(DateTime.now()),
        "clock_in_at": DateFormat("yyy-MM-dd HH:mm:dd").format(DateTime.now()),
      });
      final response = await http.post(
          Uri.parse("${ATTENDANCE_API_URL}/action/clockin"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: data);

      final res = jsonDecode(response.body);
      print("data response ${res}");
      //Get.back();
      if (response.statusCode == 200) {
        Get.back();
        Navigator.pop(context,'back');
        Fluttertoast.showToast(
            msg: "Data has been saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        throw Exception("error ${res['message'].toString()}");
      }
    }
  }

  Future<void> checkout(
      {required String employeeId,
      required latitude,
      required longitude,
      required status,
      required note,
      required image,
      required officeLatitude,
      required officeLongitude,
      required workingPatternId,
      required isLongShift,required context}) async {
    final ipv4 = await Ipify.ipv4();
    print("office shift ${isLongShift}");
    if (image != null) {
      print("date timwwe ${DateTime.now()}");
      print("employee id ${employeeId}");
      print("latitude  ${latitude}");
      print("longitude ${longitude}");
      print("note ${note}");
      var request = http.MultipartRequest(
          "POST", Uri.parse("$ATTENDANCE_API_URL/action/clockout"));
      request.fields['employee_id'] = employeeId.toString();
      request.fields['date'] =
          DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      request.fields['long_shift_working_pattern_id'] = workingPatternId??"0";
      request.fields['is_long_shift'] = isLongShift.toString();

      request.fields['clock_out'] =
          DateFormat("HH:mm:dd").format(DateTime.now()).toString();
      request.fields['clock_out_at'] =
          DateFormat("yyyy-MM-dd HH:mm:dd").format(DateTime.now());
      request.fields['clock_out_device_detail'] = "127.0.0.1";
      request.fields['clock_out_ip_address'] = ipv4.toString();
      request.fields['clock_out_latitude'] = latitude;
      request.fields['clock_out_longitude'] = longitude;
      request.fields['clock_out_office_latitude'] = officeLongitude;
      request.fields['clock_out_office_longitude'] = officeLongitude;
      request.fields['note'] = note;
      var picture = await http.MultipartFile.fromPath('attachment', image);
      request.files.add(picture);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      // throw "${response.stream}";
      print("data ${respStr}");

      if (response.statusCode == 200) {
        Get.back();
        Navigator.pop(context,'back');
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
      final data = jsonEncode({
        "employee_id": employeeId.toString(),
        "clock_out_latitude": latitude,
        "clock_out_longitude": longitude,
        "long_shift_working_pattern_id": workingPatternId??"0",
        "note": note,
        "is_long_shift": isLongShift.toString(),
        // "attachment": image,
        "clock_out_ip_address": ipv4.toString(),
        "clock_out_office_latitude": officeLatitude,
        "clock_out_office_longitude": officeLongitude,
        "clock_out_device_detail": "Redmi note 2",
        "date": DateFormat("yyy-MM-dd").format(DateTime.now()),
        "clock_out": DateFormat("HH:mm:dd").format(DateTime.now()),
        "clock_out_at": DateFormat("yyy-MM-dd HH:mm:dd").format(DateTime.now()),
      });
      final response = await http.post(
          Uri.parse("${ATTENDANCE_API_URL}/action/clockout"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: data);

      final res = jsonDecode(response.body);

      //Get.back();
      if (response.statusCode == 200) {
        Get.back();
        Navigator.pop(context,'back');
      } else {
        throw Exception("error ${res['message'].toString()}");
      }
    }
    //
  }

// Future<void> checkout({
//   required String employeeId,
//   required laitude,
//   required longitude,
//   required status,
//   required note,
//   required image,
//   required officeLatitude,
//   required officeLongitude,
// }) async {
//   final data = jsonEncode({
//     "employee_id": employeeId,
//     "clock_out_latitude": laitude,
//     "clock_out_longitude": longitude,
//     "check_out_status": status,
//     "check_out_note": note,
//     "check_out_image": image,
//     "check_out_office_latitude": officeLatitude,
//     "check_out_office_longitude": officeLongitude,
//     "clock_out_date": DateFormat("yyy-MM-dd").format(DateTime.now()),
//     "clock_out_time": DateFormat("HH:mm:dd").format(DateTime.now())
//   });
//   final response = await http.post(
//       Uri.parse("${ATTENDANCE_API_URL}/checkout"),
//       headers: {'Content-Type': 'application/json; charset=utf-8'},
//       body: data);
//
//   final res = jsonDecode(response.body);
//   print("data response ${res}");
//   if (res['code'] == 200) {
//     Get.back();
//   } else {
//     throw Exception("error ${res['message'].toString()}");
//   }
// }
}
