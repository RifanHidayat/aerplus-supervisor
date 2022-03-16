import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superviso/blocs/attendance/attandance_event.dart';
import 'package:superviso/blocs/attendance/attandance_state.dart';
import 'package:superviso/repositories/attandance.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceRepository? attendanceRepository;

  AttendanceBloc({this.attendanceRepository}) : super(AttendanceState());

  @override
  Stream<AttendanceState> mapEventToState(AttendanceEvent event) async* {
    if (event is Checkin) {
      yield AttendanceState(
        isLoading: true,
        isLoaded: true,
      );

      try {
        await attendanceRepository!.checkin(
            employeeId: event.employeeId.toString(),
            latitude: event.laitude,
            longitude: event.longitude,
            status: event.status,
            note: event.note,
            image: event.image,
            officeLatitude: event.officeLatitude,
            officeLongitude: event.officeLongitude,
            workingPatternId: event.workingPatternId.toString(),context: event.context);
        yield AttendanceState(
          isLoading: false,
          isLoaded: true,
        );
      } catch (e) {
        yield AttendanceState(
          isLoading: false,
          isLoaded: true,
        );
        print("${e}");
      }
    } else if (event is Checkout) {
      yield AttendanceState(
        isLoading: true,
        isLoaded: true,
      );

      try {
        await attendanceRepository!.checkout(
            employeeId: event.employeeId.toString(),
            latitude: event.laitude,
            longitude: event.longitude,
            status: event.status,
            note: event.note,
            image: event.image,
            officeLatitude: event.officeLatitude,
            officeLongitude: event.officeLongitude,
            workingPatternId: event.workingPatternId.toString(),
            isLongShift: event.isLongsShift,
        context: event.context);
        yield AttendanceState(
          isLoading: false,
          isLoaded: true,
        );
      } catch (e) {
        yield AttendanceState(
          isLoading: false,
          isLoaded: true,
        );
        print("${e}");
      }
    }

    // switch (event) {
    //   case AttendanceEvent.:
    //     yield AttendanceState(isLoading: true, isLoaded: false);
    //     AttendanceModel employee =
    //         (await attendanceRepository!.getAttendances()) as AttendanceModel;
    //
    //     break;
    //   case AttendanceEvents.checkin:
    //     yield AttendanceState(isLoading: false, isLoaded: true,);
    //     await attendanceRepository!.checkin(
    //         employeeId: state.attendances!.employeeId.toString(),
    //         laitude: "1",
    //         longitude: "6",
    //         status: "5",
    //         category:"3",
    //         note: "2",
    //         image: "1",
    //         officeLatitude: "9",
    //         officeLongitude: "10",
    //         todayName: "Monday");
    // }
  }
}
