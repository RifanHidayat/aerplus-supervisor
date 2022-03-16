
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/models/checkin.dart';
import 'package:superviso/pages/track/detail.dart';
import 'package:superviso/pages/track/photo.dart';
import 'package:superviso/repositories/api.dart';
import 'package:superviso/repositories/checkin.dart';

class CheckinHistoryPage extends StatefulWidget {
  var employeeId;

  CheckinHistoryPage({this.employeeId});

  @override
  _CheckinHistoryPageState createState() => _CheckinHistoryPageState();
}

class _CheckinHistoryPageState extends State<CheckinHistoryPage> {
  var isTrack = false, name, employeeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor:baseColor2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Riwayat Checkin",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "roboto-regular",
              fontSize: 18,
              letterSpacing: 0.5),
        ),
      ),
      body: Container(
        width: Get.mediaQuery.size.width,
        height: Get.mediaQuery.size.height,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[

                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: StreamBuilder<List<CheckinModel>>(
                    stream: watchPurchases(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // return Container(
                        //   margin: EdgeInsets.only(left: 20, right: 20),
                        //   child: Text(
                        //     "${snapshot.error}",
                        //     style: TextStyle(color: Colors.red, fontSize: 12),
                        //   ),
                        // );

                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: Get.mediaQuery.size.width / 2,
                                height: 200,
                                child: SvgPicture.asset(
                                    "assets/images/no-checkin.svg",
                                    semanticsLabel: 'Acme Logo'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  "belum ada checkin",
                                  style: TextStyle(
                                      color: blackColor4, fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        var data = snapshot.data!;
                        if (data.length > 0) {
                          return Column(
                            children: List.generate(data.length, (index) {
                              var d = DateTime.parse(
                                  data[index].dateTime.toString());

                              var dateLocal = d.toLocal();
                              // var localDate = DateFormat().parse(data[index].dateTime.toString(), true).toLocal().toString();
                              // String createdDate = DateFormat().format(DateTime.parse(localDate)); // you will local time
                              // ///checkin history
                              // return InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       // isDetail = true;
                              //       Get.to(DetailPage(
                              //         image: data[index].image,
                              //         address: data[index].address,
                              //         latitude: data[index].latitude,
                              //         longitude: data[index].longitude,
                              //         datetime: data[index].dateTime,
                              //       ));
                              //     });
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.only(left: 15, right: 15),
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           children: <Widget>[
                              //             Container(
                              //               width: 15,
                              //               height: 15,
                              //               decoration: BoxDecoration(
                              //                   color: baseColor,
                              //                   borderRadius:
                              //                   BorderRadius.circular(20)),
                              //             ),
                              //             Container(
                              //               margin: EdgeInsets.only(left: 10),
                              //               child: Text(
                              //                 "${Waktu(DateTime.parse(data[index].dateTime.toString())).yMMMMEEEEd()} ",
                              //                 style: TextStyle(
                              //                     color: blackColor2,
                              //                     fontSize: 13,
                              //                     letterSpacing: 0.5,
                              //                     height: 1.4,
                              //                     fontFamily: "roboto-regular"),
                              //               ),
                              //             ),
                              //             Expanded(
                              //               child: Container(
                              //                 alignment: Alignment.centerRight,
                              //                 width: double.maxFinite,
                              //                 margin: EdgeInsets.only(left: 10),
                              //                 child: Text(
                              //                   "${DateFormat("HH:mm:ss").format(dateLocal)}",
                              //                   style: TextStyle(
                              //                       color: baseColor,
                              //                       fontSize: 13,
                              //                       letterSpacing: 0.5,
                              //                       height: 1.4,
                              //                       fontFamily: "roboto-regular"),
                              //                 ),
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //         Container(
                              //           child: Row(
                              //             children: <Widget>[
                              //               Container(
                              //                 alignment: Alignment.centerRight,
                              //                 margin: EdgeInsets.only(left: 5),
                              //                 height: 90,
                              //                 color: baseColor3,
                              //                 width: 5,
                              //               ),
                              //               Expanded(
                              //                 child: Container(
                              //                   margin: EdgeInsets.only(
                              //                       left: 20, right: 10),
                              //                   width: double.maxFinite,
                              //                   child: Text(
                              //                     "${data[index].address}",
                              //                     style: TextStyle(
                              //                         fontSize: 13,
                              //                         letterSpacing: 0.5,
                              //                         height: 1.4,
                              //                         color: blackColor4),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Hero(
                              //                   tag: "avatar-1",
                              //                   child: InkWell(
                              //                     onTap: () {
                              //                       Get.to(PhotoPage(
                              //                         image: data[index].image,
                              //                       ));
                              //                     },
                              //                     child: Container(
                              //                       width: 50,
                              //                       height: 50,
                              //                       color: Colors.blue,
                              //                       child: PhotoView(
                              //                           imageProvider: NetworkImage(
                              //                               "${image_url}/${data[index].image}")),
                              //                     ),
                              //                   ))
                              //             ],
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // );

                              ///history checki
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    // isDetail = true;
                                    Get.to(DetailPage(
                                      image: data[index].image,
                                      address: data[index].address,
                                      latitude: data[index].latitude,
                                      longitude: data[index].longitude,
                                      datetime: data[index].dateTime,
                                    ));
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color: baseColor,
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  margin:
                                                  EdgeInsets.only(left: 5),
                                                  height: 130,
                                                  color: baseColor3,
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                      //history checkin
                                      Expanded(
                                        child: Container(
                                          width: double.maxFinite,
                                          height: 120,
                                          child: Card(
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                            ),
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Hero(
                                                      tag: "avatar-1",
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.to(PhotoPage(
                                                            image: data[index]
                                                                .image,
                                                          ));
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 120,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    5)),
                                                            child:
                                                            Image.network(
                                                              "${image_url}/${data[index].image}",
                                                              fit: BoxFit.fill,
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                  "${DateFormat("yyyy-mm-dd").format(DateTime.parse(snapshot.data![index].dateTime.toString()))}",
                                                                  style: TextStyle(
                                                                      color:
                                                                      blackColor2,
                                                                      letterSpacing:
                                                                      0.5,
                                                                      fontSize:
                                                                      12,
                                                                      fontFamily:
                                                                      "roboto-regular"),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: Get
                                                                    .mediaQuery
                                                                    .size
                                                                    .width *
                                                                    0.3,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                      Icon(
                                                                        Icons
                                                                            .history,
                                                                        color:
                                                                        baseColor,
                                                                        size:
                                                                        18,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                      Text(
                                                                        "${DateFormat("HH:mm:ss").format(dateLocal)}",
                                                                        style: TextStyle(
                                                                            color:
                                                                            baseColor2,
                                                                            letterSpacing:
                                                                            0.5,
                                                                            fontSize:
                                                                            12,
                                                                            fontFamily:
                                                                            "roboto-regular"),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            width: Get
                                                                .mediaQuery
                                                                .size
                                                                .height *
                                                                0.25,
                                                            child: Text(
                                                              "${data[index].address} ",
                                                              style: TextStyle(
                                                                  color:
                                                                  blackColor2,
                                                                  letterSpacing:
                                                                  0.5,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                  "roboto-regular"),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        } else {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: Get.mediaQuery.size.width / 2,
                                  height: 200,
                                  child: SvgPicture.asset(
                                      "assets/images/no-checkin.svg",
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    "belum ada checkin",
                                    style: TextStyle(
                                        color: blackColor4, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      }
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(color: baseColor,),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<CheckinModel>> watchPurchases() async* {
    var ohList = await CheckinRepository().fetchChecin(widget.employeeId.toString());
    yield ohList;
  }

  void getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("employee_id${sharedPreferences.getInt("employee_id")}");
    setState(() {
      isTrack = sharedPreferences.getBool("isTrack") ?? false;
      employeeId = sharedPreferences.getInt("employee_id");
      name = sharedPreferences.getString("name");
    });
  }
}
