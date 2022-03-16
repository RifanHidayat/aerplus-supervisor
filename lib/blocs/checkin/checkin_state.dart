import 'dart:io';

import 'package:superviso/blocs/checkin/checkin_submission.dart';
import 'package:superviso/blocs/login/form_submission.dart';

class CheckinState {
  final String image;
  final String latitude;
  final String longitude;
  final String dateTime;
  final String employeeId;
  final String address;
  final CheckinSubmissionStatus formStatus;

  CheckinState(
      {this.image = '',
      this.latitude = '',
      this.longitude = '',
      this.dateTime = '',
      this.employeeId = '',
      this.address = '',
      this.formStatus = const InitialCheckinStatus()});

  CheckinState copyWith(
      {String? image,
      String? latitude,
      String? longitude,
      String? dateTime,
      String? employeeId,
      String? address,
      CheckinSubmissionStatus? formStatus}) {
    return CheckinState(
        image: image ?? this.image,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        dateTime: dateTime ?? this.dateTime,
        employeeId: employeeId ?? this.employeeId,
        address: address ?? this.address,
        formStatus: formStatus ?? this.formStatus);
  }
}
