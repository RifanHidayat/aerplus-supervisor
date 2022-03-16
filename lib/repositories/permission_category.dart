import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:superviso/models/permission.dart';
import 'package:superviso/models/permission_category.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class PermissionCategoryRepository {
  final PERMISSION_CATEGORY_API_URL = "${base_url}/api/permission-categories";

  Future<List<PermissionCategoryModel>> permissions(var id) async {
    var response = await http.get(Uri.parse("${PERMISSION_CATEGORY_API_URL}"));
    final data = jsonDecode(response.body);
    print("data ${data}");
    List<PermissionCategoryModel> list =
        PermissionCategoryModel.fromJsonToList(data['data']);
    return list;
  }
}
