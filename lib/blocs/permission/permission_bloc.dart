import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/permission/permission_event.dart';
import 'package:superviso/blocs/permission/permission_state.dart';
import 'package:superviso/repositories/permission.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionRepository? permissionRepository;

  //SickBloc(SickState initialState) : super(initialState);

  PermissionBloc({this.permissionRepository}) : super(PermissionState());

  @override
  Stream<PermissionState> mapEventToState(PermissionEvent event) async* {
    if (event is PermissionSubmission) {
      yield PermissionState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await permissionRepository!.permissionSubmission(
            context: event.context,
            permissionCategoryId: event.permissionCategoryId.toString(),
            dates: event.dates.toString(),
            description: event.description.toString(),
            employeeId: event.employeeId.toString(),
            numberOfDayes: event.numberofDay.toString());
        yield PermissionState(isLoading: false);
      } catch (e) {
        yield PermissionState(
          isLoading: false,
          isLoaded: true,
        );
        Fluttertoast.showToast(
            msg: "${e}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: redColor,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    } else if (event is EditPermissionSubmission) {
      yield PermissionState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await permissionRepository!.editPermissionSubmission(
            context: event.context,
            id: event.id.toString(),
            date: event.date.toString(),
            permissionCategoryId: event.permissionCategoryId.toString(),
            dates: event.dates.toString(),
            description: event.description.toString(),
            employeeId: event.employeeId.toString(),
            numberOfDayes: event.numberofDay.toString());
        yield PermissionState(isLoading: false);
      } catch (e) {
        yield PermissionState(
          isLoading: false,
          isLoaded: true,
        );
        Fluttertoast.showToast(
            msg: "${e}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: redColor,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    } else if (event is DeletePermisionSubmission) {
      yield PermissionState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await permissionRepository!.deletePermissionSubmission(
            id: event.id.toString(), context: event.context);
        yield PermissionState(
          isLoading: false,
          isLoaded: true,
        );
      } catch (e) {
        yield PermissionState(
          isLoading: false,
          isLoaded: true,
        );
        Fluttertoast.showToast(
            msg: "${e}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: redColor,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    }
  }
}
