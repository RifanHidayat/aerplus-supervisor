import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/leave/leave_event.dart';
import 'package:superviso/blocs/leave/leave_state.dart';
import 'package:superviso/repositories/leave.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  LeaveRepository? leaveRepository;

  //SickBloc(SickState initialState) : super(initialState);

  LeaveBloc({this.leaveRepository}) : super(LeaveState());

  @override
  Stream<LeaveState> mapEventToState(LeaveEvent event) async* {
    if (event is LeaveSubmission) {
      yield LeaveState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await leaveRepository!.leaveSubmission(
          context: event.context,
          dates: event.dates.toString(),
          description: event.description.toString(),
          employeeId: event.employeeId.toString(),
        );
        yield LeaveState(isLoading: false);
      } catch (e) {
        yield LeaveState(
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
    if (event is EditLeaveSubmission) {
      yield LeaveState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await leaveRepository!.EditleaveSubmission(
            context: event.context,
            id: event.id.toString(),
            dates: event.dates.toString(),
            description: event.description.toString(),
            employeeId: event.employeeId.toString(),
            date: event.date.toString());
        yield LeaveState(isLoading: false);
      } catch (e) {
        yield LeaveState(
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
    } else if (event is DeleteLeaveSubmission) {
      yield LeaveState(
        isDeleting: true,
      );
      try {
        await leaveRepository!.deleteLeaveSubmission(
            id: event.id.toString(), context: event.context);
        yield LeaveState(
          isDeleting: false,
        );
      } catch (e) {
        yield LeaveState(
          isDeleting: false,
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
