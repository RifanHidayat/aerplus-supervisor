import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'package:superviso/assets/colors.dart';
import 'package:superviso/assets/style.dart';
import 'package:superviso/blocs/permission/permission_bloc.dart';
import 'package:superviso/blocs/permission/permission_event.dart';
import 'package:superviso/blocs/permission/permission_state.dart';
import 'package:superviso/models/permission_category.dart';
import 'package:superviso/repositories/api.dart';
import 'package:superviso/repositories/permission_category.dart';
import 'package:http/http.dart' as http;

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPermissionSubmissionPage extends StatefulWidget {
  @override
  _AddPermissionSubmissionPageState createState() =>
      _AddPermissionSubmissionPageState();
}

class _AddPermissionSubmissionPageState
    extends State<AddPermissionSubmissionPage> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  var sick_dates = [];
  var sick_date_submit = [];
  var _initialSelectedDates;
  var _visible = false;
  var disable = true;
  var user_id;
  var isLoading = true;
  var sickDatedCtr = new TextEditingController();
  var descriprionCtr = new TextEditingController();
  var attachmentController = new TextEditingController();
  var jumlahPengambilanController = new TextEditingController();
  var employeeId;
  List? typeList;
  String? _type;
  int? position;
  num? sickDateTotal = 0;
  num? maxDay = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatapref();
    categoryPermission();
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
          "Pengajuan izin",
          style: appbar,
        ),
      ),
      body: SingleChildScrollView(
          child: isLoading == true
              ? Container(
                  width: Get.mediaQuery.size.width,
                  height: Get.mediaQuery.size.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: baseColor,
                    ),
                  ),
                )
              : Container(
                  width: Get.mediaQuery.size.width,
                  height: Get.mediaQuery.size.height,
                  child: InkWell(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        child: _formSickSubmission()),
                  ))),
    );
  }

  ///function
  Future multipleDate() {
    return showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: Get.mediaQuery.size.width - 40,
              height: Get.mediaQuery.size.height / 2 + 20,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      height: Get.mediaQuery.size.height / 2 + -20,
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.multiple,
                        initialSelectedDates: _initialSelectedDates,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        print(_selectedDate);
      } else if (args.value is List<DateTime>) {
        ///initialselectdates date leaves
        _initialSelectedDates = args.value;
        sick_dates.clear();
        sick_date_submit.clear();
        sickDateTotal = args.value.length;
        //jumlahPengambilanController.text = args.value.length.toString();

        ///format date-leaves
        args.value.forEach(
          (DateTime date) {
            sick_dates.add(DateFormat('dd/MM/yyyy').format(date));
            sick_date_submit.add(DateFormat('yyyy-MM-dd').format(date));
          },
        );
        sickDatedCtr.text = sick_dates.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Future getDatapref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      employeeId = sharedPreferences.getInt("employee_id");
    });
  }

  ///widget

  Widget _formSickSubmission() {
    return Container(
      child: Form(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              sickDateTotal! > maxDay!
                  ? Container(
                      color: orangeColor,
                      height: 26,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                'Pengambilan melebihi batas maksimal kategori',
                                style:
                                    TextStyle(color: blackColor4, fontSize: 11),
                              ),
                            )
                          ],
                        ),
                      ))
                  : Container(),
              Container(
                child: Text(
                  "${Waktu(DateTime.now()).yMMMMEEEEd()}",
                  style: TextStyle(
                      color: baseColor,
                      fontFamily: "Roboto-medium",
                      letterSpacing: 0.5,
                      fontSize: 13),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //sick dates
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Tanggal izin",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "Roboto-regular"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        multipleDate();
                      },
                      child: Container(
                        child: TextFormField(
                          cursorColor: Theme.of(context!).cursorColor,
                          enabled: false,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 12, fontFamily: "Roboto-regular"),
                          controller: sickDatedCtr,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2, left: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0, color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: baseColor, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            suffixIcon: Icon(
                              Icons.date_range,
                            ),
                          ),
                          // decoration: InputDecoration(
                          //   labelText: 'Tanggal Cuti',
                          //   labelStyle: TextStyle(),
                          //   helperText: 'Helper text',
                          //   suffixIcon: Icon(
                          //     Icons.date_range,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    sick_dates.length > 0
                        ? Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "Jumlah pengambilan ${sick_dates.length} hari",
                              style: TextStyle(
                                  color: blackColor4,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Roboto-regular",
                                  fontSize: 10,
                                  letterSpacing: 0.5),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //description

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Kategori Izin",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "Roboto-regular"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: blackColor4),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _type,
                            iconSize: 30,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black38,
                            ),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: Text(
                              'Pilih Kategori',
                              style: TextStyle(
                                  color: blackColor2,
                                  fontFamily: "Roboto-regular",
                                  fontSize: 12,
                                  letterSpacing: 0.5),
                            ),
                            onChanged: (String? categories) {
                              setState(() {
                                _type = categories;
                                position = typeList?.indexWhere((prod) =>
                                    prod["id"] == int.parse(categories!));
                                maxDay = typeList![position!]['maxDay'];

                                if (jumlahPengambilanController.text
                                    .toString()
                                    .isEmpty) {
                                  disable = true;
                                  _visible = true;
                                } else {
                                  ///check total total leave
                                  if (int.parse(jumlahPengambilanController.text
                                          .toString()) >
                                      int.parse(
                                          "${typeList![position!]['maxDay']}")) {
                                    _visible = true;
                                    disable = false;
                                  } else {
                                    _visible = false;
                                    disable = true;
                                  }
                                }
                              });
                            },
                            items: typeList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['name']),
                                    value: item['id'].toString(),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      child: Container(
                          child: position != null
                              ? Text(
                                  "Maksimal: ${typeList![position!]['maxDay']} Hari",
                                  style: TextStyle(
                                      color: blackColor4,
                                      fontSize: 10,
                                      fontFamily: "Roboto-regular",
                                      fontStyle: FontStyle.italic))
                              : Container()),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Keterangan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "Roboto-regular"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          multipleDate();
                        },
                        child: Container(
                          child: TextFormField(
                            controller: descriprionCtr,
                            style: TextStyle(
                                fontSize: 12, fontFamily: "Roboto-regular"),
                            maxLines: 5,
                            cursorColor: Theme.of(context!).cursorColor,
                            maxLength: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 5, left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(width: 0, color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: baseColor, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(child: _buildbtsubmit())
            ],
          ),
        ),
      ),
    );
  }

  ///function
  Future categoryPermission() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response =
          await http.get(Uri.parse("${base_url}/api/permission-categories"));
      var data = jsonDecode(response.body);
      setState(() {
        typeList = data['data'];
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  ///widget
  Widget _buildbtsubmit() {
    return BlocBuilder<PermissionBloc, PermissionState>(
        builder: (context, state) {
      return state.isLoading == true
          ? Container(
              width: Get.mediaQuery.size.width,
              height: 40,
              child: Center(
                child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: baseColor,
                    )),
              ),
            )
          : Container(
              width: double.infinity,
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
                  onPressed: () async {
                    if (sickDateTotal! > maxDay!) {
                      print(_type);
                      Fluttertoast.showToast(
                          msg: "Pengambilan melebihi batas maksimal",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 11.0
                      );
                    } else {
                      context.read<PermissionBloc>().add(PermissionSubmission(
                        context: context,
                          employeeId: employeeId.toString(),
                          permissionCategoryId: _type.toString(),
                          dates: sick_date_submit.toString(),
                          numberofDay: sick_date_submit.length.toString(),
                          description: descriprionCtr.text));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(baseColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Roboto-regular"),
                  )),
            );
    });
  }
}
