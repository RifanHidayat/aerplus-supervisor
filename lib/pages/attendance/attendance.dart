import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/assets/style.dart';
import 'package:superviso/models/attendance.dart';
import 'package:superviso/pages/attendance/detail.dart';
import 'package:superviso/repositories/attandance.dart';
import 'package:superviso/repositories/employee.dart';

import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  //List attendances = [1, 2, 3, 4, 5];
  var status = "leave";
  var employeeId = 0;
  bool isAttendanceLoading = false;
  List<AttendanceModel>? attendances;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: baseColor2,
        title: Text(
          "Kehadiran",
          style: appbar,
        ),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: Container(
            child: Column(
              children: [
                Container(
                    child: StreamBuilder<List<AttendanceModel>>(
                  stream: fetchAttendance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "${snapshot.error}",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      if (data.length > 0) {
                        return Column(
                            children: List.generate(data.length, (index) {
                          return _attendance(data, index);
                        }));
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
                                  style:
                                      TextStyle(color: blackColor4, fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return Container(
                      width: Get.mediaQuery.size.width,
                      height: Get.mediaQuery.size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: baseColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///function

  void getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("employee_id${sharedPreferences.getInt("employee_id")}");
    setState(() {
      employeeId = sharedPreferences.getInt("employee_id") ?? 0;
      print(sharedPreferences.getInt("employee_id").toString());
    });
  }

  Future<List<AttendanceModel>?> todayAttendance(id) async {
    var date = DateFormat('yyy-MM-dd').format(DateTime.now());
    setState(() {
      isAttendanceLoading = true;
    });

    attendances = await EmployeeRespository().attendances(id);

    setState(() {
      isAttendanceLoading = false;
    });
    return attendances;
  }

  Stream<List<AttendanceModel>> fetchAttendance() async* {
    var ohList = await EmployeeRespository().attendances(employeeId.toString());
    yield ohList;
  }

  Future refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    getDataPref();

    setState(() {});
  }

  ///widget

  Widget _attendance(data, index) {
    return InkWell(
      onTap: () {
        if (data[index].sickApplicationId != 0) {
          print("sick ${data[index].sickApplicationId}");
        } else if (data[index].permissionApplicationId != 0) {
        } else if (data[index].leaveApplicationId != 0) {
        } else {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: AttendanceDetailPage(
                    clockInLatitude: data[index].clockInLatitude.toString(),
                    clockInlongitude: data[index].clockInLongitude.toString(),
                    clockOutLatitude: data[index].clockOutLatitude.toString(),
                    clockOutLongitude: data[index].clockOutLongitude.toString(),
                    address:
                        "I No. 2, Margahayu Raya, Jl. Saturnus Ujung, Manjahlega, Rancasari, Bandung City, West Java 40286",
                    clocOutImage: data[index].clockOutAttachment.toString(),
                    clockInImage: data[index].clockInAttachment.toString(),
                    datetime: "${data[index].date}",
                    clockIn: "${data[index].clockIn}",
                    clockOut: "${data[index].clockOut}",
                  )));
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "${Waktu(DateTime.parse("${data[index].date}")).yMMMMEEEEd()}",
                            style: TextStyle(
                                color: baseColor,
                                letterSpacing: 0.5,
                                fontSize: 14,
                                fontFamily: "Roboto-medium"),
                          ),
                          data[index].sickApplicationId != 0
                              ? Expanded(
                                  child: Container(
                                      width: double.maxFinite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 73,
                                            height: 17,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 73,
                                              height: 17,
                                              decoration: BoxDecoration(
                                                  color: redColorInfo,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                child: Text(
                                                  "SAKIT",
                                                  style: TextStyle(
                                                      color: redColor,
                                                      fontFamily:
                                                          "Roboto-regular",
                                                      fontSize: 10,
                                                      letterSpacing: 0.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              : data[index].permissionApplicationId != 0
                                  ? Expanded(
                                      child: Container(
                                          width: double.maxFinite,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 73,
                                                height: 17,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 73,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                      color: redColorInfo,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Container(
                                                    child: Text(
                                                      "IZIN",
                                                      style: TextStyle(
                                                          color: redColor,
                                                          fontFamily:
                                                              "Roboto-regular",
                                                          fontSize: 10,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    )
                                  : data[index].leaveApplicationId != 0
                                      ? Expanded(
                                          child: Container(
                                              width: double.maxFinite,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width: 73,
                                                    height: 17,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 73,
                                                      height: 17,
                                                      decoration: BoxDecoration(
                                                          color: redColorInfo,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Container(
                                                        child: Text(
                                                          "CUTI",
                                                          style: TextStyle(
                                                              color: redColor,
                                                              fontFamily:
                                                                  "Roboto-regular",
                                                              fontSize: 10,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        )
                                      : Container()
                        ],
                      ),
                    ),
                    data[index].timeLate > 0
                        ? Container(
                            child: Text(
                              "Terlambat ${data[index].timeLate} menit",
                              style: TextStyle(
                                  color: redColor,
                                  fontSize: 9,
                                  fontFamily: "Roboto-regular",
                                  letterSpacing: 0.5),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "jam Masuk  ${data[index].clockIn ?? "-"} ",
                      style: TextStyle(
                          color: greyColor,
                          letterSpacing: 0.5,
                          fontSize: 12,
                          fontFamily: "Roboto-regular"),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Jam keluar  ${data[index].clockOut ?? "-"}",
                      style: TextStyle(
                          color: greyColor,
                          letterSpacing: 0.5,
                          fontSize: 12,
                          fontFamily: "Roboto-regular"),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
