import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/checkin/checkin_bloc.dart';
import 'package:superviso/blocs/checkin/checkin_event.dart';
import 'package:superviso/blocs/checkin/checkin_state.dart';
import 'package:superviso/blocs/checkin/checkin_submission.dart';
import 'package:superviso/repositories/checkin.dart';
import 'package:intl/intl.dart';

class ConfirmCheckinTrackPage extends StatefulWidget {
  var address, image, latitude, longitude, employeeId;

  ConfirmCheckinTrackPage(
      {required this.employeeId,
      required this.address,
      required this.image,
      required this.latitude,
      required this.longitude});

  @override
  _ConfirmCheckinTrackPageState createState() => _ConfirmCheckinTrackPageState();
}

class _ConfirmCheckinTrackPageState extends State<ConfirmCheckinTrackPage> {
  var datetime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datetime = Waktu(DateTime.now()).yMMMMEEEEd();
    new Future.delayed(Duration.zero, () {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CheckinBloc(checkinRepository: context.read<CheckinRepository>()),
      child: Scaffold(
          floatingActionButton:
              BlocBuilder<CheckinBloc, CheckinState>(builder: (context, state) {
            return Container(
              child: FloatingActionButton(
                backgroundColor: baseColor,
                onPressed: () {
                  print(
                      "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}");
                  context
                      .read<CheckinBloc>()
                      .add(CheckinEmployeeId(widget.employeeId));
                  context
                      .read<CheckinBloc>()
                      .add(CheckinAddress(widget.address));
                  context.read<CheckinBloc>().add(CheckinImage(widget.image));
                  context.read<CheckinBloc>().add(CheckinImage(widget.image));
                  context
                      .read<CheckinBloc>()
                      .add(CheckinLatitude(widget.latitude));
                  context
                      .read<CheckinBloc>()
                      .add(CheckinLongitude(widget.longitude));
                  context.read<CheckinBloc>().add(CheckinDateTime(
                      DateFormat("yyyy-MM-dd HH:mm:ss")
                          .format(DateTime.now())
                          .toString()));
                  context.read<CheckinBloc>().add(CheckinSubmitted());
                },
                child: state.formStatus is CheckinSubmitting
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
              ),
            );
          }),
          body: Container(
            width: Get.mediaQuery.size.width,
            height: Get.mediaQuery.size.height,
            child: Stack(
              children: <Widget>[
                _map(),
                _checkinInfo(),
                Positioned(
                  top: Get.mediaQuery.size.height / 2 - 110,
                  child: Container(
                    width: Get.mediaQuery.size.width,
                    height: 100,
                    margin: EdgeInsets.only(right: 5),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Get.back();
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
                                child:
                                    Icon(Icons.arrow_back, color: blackColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  ///widget
  Widget _map() {
    return Container(
      width: Get.mediaQuery.size.width,
      height: Get.mediaQuery.size.height * 0.6,
      child: GoogleMap(
        mapType: MapType.normal,
        markers: <Marker>{
          Marker(
            markerId: MarkerId("1"),
            position: LatLng(
                double.parse(widget.latitude), double.parse(widget.longitude)),
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
    );
  }

  Widget _checkinInfo() {
    return Positioned(
        bottom: 1,
        child: Container(
            width: Get.mediaQuery.size.width,
            height: Get.mediaQuery.size.height / 2,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Detail Checkin",
                                  style: TextStyle(
                                      height: 1.4,
                                      letterSpacing: 1,
                                      fontSize: 15,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                            fontFamily: "roboto-medium"),
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
                      margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      child: Text("${datetime}",
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
                      margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                          Image.file(
                            File(widget.image),
                            width: double.infinity,
                          ),
                          // BlocBuilder<CheckinBloc, CheckinState>(
                          //     builder: (context, state) {
                          //   return Container(
                          //     child: Positioned(
                          //       child: Container(
                          //         alignment: Alignment.centerRight,
                          //         margin: EdgeInsets.only(top: 130),
                          //         child: RawMaterialButton(
                          //           onPressed: () {
                          //             print("${widget.employeeId}");
                          //             print("${widget.address}");
                          //             context.read<CheckinBloc>()
                          //                 .add(CheckinEmployeeId(widget.employeeId));
                          //             context.read<CheckinBloc>()
                          //                 .add(CheckinAddress(widget.address));
                          //             context
                          //                 .read<CheckinBloc>()
                          //                 .add(CheckinImage(widget.image));
                          //             context
                          //                 .read<CheckinBloc>()
                          //                 .add(CheckinImage(widget.image));
                          //             context.read<CheckinBloc>().add(
                          //                 CheckinLatitude(widget.latitude));
                          //             context.read<CheckinBloc>().add(
                          //                 CheckinLongitude(widget.longitude));
                          //             context.read<CheckinBloc>().add(
                          //                 CheckinDateTime(
                          //                     DateTime.now().toString()));
                          //             context
                          //                 .read<CheckinBloc>()
                          //                 .add(CheckinSubmitted());
                          //           },
                          //           elevation: 2.0,
                          //           fillColor: baseColor,
                          //           child: state.formStatus is CheckinSubmitting
                          //               ? const CircularProgressIndicator(
                          //                   color: Colors.white,
                          //                 )
                          //               : const Icon(
                          //                   Icons.check,
                          //                   size: 35.0,
                          //                   color: Colors.white,
                          //                 ),
                          //           padding: EdgeInsets.all(15.0),
                          //           shape: CircleBorder(),
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // })
                        ],
                      ),
                    ),
                    BlocBuilder<CheckinBloc, CheckinState>(
                        builder: (context, state) {
                      final formStatus = state.formStatus;

                      if (formStatus is CheckinSubmissionFaied) {
                        return Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text(
                            formStatus.exception.toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: "roboto-regular",
                                fontSize: 11),
                          ),
                        );
                      }
                      return Container();
                    }),
                  ],
                ),
              ),
            )));
  }
}
