import 'dart:io';

abstract class CheckinEvent {}

class CheckinImage extends CheckinEvent {
  final String image;

  CheckinImage(this.image);
}

class CheckinDateTime extends CheckinEvent {
  final String dateTime;

  CheckinDateTime(this.dateTime);
}

class CheckinLatitude extends CheckinEvent {
  final String latitude;

  CheckinLatitude(this.latitude);
}

class CheckinLongitude extends CheckinEvent {
  final String longitude;

  CheckinLongitude(this.longitude);
}

class CheckinEmployeeId extends CheckinEvent {
  final String employeeId;

  CheckinEmployeeId(this.employeeId);
}

class CheckinAddress extends CheckinEvent {
  final String address;

  CheckinAddress(this.address);
}


class CheckinSubmitted extends CheckinEvent {} /**/
