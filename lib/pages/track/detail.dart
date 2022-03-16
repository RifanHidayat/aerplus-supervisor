import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/pages/track/photo.dart';
import 'package:superviso/repositories/api.dart';

class DetailPage extends StatefulWidget {
  var address, image, latitude, longitude, datetime;

  DetailPage(
      {required this.address,
      required this.image,
      required this.latitude,
      required this.longitude,
      required this.datetime});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var datetime, latitude, longitude;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datetime = Waktu(DateTime.now()).yMMMMEEEEd();
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
                mapType: MapType.normal,
                markers: <Marker>{
                  Marker(
                    markerId: MarkerId("1"),
                    position: LatLng(double.parse(widget.latitude),
                        double.parse(widget.longitude)),
                  ),
                },

                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(widget.latitude.toString()),
                        double.parse(widget.longitude.toString())),
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
                                          "Detail Checkin",
                                          style: TextStyle(
                                              height: 1.4,
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.location_on,
                                                color: baseColor,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Lokasi",
                                                style: TextStyle(
                                                    color: blackColor2,
                                                    fontSize: 15,
                                                    letterSpacing: 1,
                                                    fontFamily:
                                                        "roboto-medium"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("${widget.address}",
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
                                            fontFamily: "roboto-medium",
                                            fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                  "${Waktu(DateTime.parse(widget.datetime.toString())).yMMMMEEEEd()}",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: blackColor2,
                                      fontFamily: "roboto-regular",
                                      fontSize: 15)),
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
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text("Foto",
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            color: blackColor2,
                                            fontFamily: "roboto-medium",
                                            fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 200,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Stack(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Get.to(PhotoPage(
                                        image: widget.image,
                                      ));
                                    },
                                    child: PhotoView(
                                      imageProvider: NetworkImage(
                                          "${image_url}/${widget.image}"),
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
