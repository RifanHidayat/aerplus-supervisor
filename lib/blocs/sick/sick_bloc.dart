import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/sick/sick_event.dart';
import 'package:superviso/blocs/sick/sick_state.dart';
import 'package:superviso/repositories/sick.dart';

class SickBloc extends Bloc<SickEvent, SickState> {
  SickRepository? sickRepository;

  //SickBloc(SickState initialState) : super(initialState);

  SickBloc({this.sickRepository}) : super(SickState());

  @override
  Stream<SickState> mapEventToState(SickEvent event) async* {
    if (event is SickSubmission) {
      yield SickState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await sickRepository!.sickSubmission(
            context: event.context,
            attahment: event.attachment.toString(),
            dates: event.dates.toString(),
            description: event.description.toString(),
            employeeId: event.employeeId.toString(),
            numberOfDayes: event.numberofDay.toString());
        yield SickState(isLoading: false);
      } catch (e) {
        yield SickState(
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
    } else if (event is EditSickSubmission) {
      yield SickState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await sickRepository!.editSickSubmission(
            context: event.context,
            attahment: event.attachment.toString(),
            date: event.date.toString(),
            id: event.id.toString(),
            dates: event.dates.toString(),
            description: event.description.toString(),
            employeeId: event.employeeId.toString(),
            numberOfDayes: event.numberofDay.toString());
        yield SickState(isLoading: false);
      } catch (e) {
        yield SickState(
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
    } else if (event is DeleteSickSickSubmission) {
      yield SickState(
        isLoading: true,
        isLoaded: true,
      );
      try {
        await sickRepository!.deleteSickSubmission(
            id: event.id.toString(), context:event.context);
        yield SickState(
          isLoading: false,
          isLoaded: true,
        );
      } catch (e) {
        yield SickState(
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
