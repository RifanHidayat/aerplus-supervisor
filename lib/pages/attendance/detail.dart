import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/pages/attendance/checkin.dart';
import 'package:superviso/pages/track/photo.dart';
import 'package:superviso/repositories/api.dart';
import 'package:geocoding/geocoding.dart' as loc;

class AttendanceDetailPage extends StatefulWidget {
  var address,
      clockInImage,
      clocOutImage,
      clockInLatitude,
      clockInlongitude,
      clockOutLatitude,
      clockOutLongitude,
      datetime,
      clockIn,
      clockOut;

  AttendanceDetailPage(
      {required this.address,
      required this.clockInImage,
      this.clocOutImage,
      required this.clockInLatitude,
      required this.clockOutLongitude,
      required this.clockOutLatitude,
      required this.clockInlongitude,
      required this.clockIn,
      required this.clockOut,
      required this.datetime});

  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  var datetime, latitude, longitude, location, isclockIn = true;
  static const double hueAzure = 210.0;
  static const double hueGreen = 120.0;
  static const double hueRed = 0.0;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datetime = Waktu(DateTime.now()).yMMMMEEEEd();
    GetAddressFromLatLong();
  }

  Future<void> GetAddressFromLatLong() async {
    List<loc.Placemark> placemarks = await loc.placemarkFromCoordinates(
        double.parse(isclockIn == true
            ? widget.clockInLatitude
            : widget.clockOutLatitude),
        double.parse(isclockIn == true
            ? widget.clockInlongitude
            : widget.clockOutLongitude));

    // LatLng(double.parse(isclockIn==true?widget.clockInLatitude:widget.clockInlongitude),
    //     double.parse(isclockIn==true?widget.clockOutLatitude:widget.clockOutLongitude)),
    print(placemarks);
    loc.Placemark place = placemarks[0];
    setState(() {
      location =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      // tilt: CAMERA_TILT,
      // bearing: CAMERA_BEARING,
      target: LatLng(
          double.parse(isclockIn == true
              ? widget.clockInLatitude
              : widget.clockOutLatitude),
          double.parse(isclockIn == true
              ? widget.clockInlongitude
              : widget.clockOutLongitude)),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(
          double.parse(isclockIn == true
              ? widget.clockInLatitude
              : widget.clockOutLatitude),
          double.parse(isclockIn == true
              ? widget.clockInlongitude
              : widget.clockOutLongitude));

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      // _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      // _markers.add(Marker(
      //     markerId: MarkerId('sourcePin'),
      //     onTap: () {
      //       setState(() {
      //         currentlySelectedPin = sourcePinInfo!;
      //         pinPillPosition = 0;
      //       });
      //     },
      //     position: pinPosition, // updated position
      //     icon: BitmapDescriptor.defaultMarker));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.mediaQuery.size.width,
        height: Get.mediaQuery.size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: Get.mediaQuery.size.width,
              height: Get.mediaQuery.size.height * 0.4,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                },
                mapType: MapType.normal,

                markers: <Marker>{
                  Marker(
                    markerId: MarkerId("1"),
                    icon: isclockIn == false
                        ? BitmapDescriptor.defaultMarkerWithHue(0.0)
                        : BitmapDescriptor.defaultMarkerWithHue(hueGreen),
                    position: LatLng(
                        double.parse(isclockIn == true
                            ? widget.clockInLatitude
                            : widget.clockOutLatitude),
                        double.parse(isclockIn == true
                            ? widget.clockInlongitude
                            : widget.clockOutLongitude)),
                  ),
                },

                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        double.parse(isclockIn == true
                            ? widget.clockInLatitude
                            : widget.clockOutLatitude),
                        double.parse(isclockIn == true
                            ? widget.clockInlongitude
                            : widget.clockOutLongitude)),
                    zoom: 13.0),
                // onMapCreated: (GoogleMapCflutteontroller controller) {
                //   _controller.complete(controller);
                // },
              ),
            ),
            Positioned(
                bottom: 1,
                child: Container(
                    width: Get.mediaQuery.size.width,
                    height: Get.mediaQuery.size.height * 0.7,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isclockIn = true;
                                        GetAddressFromLatLong();
                                        updatePinOnMap();
                                      });
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Lokasi Clockin",
                                            style: TextStyle(
                                                fontFamily: "Roboto-regular",
                                                letterSpacing: 0.5,
                                                fontSize: 13,
                                                color: isclockIn == true
                                                    ? baseColor2
                                                    : blackColor4),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: isclockIn == true
                                                    ? baseColor2
                                                    : blackColor4,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            width:
                                                Get.mediaQuery.size.width / 2 -
                                                    40,
                                            height: 3,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  widget.clockOutLatitude != "null"
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              isclockIn = false;
                                              GetAddressFromLatLong();
                                              updatePinOnMap();
                                            });
                                          },
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Lokasi Clockout",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Roboto-regular",
                                                      letterSpacing: 0.5,
                                                      fontSize: 13,
                                                      color: isclockIn == false
                                                          ? baseColor2
                                                          : blackColor4),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: isclockIn == false
                                                          ? baseColor2
                                                          : blackColor4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  width: Get.mediaQuery.size
                                                              .width /
                                                          2 -
                                                      40,
                                                  height: 3,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Detail kehadiran",
                                          style: TextStyle(
                                              height: 1.4,
                                              letterSpacing: 0.5,
                                              fontSize: 15,
                                              color: blackColor2,
                                              fontFamily: "Roboto-medium"),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   margin:
                            //   EdgeInsets.only(top: 5, left: 20, right: 20),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Container(
                            //         child: Icon(
                            //           Icons.history,
                            //           color: baseColor,
                            //         ),
                            //       ),
                            //       Container(
                            //         margin: EdgeInsets.only(left: 5),
                            //         child: Text("Waktu",
                            //             style: TextStyle(
                            //                 letterSpacing: 1,
                            //                 color: blackColor2,
                            //                 fontFamily: "roboto-medium",
                            //                 fontSize: 15)),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                  "${Waktu(DateTime.parse(widget.datetime.toString())).yMMMMEEEEd()}",
                                  style: TextStyle(
                                      letterSpacing: 0.5,
                                      color: baseColor,
                                      fontFamily: "Roboto-regular",
                                      fontSize: 13)),
                            ),

                            Container(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.location_on,
                                                color: baseColor,
                                                size: 18,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Lokasi",
                                                style: TextStyle(
                                                    color: blackColor2,
                                                    fontSize: 13,
                                                    letterSpacing: 0.5,
                                                    fontFamily:
                                                        "Roboto-medium"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("${location}",
                                            style: TextStyle(
                                                color: blackColor4,
                                                fontSize: 11,
                                                letterSpacing: 1,
                                                fontFamily: "roboto-regular")),
                                      ],
                                    ))),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // color:Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Container(
                                              //   child: Icon(
                                              //     Icons.history,
                                              //     color: baseColor,
                                              //   ),
                                              // ),
                                              Container(
                                                child: Text("Jam Masuk",
                                                    style: TextStyle(
                                                      color: blackColor2,
                                                      fontSize: 13,
                                                      letterSpacing: 0.5,
                                                      fontFamily:
                                                          "Roboto-medium",
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text("${widget.clockIn}",
                                              style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: blackColor4,
                                                  fontFamily: "Roboto-regular",
                                                  fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            // Container(
                                            //   child: Icon(
                                            //     Icons.history,
                                            //     color: baseColor,
                                            //   ),
                                            // ),
                                            Container(
                                              child: Text("Jam keluar",
                                                  style: TextStyle(
                                                      letterSpacing: 0.5,
                                                      color: blackColor2,
                                                      fontFamily:
                                                          "Roboto-medium",
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                              "${widget.clockOut == "null" ? "-" : widget.clockOut}",
                                              style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: blackColor4,
                                                  fontFamily: "Roboto-regular",
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: baseColor,
                                      size: 18,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: Get.mediaQuery.size.width / 2 -
                                              40,
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("Foto Clockin",
                                              style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: blackColor2,
                                                  fontFamily: "Roboto-medium",
                                                  fontSize: 13)),
                                        ),
                                        Container(
                                          width: Get.mediaQuery.size.width / 2 -
                                              40,
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("Foto Clockout",
                                              style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: blackColor2,
                                                  fontFamily: "Roboto-medium",
                                                  fontSize: 13)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: Get.mediaQuery.size.width / 2 - 40,
                                    height: 200,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Get.to(PhotoPage(
                                              image: widget.clockInImage,
                                            ));
                                          },
                                          child: PhotoView(
                                            imageProvider: NetworkImage(
                                                "${image_url}/${widget.clockInImage}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Get.mediaQuery.size.width / 2 - 40,
                                    height: 200,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Get.to(PhotoPage(
                                              image: widget.clocOutImage,
                                            ));
                                          },
                                          child: PhotoView(
                                            imageProvider: NetworkImage(
                                                "${image_url}/${widget.clocOutImage}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
