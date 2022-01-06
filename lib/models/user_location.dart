import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  String? pinPath;
  String? avatarPath;
  LatLng? location;
  String? locationName;
  Color? labelColor;

  UserLocation({this.pinPath, this.avatarPath, this.location, this.locationName, this.labelColor});
}