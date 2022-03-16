import 'dart:convert';

class ActiveLeaveModel {
  num? id;
  num? employeeId;
  String? startDate;
  String? endDate;
  num? totalLeave;
  num? takenLeave;
  bool? active;
  num? remainingLeave;


  ActiveLeaveModel({this.id, this.employeeId,this.totalLeave,this.endDate,this.startDate,this.active,this.takenLeave,this.remainingLeave});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'startDate':startDate,
      'endDate':endDate,
      'totalLeave':totalLeave,
      'takenLeave':takenLeave,
      'remainingLeave':remainingLeave,
    };
  }

  factory ActiveLeaveModel.fromJson(Map<String, dynamic> map) {
    return ActiveLeaveModel(
      id: map["id"] ?? 0,
      startDate: map['startDate'],
      endDate: map['endDate'],
      totalLeave: map['totalLeave']??0,
      takenLeave: map["takenLeave"] ?? 0,
      active: map['active'],
      remainingLeave: map['totalLeave']-map['takenLeave']

    );
  }

  static List<ActiveLeaveModel> fromJsonToList(List data) {
    return List<ActiveLeaveModel>.from(data.map(
          (item) => ActiveLeaveModel.fromJson(item),
    ));
  }

  static String toJson(ActiveLeaveModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
