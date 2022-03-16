import 'package:flutter/cupertino.dart';

abstract class AttendanceEvent {}

class AttendanceCheckinChange extends AttendanceEvent {
  final String? employeeId,
      laitude,
      longitude,
      status,
      note,
      image,
      officeLatitude,
      officeLongitude,
      workingPatternId;
  final BuildContext? context;

  AttendanceCheckinChange(
      {this.employeeId,
      this.laitude,
      this.longitude,
      this.note,
      this.image,
      this.officeLatitude,
      this.officeLongitude,
      this.status,
      this.context,
      this.workingPatternId});
}

class CheckInSubmitted extends AttendanceEvent {}

class Checkin extends AttendanceEvent {
  final String? employeeId,
      laitude,
      longitude,
      status,
      note,
      image,
      officeLatitude,
      officeLongitude,
      workingPatternId;
  final BuildContext? context;

  Checkin(
      {this.employeeId,
      this.laitude,
      this.longitude,
      this.note,
      this.image,
      this.officeLatitude,
      this.officeLongitude,
      this.status,
      this.context,
      this.workingPatternId});
}

class Checkout extends AttendanceEvent {
  final String? employeeId,
      laitude,
      longitude,
      status,
      note,
      image,
      officeLatitude,
      workingPatternId,
      officeLongitude;
  final bool? isLongsShift;
  final BuildContext? context;

  Checkout(
      {this.employeeId,
      this.laitude,
      this.longitude,
      this.note,
      this.image,
      this.officeLatitude,
      this.officeLongitude,
      this.workingPatternId,
      this.isLongsShift,
      this.context,
      this.status});
}
