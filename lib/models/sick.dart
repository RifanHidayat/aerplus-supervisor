import 'dart:convert';

import 'package:superviso/models/approval_flows.dart';

class SickModel {
  num? id;
  num? employeeId;
  String? sickDates;
  String? attachment;
  String? note;
  num? currentApprovalLevel;
  String? approvalStatus;
  String? date;
  List<ApprovalFlowsModel> approvalFlows;


  SickModel(
      {this.id,
      this.employeeId,
      this.note,
      this.attachment,
      this.sickDates,
      this.currentApprovalLevel,
      this.date,
      required this.approvalFlows,
      this.approvalStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'note': note,
      'attachment': attachment,
      'sickDates': sickDates,
      'currentApprovalLevel': currentApprovalLevel,
      'approvalStatus': approvalStatus,
      'date': date,
      'approvalFlows': approvalFlows,


    };
  }

  factory SickModel.fromJson(Map<String, dynamic> map) {
    return SickModel(
      id: map["id"] ?? 0,
      approvalFlows: ApprovalFlowsModel.fromJsonToList(map['approvalFlows']),
      employeeId: map["employeeId"] ?? 0,
      note: map['note'],
      approvalStatus: map['approvalStatus'] ?? 0,
      attachment: map['attachment'],
      currentApprovalLevel: map['currentApprovalLevel'],
      sickDates: map['sickDates'],
      date: map['date'],
    );
  }

  static List<SickModel> fromJsonToList(List data) {
    return List<SickModel>.from(data.map(
      (item) => SickModel.fromJson(item),
    ));
  }

  static String toJson(SickModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
