import 'package:flutter/cupertino.dart';

abstract class LeaveEvent {}

class LeaveSubmission extends LeaveEvent {
  final String? employeeId, dates, description;
  final BuildContext context;

  LeaveSubmission({this.employeeId, this.dates, this.description,required this.context});
}

class EditLeaveSubmission extends LeaveEvent {
  final String? employeeId, dates, description, id, date;
  final BuildContext context;

  EditLeaveSubmission(
  {this.id, this.employeeId, this.dates, this.description, this.date,required this.context});
}

class DeleteLeaveSubmission extends LeaveEvent {
  final String? id;
  final BuildContext context;

  DeleteLeaveSubmission({this.id,required this.context});
}

class leaveSubmitted extends LeaveEvent {}
