import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'package:superviso/assets/colors.dart';
import 'package:superviso/assets/style.dart';
import 'package:superviso/blocs/leave/leave_bloc.dart';
import 'package:superviso/blocs/leave/leave_event.dart';
import 'package:superviso/blocs/permission/permission_bloc.dart';
import 'package:superviso/blocs/permission/permission_event.dart';
import 'package:superviso/blocs/permission/permission_state.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddLeaveSubmissionPage extends StatefulWidget {
  String? remainingLeave;

  AddLeaveSubmissionPage({this.remainingLeave});

  @override
  _AddLeaveSubmissionPageState createState() => _AddLeaveSubmissionPageState();
}

class _AddLeaveSubmissionPageState extends State<AddLeaveSubmissionPage> {
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
  var leaveRemainingCtr = new TextEditingController();
  var employeeId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatapref();
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
          "Pengajuan Cuti",
          style: appbar,
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
              width: Get.mediaQuery.size.width,
              height: Get.mediaQuery.size.height,
              child: InkWell(
                child: Container(
                    margin: EdgeInsets.all(20), child: _formSickSubmission()),
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
              Container(
                  color: orangeColor,
                  height: 26,
                  width: double.infinity,
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
                          'Sisa cuti tahunan anda  ${widget.remainingLeave} hari',
                          style: TextStyle(color: blackColor4, fontSize: 11),
                        ))
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),

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
                        "Tanggal Cuti",
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
                                  color: Colors.black.withOpacity(0.5),
                                  fontFamily: "Roboto-regular",
                                  fontSize: 10,
                                  letterSpacing: 0.5),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),

              //description
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

              //description
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

  Widget _buildbtsubmit() {
    return BlocBuilder<PermissionBloc, PermissionState>(
        builder: (context, state) {
      return state.isLoading == true
          ? Container(
              width: 40,
              height: 40,
              child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: baseColor,
                  )),
            )
          : Container(
              width: double.infinity,
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
                  onPressed: () async {
                    context.read<LeaveBloc>().add(LeaveSubmission(
                      employeeId: employeeId.toString(),
                        dates: sick_date_submit.toString(),
                        description: descriprionCtr.text,
                        context: context


                        // employeeId.toString(),
                        // sick_date_submit.toString(),
                        // descriprionCtr.text)
                    ));
                    // context.read<PermissionBloc>().add(PermissionSubmission(
                    //     employeeId.toString(),
                    //     sick_date_submit.toString(),
                    //     descriprionCtr.text,
                    //     sick_date_submit.length.toString()));
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
