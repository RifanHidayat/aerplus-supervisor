import 'dart:convert';

import 'package:superviso/models/approval_flows.dart';

class LeaveModel {
  num? id;
  num? employeeId;
  String? leaveDates;
  String? attachment;
  String? note;
  num? currentApprovalLevel;
  String? approvalStatus;
  String? date;
  List<ApprovalFlowsModel> approvalFlows;


  LeaveModel(
      {this.id,
        this.employeeId,
        this.note,
        this.attachment,
        this.currentApprovalLevel,
        this.date,
        required this.approvalFlows,
        this.leaveDates,
        this.approvalStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'note': note,
      'attachment': attachment,
      'currentApprovalLevel': currentApprovalLevel,
      'approvalStatus': approvalStatus,
      'date': date,
      'approvalFlows': approvalFlows,
      'leaveDates': leaveDates,


    };
  }

  factory LeaveModel.fromJson(Map<String, dynamic> map) {
    return LeaveModel(
      id: map["id"] ?? 0,
      approvalFlows: ApprovalFlowsModel.fromJsonToList(map['approvalFlows']),
      employeeId: map["employeeId"] ?? 0,
      note: map['note'],
      approvalStatus: map['approvalStatus'] ?? 0,
      attachment: map['attachment'],
      currentApprovalLevel: map['currentApprovalLevel'],
      leaveDates: map['leaveDates'],
      date: map['date'],
    );
  }

  static List<LeaveModel> fromJsonToList(List data) {
    return List<LeaveModel>.from(data.map(
          (item) => LeaveModel.fromJson(item),
    ));
  }

  static String toJson(LeaveModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
