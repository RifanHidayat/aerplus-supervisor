import 'dart:convert';

import 'package:superviso/models/approval_flows.dart';
import 'package:superviso/models/permission_category.dart';

class PermissionModel {
  num? id;
  num? employeeId;
  num? permissionCategoryId;
  String? permissionDates;
  String? attachment;
  String? note;
  num? currentApprovalLevel;
  String? approvalStatus;
  PermissionCategoryModel? permissionCategory;
  List<ApprovalFlowsModel>? approvalFlows;

  String? date;

  PermissionModel(
      {this.id,
      this.employeeId,
      this.note,
      this.attachment,
      this.permissionDates,
      this.currentApprovalLevel,
      this.permissionCategoryId,
      this.date,
      this.approvalFlows,
      this.permissionCategory,
      this.approvalStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'PermissionCategoryId': permissionCategoryId,
      'note': note,
      'attachment': attachment,
      'permissionDates': permissionDates,
      'currentApprovalLevel': currentApprovalLevel,
      'approvalStatus': approvalStatus,
      'date': date,
      'approvalFlows': approvalFlows,
      "category": permissionCategory,
    };
  }

  factory PermissionModel.fromJson(Map<String, dynamic> map) {
    return PermissionModel(
      id: map["id"] ?? 0,
      approvalFlows: ApprovalFlowsModel.fromJsonToList(map['approvalFlows']),
      permissionCategory: map['category'] != null
          ? PermissionCategoryModel.fromJson(map['category'])
          : null,
      employeeId: map["employeeId"] ?? 0,
      permissionCategoryId: map["permissionCategoryId"] ?? 0,
      note: map['note'],
      approvalStatus: map['approvalStatus'],
      attachment: map['attachment'],
      currentApprovalLevel: map['currentApprovalLevel'],
      permissionDates: map['permissionDates'],
      date: map['date'],
    );
  }

  static List<PermissionModel> fromJsonToList(List data) {
    return List<PermissionModel>.from(data.map(
      (item) => PermissionModel.fromJson(item),
    ));
  }

  static String toJson(PermissionModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
