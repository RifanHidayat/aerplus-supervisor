import 'package:flutter/cupertino.dart';

abstract class PermissionEvent {}

class PermissionSubmission extends PermissionEvent {
  final String? employeeId,
      dates,
      description,
      numberofDay,
      permissionCategoryId;
  final BuildContext context;

  PermissionSubmission(
      {this.employeeId,
      this.dates,
      this.description,
      this.numberofDay,
      this.permissionCategoryId,
      required this.context});
}

class EditPermissionSubmission extends PermissionEvent {
  final String? employeeId,
      dates,
      description,
      numberofDay,
      permissionCategoryId,
      date,
      id;
  final BuildContext context;

  EditPermissionSubmission(
      {this.employeeId,
      this.dates,
      this.description,
      this.numberofDay,
      this.permissionCategoryId,
      this.date,
      this.id,
      required this.context});
}

class DeletePermisionSubmission extends PermissionEvent {
  final String? id;
  final BuildContext context;

  DeletePermisionSubmission(this.id, this.context);
}
