import 'dart:convert';

import 'package:superviso/models/confirmer.dart';

class ApprovalFlowsModel {
  num? id;
  String? confirmedAt;
  String? status;
  ConfirmerModel? confirmer;

  ApprovalFlowsModel({
    this.id,
    this.confirmedAt,
    this.status,
    this.confirmer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'confirmedAt': confirmedAt,
      'status': status,
      "confirmer": confirmer,
    };
  }

  factory ApprovalFlowsModel.fromJson(Map<String, dynamic> map) {
    return ApprovalFlowsModel(
      id: map["id"] ?? 0,
      confirmedAt: map["confirmedAt"] ?? "",
      status: map['status'],
      confirmer: map['confirmer'] != null
          ? ConfirmerModel.fromJson(map['confirmer'])
          : null,
    );
  }

  static List<ApprovalFlowsModel> fromJsonToList(List data) {
    return List<ApprovalFlowsModel>.from(data.map(
      (item) => ApprovalFlowsModel.fromJson(item),
    ));
  }

  static String toJson(ApprovalFlowsModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
