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
import 'package:superviso/blocs/sick/sick_bloc.dart';
import 'package:superviso/blocs/sick/sick_event.dart';
import 'package:superviso/blocs/sick/sick_state.dart';
import 'package:superviso/repositories/api.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditSickSubmissionPage extends StatefulWidget {
  var date, sickDates, attachment, note, id;

  EditSickSubmissionPage(
      {this.date, this.sickDates, this.attachment, this.note, this.id});

  @override
  _EditSickSubmissionPageState createState() => _EditSickSubmissionPageState();
}

class _EditSickSubmissionPageState extends State<EditSickSubmissionPage> {
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
  List<DateTime> initial = [];
  var employeeId;
  File image = File("");
  var imagePath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatapref();

    descriprionCtr.text = widget.note;
    var dates = widget.sickDates.split(',');

    dates.forEach(
      (String date) {
        DateTime dt = DateTime.parse(date);

        initial.add(dt);
        // print(dt);
        sick_dates.add(
            DateFormat('dd/MM/yyyy').format(DateTime.parse(date.toString())));
        sick_date_submit.add(
            DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString())));
      },
    );
    _initialSelectedDates = initial;
    sickDatedCtr.text = sick_dates.toString();
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
          "Ubah Pengajuan Sakit",
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

  void chooseImage() async {
    var checkinImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (checkinImage != null) {
      setState(() {
        widget.attachment = null;
        image = File(checkinImage.path);
        imagePath = checkinImage.path;
        attachmentController.text = checkinImage.path;
      });
    } else {}
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
                child: Text(
                  "${Waktu(DateTime.parse(widget.date)).yMMMMEEEEd()}",
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
                        "Tanggal Sakit",
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
                          // multipleDate();
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Lampiran",
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
                        // multipleDate();
                        chooseImage();
                      },
                      child: Container(
                        child: TextFormField(
                          controller: attachmentController,
                          cursorColor: Theme.of(context!).cursorColor,
                          enabled: false,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 12, fontFamily: "Roboto-regular"),
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
                              Icons.camera_alt_outlined,
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
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child:
                widget.attachment != null
                    ? Container(
                        color: Colors.black.withOpacity(0.1),
                        height: 150,
                        width: Get.mediaQuery.size.width,
                        child: Image.network(
                          "${image_url}/${widget.attachment}",
                          fit: BoxFit.fill,
                        ),
                      )
                    : imagePath != ""
                        ? Container(
                            color: Colors.black.withOpacity(0.1),
                            height: 150,
                            width: Get.mediaQuery.size.width,
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(),
              ),

              Container(child: _buildbtsubmit())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildbtsubmit() {
    return BlocBuilder<SickBloc, SickState>(builder: (context, state) {
      return state.isLoading == true
          ? Container(
              width: Get.mediaQuery.size.width,
              height: 40,
              child: Center(
                child: Container(
                    width: 40,
                    height: 40,
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
                    print(widget.id.toString());
                    context.read<SickBloc>().add(EditSickSubmission(
                      context: context,
                        attachment: imagePath.toString() == ""
                            ? null
                            : imagePath.toString(),
                        id: widget.id,
                        date: widget.date.toString(),
                        employeeId: employeeId.toString(),
                        description: descriprionCtr.text,
                        dates: sick_date_submit.toString()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(baseColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Roboto-regular"),
                  )),
            );
    });
  }
}
