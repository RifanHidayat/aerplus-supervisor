import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/assets/style.dart';
import 'package:superviso/blocs/permission/permission_bloc.dart';
import 'package:superviso/blocs/permission/permission_event.dart';
import 'package:superviso/blocs/permission/permission_state.dart';
import 'package:superviso/models/attendance.dart';
import 'package:superviso/models/permission.dart';
import 'package:superviso/pages/permission/add_permission_submission.dart';
import 'package:superviso/pages/permission/detail_permission_submission.dart';
import 'package:superviso/pages/permission/edit_permission_submission.dart';
import 'package:superviso/repositories/employee.dart';
import 'package:superviso/repositories/permission.dart';

class PermissionSubmissionPage extends StatefulWidget {
  @override
  _PermissionSubmissionPageState createState() =>
      _PermissionSubmissionPageState();
}

class _PermissionSubmissionPageState extends State<PermissionSubmissionPage> {
  var status = "pending";
  List permission = [1, 2, 3, 4, 5, 6];
  var employeeId = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: baseColor,
        onPressed: () {
          moveToAddPermissionSubmission();
        },
        icon: Icon(Icons.add),
        label: Text(
          "Izin",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 15,
              fontFamily: "inter-regular"),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: baseColor2,
        title: Text(
          "Izin",
          style: appbar,
        ),
      ),
      body: permission.length > 0
          ? SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // _info(),
                      Container(
                          child: StreamBuilder<List<PermissionModel>>(
                        stream: fetchPermissions(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "${snapshot.error}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            var data = snapshot.data!;
                            if (data.length > 0) {
                              return Column(
                                  children: List.generate(data.length, (index) {
                                return _permission(data, index);
                              }))
                              ;
                            } else {
                              return Container(
                                width: Get.mediaQuery.size.width,
                                height: Get.mediaQuery.size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
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
                                        "Belum ada data",
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
                      // Container(
                      //   child: Column(
                      //       children: List.generate(permission.length, (index) {
                      //         return _permission();
                      //       })),
                      // )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Container(
                margin:
                    EdgeInsets.only(top: Get.mediaQuery.size.height / 2 - 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: SvgPicture.asset("assets/images/no-data.svg",
                          semanticsLabel: 'Acme Logo'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "belum ada data",
                        style: TextStyle(color: blackColor4, fontSize: 14),
                      ),
                    )
                  ],
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    fetchPermissions();
    getDataPref();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Stream<List<PermissionModel>> fetchPermissions() async* {
    // var ohList = await EmployeeRespository().permissions(employeeId);
    var ohList = await EmployeeRespository().permissions(employeeId);
    yield ohList;
  }

  void moveToAddPermissionSubmission() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AddPermissionSubmissionPage()));
    if (result == "update") {
      getDataPref();
    }
  }

  void moveToEditPermissionSubmission(date, permissionDates, note,
      permissionCategoryId, id, maxDay, dates) async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: EditPermissionSubmissionPage(
              date: date,
              maxDay: maxDay,
              permissionDates: permissionDates,
              note: note,
              id: id.toString(),
              permissionCategoryId: permissionCategoryId.toString(),
            )));
    if (result == "update") {
      getDataPref();
    }
  }
  void moveToDeletePermissionSubmission(date,dates,id) async{
   var result=await  showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.5,
              child: _bottomSheet(date, dates, id));
        });
   if (result=='update'){
     getDataPref();

   }


  }

  ///widget
  Widget _bottomSheet(date, dates, id) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
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
                        Get.back();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 1,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: Icon(Icons.close, color: blackColor),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: 100,
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: true == false
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      elevation: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.close,
                                          color: blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        //new Color.fromRGBO(255, 0, 0, 0.0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                    child: true == false
                        ? ListView.builder(
                            controller: scrollController,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor1,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: 60,
                                      height: 5,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: Get.mediaQuery.size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: 61,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: whiteColor1,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: 100,
                                      height: 5,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${Waktu(DateTime.parse(date.toString())).yMMMMEEEEd()}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "Roboto-bold",
                                                    color: baseColor),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // Text(
                                              //   "Tanggal Pengajuan pada ${dates}",
                                              //   style: TextStyle(
                                              //       fontSize: 12,
                                              //       letterSpacing: 0.5,
                                              //       fontFamily:
                                              //           "Roboto-regular",
                                              //       color: blackColor4),
                                              // ),
                                              Container(
                                                width:
                                                    Get.mediaQuery.size.width -
                                                        100,
                                                child: RichText(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(
                                                      fontSize: 12.0),
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        height: 1.4,
                                                        letterSpacing: 1,
                                                        fontSize: 10,
                                                        color: blackColor4,
                                                        fontFamily:
                                                            "roboto-regular"),
                                                    text:
                                                        "Tanggal pengjuan pada $dates",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //devider
                                  // Container(
                                  //   margin: EdgeInsets.only(top: 20),
                                  //   child: Divider(
                                  //     color: whiteColor2,
                                  //   ),
                                  // ),

                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                      ),
                                      color: orangeColor,
                                      height: 26,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.info,
                                                    color: redColor,
                                                    size: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Apakah yakin? Data akan dihapus',
                                                    style: TextStyle(
                                                        color: blackColor4,
                                                        fontSize: 11),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),

                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: BlocBuilder<PermissionBloc,
                                            PermissionState>(
                                        builder: (context, state) {
                                      return state.isLoading == true
                                          ? Container(
                                              width: 40,
                                              height: 40,
                                              child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: baseColor,
                                                  )),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 35,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 30),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    context
                                                        .read<PermissionBloc>()
                                                        .add(
                                                            DeletePermisionSubmission(
                                                                id.toString(),
                                                                context));
                                                    // context.read<PermissionBloc>().add(PermissionSubmission(
                                                    //     employeeId: employeeId.toString(),
                                                    //     permissionCategoryId: _type.toString(),
                                                    //     dates: sick_date_submit.toString(),
                                                    //     numberofDay: sick_date_submit.length.toString(),
                                                    //     description: descriprionCtr.text));
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(baseColor),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    )),
                                                  ),
                                                  child: const Text(
                                                    "Hapus",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            "Roboto-regular"),
                                                  )),
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///widget

  Widget _info() {
    return Container(
        width: Get.mediaQuery.size.width,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //pending
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Pending",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Roboto-medium",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: blackColor4,
                              fontSize: 15,
                              fontFamily: "Roboto-regular",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //rejected

                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Rejected",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Roboto-medium",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: blackColor4,
                              fontSize: 15,
                              fontFamily: "Roboto-regular",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //approved
                  //pending
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Approved",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Roboto-medium",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: blackColor4,
                              fontSize: 15,
                              fontFamily: "Roboto-regular",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _permission(data, index) {
    var d = [];
    //       var d=data[index].sickDates!.split(",");
    for (var date in data[index].permissionDates!.split(',')) {
      // _addAndPrint(age);
      d.add(
        "${Waktu(DateTime.parse(date.toString().trim())).yMMMMd()}",
      );
    }
    return Container(
      height: 170,
      width: Get.mediaQuery.size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: PermissionDetailPage(
                      permissionDates: "${d}",
                      date: data[index].date,
                      status: data[index].approvalStatus,
                      attachment: data[index].attachment,
                      note: data[index].note,
                      approvalFlows: data[index].approvalFlows)));
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //header
                Row(
                  children: [
                    Container(
                      child: Text(
                        "${Waktu(DateTime.parse(data[index].date)).yMMMMEEEEd()}",
                        style: TextStyle(
                            color: baseColor,
                            fontFamily: "Roboto-medium",
                            fontSize: 12,
                            letterSpacing: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: double.maxFinite,
                        child: data[index].approvalStatus == "approved"
                            ? Container(
                                alignment: Alignment.center,
                                width: 73,
                                height: 17,
                                decoration: BoxDecoration(
                                    color: greenColorInfo,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  child: Text(
                                    "APPROVED",
                                    style: TextStyle(
                                        color: greenColor,
                                        fontFamily: "Roboto-regular",
                                        fontSize: 10,
                                        letterSpacing: 0.5),
                                  ),
                                ),
                              )
                            : data[index].approvalStatus == "rejected"
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 73,
                                    height: 17,
                                    decoration: BoxDecoration(
                                        color: redColorInfo,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      child: Text(
                                        "REJECTED",
                                        style: TextStyle(
                                            color: redColor,
                                            fontFamily: "Roboto-regular",
                                            fontSize: 10,
                                            letterSpacing: 0.5),
                                      ),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: 73,
                                    height: 17,
                                    decoration: BoxDecoration(
                                        color: yellowColorInfo,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      child: Text(
                                        "PENDING",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontFamily: "Roboto-regular",
                                            fontSize: 10,
                                            letterSpacing: 0.5),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: blackColor.withOpacity(0.2),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "${data[index].permissionCategory != null ? data[index].permissionCategory.name : ""}",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Roboto-regular",
                        fontSize: 13,
                        letterSpacing: 0.5),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  child: Text(
                    "Tanggal pengajuan pada  ${d}",
                    style: TextStyle(
                        color: blackColor,
                        fontFamily: "Roboto-regular",
                        fontSize: 10,
                        letterSpacing: 0.5),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                      style: TextStyle(
                          height: 1.4,
                          letterSpacing: 1,
                          fontSize: 10,
                          color: blackColor4,
                          fontFamily: "roboto-regular"),
                      text: "${data[index].note}",
                    ),
                  ),
                ),
                data[index].approvalStatus == "pending"
                    ? _btnPermission(
                        data[index].date,
                        data[index].permissionDates,
                        data[index].note,
                        data[index].permissionCategoryId,
                        data[index].id,
                        data[index].permissionCategory.maxDay,
                        d)
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnPermission(
      date, permissionDates, note, permissionCategoryId, id, maxDay, dates) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomRight,
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                //print(permissionCategoryId.toString());
                moveToEditPermissionSubmission(date, permissionDates, note,
                    permissionCategoryId, id, maxDay, dates);
                // Navigator.push(
                //     context,
                //     PageTransition(
                //         type: PageTransitionType.rightToLeft,
                //         child: EditPermissionSubmissionPage(
                //           date: date,
                //           maxDay: maxDay,
                //           permissionDates: permissionDates,
                //           note: note,
                //           id: id.toString(),
                //           permissionCategoryId: permissionCategoryId.toString(),
                //         )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                width: 25,
                height: 25,
                child: Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color: blackColor4,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                moveToDeletePermissionSubmission(date,dates,id);
                // showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     context: context,
                //     isScrollControlled: true,
                //     builder: (context) {
                //       return FractionallySizedBox(
                //           heightFactor: 0.5,
                //           child: _bottomSheet(date, dates, id));
                //     });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                width: 25,
                height: 25,
                child: Icon(
                  Icons.restore_from_trash_outlined,
                  size: 15,
                  color: blackColor4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
