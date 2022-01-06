import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as loc;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/models/user_location.dart';
import 'package:superviso/pages/track/components/info.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class TrackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TrackPageState();
}

class TrackPageState extends State<TrackPage> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  File image = File("");
  var imagePath = "";

  bool isTrack = false;
  bool isDetail = false;
  var employeeId;

// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  var currentAddress;
  String googleAPIKey = '<API_KEY>';

// for my custom marker pins
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

// the user's initial location and current location
// as it moves
  LocationData? currentLocation;

// a reference to the destination location
  LocationData? destinationLocation;

// wrapper around the location API
  Location? location;
  double pinPillPosition = -100;
  UserLocation currentlySelectedPin = UserLocation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  UserLocation? sourcePinInfo;
  UserLocation? destinationPinInfo;

  @override
  void initState() {
    sendData();
    getDataPref();

    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location!.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      GetAddressFromLatLong(
          currentLocation!.latitude, currentLocation!.longitude);

      currentLocation = cLoc;
      updatePinOnMap();
    });
    //location.onLocationChanged().l
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/pin-default.png',
    ).then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/pin-default.png',
    ).then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location!.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        // tilt: CAMERA_TILT,
        // bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT);
      // bearing: CAMERA_BEARING);
    }

    return Scaffold(
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 80),
      //   child: FloatingActionButton.extended(
      //     backgroundColor: baseColor,
      //     onPressed: () {
      //       // chooseImage();
      //       // showModalBottomSheet(
      //       //     backgroundColor: Colors.transparent,
      //       //     context: context,
      //       //     isScrollControlled: true,
      //       //     builder: (context) {
      //       //       return FractionallySizedBox(
      //       //         heightFactor: 0.4,
      //       //         child: _bottomSheet()
      //       //
      //       //       );
      //       //     });
      //     },
      //     icon: Icon(Icons.add),
      //     label: Text("Check-in"),
      //   ),
      // ),
      body: Container(
        width: Get.mediaQuery.size.width,
        height: Get.mediaQuery.size.height,
        child: Stack(
          children: <Widget>[
            GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onTap: (LatLng loc) {
                  pinPillPosition = -100;
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                  showPinsOnMap();
                }),
            // MapPinPillComponent(
            //     pinPillPosition: pinPillPosition,
            //     currentlySelectedPin: currentlySelectedPin),

            //
            Container(
                margin: EdgeInsets.only(top: 40, right: 10),
                alignment: Alignment.topRight,
                child: isTrack == false
                    ? ElevatedButton(
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            sharedPreferences.setBool("isTrack", true);
                            isTrack = true;
                          });
                          print(isTrack.toString());
                        },
                        child: Text("Lacak"),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            sharedPreferences.setBool("isTrack", false);
                            isTrack = false;
                          });
                          print(isTrack.toString());
                        },
                        child: Text("Berhenti"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                      )),
            Positioned(
                bottom: 1,
                child: Container(
                    width: Get.mediaQuery.size.width,
                    height: Get.mediaQuery.size.height / 2 + 100,
                    child: isDetail == false
                        ? _bottomSheet()
                        : _bottomSheetDetail()))
          ],
        ),
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation!.latitude, currentLocation!.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation!.latitude, destinationLocation!.longitude);

    sourcePinInfo = UserLocation(
        locationName: "${currentAddress}",
        location: SOURCE_LOCATION,
        pinPath: "assets/images/pin-default.png",
        avatarPath: "assets/images/pin-default.png",
        labelColor: Colors.blueAccent);

    destinationPinInfo = UserLocation(
        locationName: "End Location",
        location: DEST_LOCATION,
        pinPath: "assets/images/pin-default.png",
        avatarPath: "assets/images/pin-default.png",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    //setPolylines();
  }

  // void setPolylines() async {
  //   List<PointLatLng> result = (await polylinePoints!
  //       .getRouteBetweenCoordinates(
  //           googleAPIKey,
  //           currentLocation?.latitude,
  //           currentLocation?.longitude,
  //           destinationLocation!.latitude,
  //           destinationLocation!.longitude));
  //
  //   if (result.isNotEmpty) {
  //     result.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //
  //     setState(() {
  //       _polylines.add(Polyline(
  //           width: 2, // set the width of the polylines
  //           polylineId: PolylineId("poly"),
  //           color: Color.fromARGB(255, 40, 122, 198),
  //           points: polylineCoordinates));
  //     });
  //   }
  // }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      // tilt: CAMERA_TILT,
      // bearing: CAMERA_BEARING,
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation!.latitude, currentLocation!.longitude);

      sourcePinInfo!.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo!;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  void getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("employee_id${sharedPreferences.getInt("employee_id")}");
    setState(() {
      isTrack = sharedPreferences.getBool("isTrack")!;
      employeeId = sharedPreferences.getInt("employee_id")!;
    });
  }

  void sendData() {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (isTrack) {
        FirebaseFirestore.instance
            .collection('employee_locations')
            .doc("${employeeId}")
            .update({
          "address": currentAddress,
          "latitude": currentLocation?.latitude.toString(),
          "longitude": currentLocation?.longitude.toString()
        }).then((result) {
          print("new USer true");
        }).catchError((onError) {
          print("onError ${onError}");
        });
      }
    });
  }

  Future<void> GetAddressFromLatLong(double latitude, double longitude) async {
    List<loc.Placemark> placemarks =
        await loc.placemarkFromCoordinates(latitude, longitude);
    print(placemarks);
    loc.Placemark place = placemarks[0];
    setState(() {
      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  ///widget
  Widget _bottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.mediaQuery.size.width,
                height: 100,
                margin: EdgeInsets.only(right: 5),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // if (isDetail == true) {
                        //   setState(() {
                        //     isDetail = false;
                        //   });
                        //   Navigator.pop(context);
                        //   _showModalButtonSheet();
                        // } else {
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 1,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: Icon(Icons.arrow_back, color: blackColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.mediaQuery.size.width,
                height: Get.mediaQuery.size.height / 2,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      "assets/images/profile-default.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Rifan Hidayat",
                                          style: TextStyle(
                                              height: 1.4,
                                              letterSpacing: 1,
                                              fontSize: 15,
                                              color: blackColor2,
                                              fontFamily: "roboto-regular"),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          width: Get.mediaQuery.size.width / 2 -
                                              20,
                                          child: Text(
                                            "I No. 2, Margahayu Raya, Jl. Saturnus Ujung...",
                                            style: TextStyle(
                                                height: 1.4,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                                color: blackColor4,
                                                fontFamily: "roboto-regular"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: double.maxFinite,
                                      child: ElevatedButton(
                                        onPressed: () => {
                                          chooseImage()
                                        },
                                        child: Text(
                                          "Check in",
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: baseColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                color: blackColor5,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 40),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Lokasi Saat ini",
                                          style: TextStyle(
                                              color: blackColor2,
                                              fontSize: 15,
                                              letterSpacing: 1,
                                              fontFamily: "roboto-regular"),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "I No. 2, Margahayu Raya, Jl. Saturnus Ujung, Manjahlega, Rancasari, Bandung City, West Java 40286",
                                            style: TextStyle(
                                                color: blackColor1,
                                                fontSize: 13,
                                                letterSpacing: 1,
                                                fontFamily: "roboto-regular")),
                                      ],
                                    ))),

                            Container(
                              margin:
                                  EdgeInsets.only(top: 30, left: 10, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.history,
                                      color: blackColor2,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text("Riwayat Checkin",
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            color: blackColor2,
                                            fontFamily: "roboto-regular",
                                            fontSize: 15)),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.maxFinite,
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Tampilkan Semua",
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            color: baseColor2,
                                            fontFamily: "roboto-regular",
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///checkin history
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isDetail = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: baseColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "13 januari 2022",
                                            style: TextStyle(
                                                color: blackColor2,
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontFamily: "roboto-regular"),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            width: double.maxFinite,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "10:13:41",
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: baseColor,
                                                  fontSize: 14,
                                                  fontFamily: "roboto-regular"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(left: 5),
                                            height: 90,
                                            color: baseColor3,
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              width: double.maxFinite,
                                              child: Text(
                                                "Jl. Dipati Ukur No.112-116, Lebakgede, Kecamatan Coblong, Kota Bandung, Jawa Barat 40132",
                                                style: TextStyle(
                                                    letterSpacing: 2,
                                                    color: blackColor4),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isDetail = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: baseColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "13 januar 2022",
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                color: blackColor2,
                                                fontSize: 14,
                                                fontFamily: "roboto-regular"),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            width: double.maxFinite,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "10:13:41",
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: baseColor,
                                                  fontSize: 14,
                                                  fontFamily: "roboto-regular"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(left: 5),
                                            height: 90,
                                            color: baseColor3,
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              width: double.maxFinite,
                                              child: Text(
                                                "Jl. Dipati Ukur No.112-116, Lebakgede, Kecamatan Coblong, Kota Bandung, Jawa Barat 40132",
                                                style: TextStyle(
                                                    letterSpacing: 1,
                                                    color: blackColor4),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetDetail() {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.mediaQuery.size.width,
                height: 100,
                margin: EdgeInsets.only(right: 5),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        isDetail = false;
                        // if (isDetail == true) {
                        //   setState(() {
                        //     isDetail = false;
                        //   });
                        //   Navigator.pop(context);
                        //   _showModalButtonSheet();
                        // } else {
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 1,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: Icon(Icons.arrow_back, color: blackColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.mediaQuery.size.width,
                height: Get.mediaQuery.size.height / 2,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Detail Checkin",
                                          style: TextStyle(
                                              height: 1.4,
                                              letterSpacing: 1,
                                              fontSize: 15,
                                              color: blackColor2,
                                              fontFamily: "roboto-regular"),
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
                            Container(

                                alignment: Alignment.centerLeft,

                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                               child: Icon(Icons.location_on,color: baseColor,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Lokasi",
                                                style: TextStyle(
                                                    color: blackColor2,
                                                    fontSize: 15,
                                                    letterSpacing: 1,
                                                    fontFamily: "roboto-regular"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "I No. 2, Margahayu Raya, Jl. Saturnus Ujung, Manjahlega, Rancasari, Bandung City, West Java 40286",
                                            style: TextStyle(
                                                color: blackColor1,
                                                fontSize: 13,
                                                letterSpacing: 1,
                                                fontFamily: "roboto-regular")),
                                      ],
                                    ))),

                            Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.history,
                                      color: baseColor,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text("Waktu",
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            color: blackColor2,
                                            fontFamily: "roboto-regular",
                                            fontSize: 15)),
                                  ),


                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: blackColor2,
                                      fontFamily: "roboto-regular",
                                      fontSize: 15)),
                            ),


                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void chooseImage() async{
    var checkinImage= await ImagePicker.pickImage(source: ImageSource.camera);
    if (image!=null){
      setState(() {
        image=File(checkinImage.path);
        imagePath=checkinImage.path;
      });




    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
