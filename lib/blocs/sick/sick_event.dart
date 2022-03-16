import 'package:flutter/cupertino.dart';

abstract class SickEvent {}

class SickSubmission extends SickEvent {
  final String? employeeId, dates, description, numberofDay, attachment;
  final BuildContext context;

  SickSubmission(
      {this.employeeId,
      this.dates,
      this.description,
      this.numberofDay,
      this.attachment,
      required this.context});
}

class EditSickSubmission extends SickEvent {
  final String? employeeId,
      dates,
      description,
      numberofDay,
      id,
      date,
      attachment;
  final BuildContext context;

  EditSickSubmission(
      {this.employeeId,
      this.dates,
      this.description,
      this.numberofDay,
      this.id,
      this.date,
      this.attachment,
      required this.context});
}

class DeleteSickSickSubmission extends SickEvent {
  final String? id;
  final BuildContext context;

  DeleteSickSickSubmission(this.id,this.context);
}
