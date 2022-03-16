import 'dart:convert';

class AttendanceModel {
  num? id;
  num? employeeId;

  String? date;
  String? clockIn;
  String? clockInAt;
  String? lockInIpAddress;
  String? clockInDeviceDetail;
  String? clockInLatitude;
  String? clockInLongitude;
  String? clockInOfficeLatitude;
  String? clockInOfficeLongitude;
  String? clockInAttachment;
  String? clockInNote;
  String? clockOut;
  String? clockOutAt;
  String? clockOutIpAddress;
  String? clockOutDeviceDetail;
  String? clockOutLatitude;
  String? clockOutLongitude;
  String? clockOutOfficeLatitude;
  String? clockOutOfficeLongitude;
  String? clockOutAttachment;
  String? clockOutNote;
  String? status;
  num? timeLate;
  String? placeOfBirth;

  num? overtime;
  String? approvalStatus;
  num? sickApplicationId;
  num? permissionApplicationId;
  num? leaveApplicationId;
  String? createdAt;
  String? updatedAt;

  AttendanceModel(
      {this.id,
      this.employeeId,
      this.date,
      this.clockIn,
      this.clockInAt,
      this.lockInIpAddress,
      this.clockInDeviceDetail,
      this.clockInLatitude,
      this.clockInLongitude,
      this.clockInOfficeLatitude,
      this.clockInOfficeLongitude,
      this.clockInAttachment,
      this.clockInNote,
      this.clockOut,
      this.clockOutAt,
      this.clockOutIpAddress,
      this.clockOutDeviceDetail,
      this.clockOutLatitude,
      this.clockOutLongitude,
      this.clockOutOfficeLatitude,
      this.clockOutOfficeLongitude,
      this.clockOutAttachment,
      this.clockOutNote,
      this.status,
      this.timeLate,
      this.overtime,
      this.approvalStatus,
      this.sickApplicationId,
      this.permissionApplicationId,
      this.leaveApplicationId,
      this.createdAt,
      this.updatedAt,
      this.placeOfBirth});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date,
      'clockIn': clockIn,
      'clockInAt': clockInAt,
      'clockInLatitude': clockInLatitude,
      'clockInLatitude': clockInLatitude,
      'clockInOfficeLatitude': clockInOfficeLatitude,
      'clockInOfficeLongitude': clockInOfficeLatitude,
      'clockInAttachment': clockInAttachment,
      'clockInNote': clockInNote,
      'clockOut': clockOut,
      'clockOutAt': clockOutAt,
      'clockOutLatitude': clockOutLatitude,
      'clockOutLatitude': clockOutLongitude,
      'clockOutOfficeLatitude': clockOutOfficeLatitude,
      'clockOutOfficeLongitude': clockOutOfficeLatitude,
      'clockOutAttachment': clockOutAttachment,
      'clockOutNote': clockOutNote,
      'status': status,
      'timeLate': timeLate,
      'sickApplicationId': sickApplicationId,
      'permissionApplicationId': permissionApplicationId,
      'leaveApplicationId': leaveApplicationId,
      'overTime': overtime,
      "placeOfBirth": placeOfBirth
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> map) {
    return AttendanceModel(
        id: map['id'],
        date: map['date'],
        clockIn: map['clockIn'],
        clockInAt: map['clockInAt'],
        clockInLatitude: map['clockInLatitude'],
        clockInLongitude: map['clockInLongitude'],
        clockInOfficeLatitude: map['clockInOfficeLatitude'],
        clockInOfficeLongitude: map['clockInLongitude'],
        clockInAttachment: map['clockInAttachment'],
        clockInNote: map['clockInNote'],
        clockOut: map['clockOut'],
        clockOutAt: map['clockOutAt'],
        clockOutLatitude: map['clockOutLatitude'],
        clockOutLongitude: map['clockOutLongitude'],
        clockOutOfficeLatitude: map['clockOutOfficeLatitude'],
        clockOutOfficeLongitude: map['clockOutLongitude'],
        clockOutAttachment: map['clockOutAttachment'],
        clockOutNote: map['clockOutNote'],
        timeLate: map['timeLate'] ?? 0,
        sickApplicationId: map['sickApplicationId'] ?? 0,
        permissionApplicationId: map['permissionApplicationId'] ?? 0,
        leaveApplicationId: map['leaveApplicationId'] ?? 0,
        overtime: map['overTime'] ?? 0,
        placeOfBirth: map['placeOfBirth'] ?? "",
        status: map['status']);
  }

  static List<AttendanceModel> fromJsonToList(List data) {
    return List<AttendanceModel>.from(data.map(
      (item) => AttendanceModel.fromJson(item),
    ));
  }

  static String toJson(AttendanceModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
