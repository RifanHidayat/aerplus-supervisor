import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/models/permission.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class PermissionRepository {
  final PERMISSION_API_URL = "${base_url}/api/permission-applications";

  Future<List<PermissionModel>> permissions(var id) async {
    var response = await http.get(Uri.parse("${PERMISSION_API_URL}"));
    final data = jsonDecode(response.body);
    print("data ${data}");
    List<PermissionModel> list = PermissionModel.fromJsonToList(data['data']);
    return list;
  }

  Future<List<PermissionModel>> fetchPermissionEmployee(num id) async {
    var response = await http.get(Uri.parse("${PERMISSION_API_URL}"));
    var data = json.decode("${response.body}");

    List<PermissionModel> list = PermissionModel.fromJsonToList(data['data']);
    return list;
  }

  Future<void> permissionSubmission(
      {required String dates,
      required String description,
      required String employeeId,
      required String permissionCategoryId,
      required String numberOfDayes,required BuildContext context}) async {
    print("id ${employeeId}");
    final response = await http.post(Uri.parse("${PERMISSION_API_URL}"), body: {
      "employee_id": employeeId,
      "permission_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "note": description,
      "permission_category_id": permissionCategoryId,
    });
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
   Navigator.pop(context,'update');
    } else {
      print("error ${res.toString()}");
      throw Exception("message ${res['message'].toString()}");
    }
  }

  Future<void> editPermissionSubmission(
      {required String id,
      required String date,
      required String dates,
      required String description,
      required String employeeId,
      required String permissionCategoryId,
      required String numberOfDayes,required BuildContext context}) async {
    final response =
        await http.post(Uri.parse("${PERMISSION_API_URL}/${id}"), body: {
      "employee_id": employeeId,
      "permission_dates": dates.replaceAll(RegExp('[^A-Za-z0-9\-\,]'), ''),
      "date": date.toString(),
      "note": description,
      "permission_category_id": permissionCategoryId,
    });
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
    Navigator.pop(context,'update');
    } else {
      print("${res.toString()}");
      throw Exception("${res.toString()}");
    }
  }

  Future<void> deletePermissionSubmission({
    required String id,
    required BuildContext context
  }) async {
    final response =
        await http.delete(Uri.parse("${PERMISSION_API_URL}/${id}"));

    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Data berhasil dihapus",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
     Navigator.pop(context,'update');
    } else {
      throw Exception("${res['message'].toString()}");
    }
  }
}
