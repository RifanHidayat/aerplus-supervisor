import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/assets/style.dart';
import 'package:superviso/models/approval_flows.dart';
import 'package:superviso/pages/sick/sick_attachment.dart';
import 'package:superviso/repositories/api.dart';
import 'package:intl/intl.dart';

class SickDetailPage extends StatefulWidget {
  var status, sickDates, note, date, attachment, confirmer;
  List<ApprovalFlowsModel> approvalFlows;

  SickDetailPage(
      {this.status,
      this.sickDates,
      this.note,
      this.date,
      this.attachment,
      this.confirmer,
      required this.approvalFlows});

  @override
  _SickDetailPageState createState() => _SickDetailPageState();
}

class _SickDetailPageState extends State<SickDetailPage> {
  var dateLocal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var d = DateTime.parse(widget.date.toString());

    dateLocal = d.toLocal();
    dateLocal = DateFormat().format(dateLocal);
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
          "Detail Pengajuan Sakit",
          style: appbar,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _info(),
        ),
      ),
    );
  }

  Widget _info() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Container(
                child: Text(
                  "Hari dan Tanggal",
                  style: TextStyle(
                      color: blackColor2,
                      fontFamily: "Roboto-medium",
                      fontSize: 13,
                      letterSpacing: 0.5),
                ),
              ),
              widget.status == "rejected"
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: double.maxFinite,
                        child: Container(
                          alignment: Alignment.center,
                          width: 73,
                          height: 17,
                          decoration: BoxDecoration(
                              color: redColorInfo,
                              borderRadius: BorderRadius.circular(10)),
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
                        ),
                      ),
                    )
                  : widget.status == "approved"
                      ? Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: double.maxFinite,
                            child: Container(
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
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: double.maxFinite,
                            child: Container(
                              alignment: Alignment.center,
                              width: 73,
                              height: 17,
                              decoration: BoxDecoration(
                                  color: yellowColorInfo,
                                  borderRadius: BorderRadius.circular(10)),
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
            height: 5,
          ),
          Container(
            child: Text(
              "${Waktu(DateTime.parse(widget.date.toString())).yMMMMEEEEd()}",
              style: TextStyle(
                  color: baseColor,
                  fontFamily: "Roboto-regular",
                  fontSize: 11,
                  letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              "Tanggal pengajuan pada ${widget.sickDates}",
              style: TextStyle(
                  color: blackColor4,
                  fontFamily: "Roboto-regular",
                  fontSize: 11,
                  letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              "keterangan",
              style: TextStyle(
                  color: blackColor2,
                  fontFamily: "Roboto-medium",
                  fontSize: 13,
                  letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Text(
              "${widget.note ?? "-"}",
              style: TextStyle(
                  color: blackColor4,
                  fontFamily: "Roboto-regular",
                  fontSize: 11,
                  letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              "Lampiran",
              style: TextStyle(
                  color: blackColor2,
                  fontFamily: "Roboto-medium",
                  fontSize: 13,
                  letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          widget.attachment != null
              ? Container(
                  width: Get.mediaQuery.size.width,
                  height: 150,
                  color: Colors.black.withOpacity(0.1),
                  child: InkWell(
                      onTap: () {
                        Get.to(SickAttachmentPage(
                          image: widget.attachment,
                        ));
                      },
                      child: Image.network(
                        "${image_url}/${widget.attachment}",
                        fit: BoxFit.fill,
                      )),
                )
              : Container(
                  width: Get.mediaQuery.size.width,
                  height: 150,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(
                          Icons.folder_open_outlined,
                          size: 20,
                          color: blackColor4,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tidak ada lampiran",
                        style: TextStyle(
                            color: blackColor4,
                            letterSpacing: 0.5,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          widget.status == "pending"
              ? Container()
              : Container(
                  child: Text(
                    "Detail Persetujuan",
                    style: TextStyle(
                        color: blackColor2,
                        fontFamily: "Roboto-medium",
                        fontSize: 13,
                        letterSpacing: 0.5),
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          widget.status == "pending" ? Container() : approvalDetail()
        ],
      ),
    );
  }

  Widget approvalDetail() {
    return Container(
      child: Column(
          children: List.generate(widget.approvalFlows.length, (index) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: Get.mediaQuery.size.width,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "${dateLocal ?? ""} ",
                                        style: TextStyle(
                                          color: baseColor,
                                          fontSize: 13,
                                          fontFamily: "Roboto-regular",
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: widget.approvalFlows[index]
                                                  .status ==
                                              "approved"
                                          ? Text(
                                              "Approved By ${widget.approvalFlows[index].confirmer!.name}",
                                              style: TextStyle(
                                                color: blackColor4,
                                                fontSize: 10,
                                                fontFamily: "Roboto-regular",
                                                letterSpacing: 0.5,
                                              ),
                                            )
                                          : Text(
                                              "Rejected By ${widget.approvalFlows[index].confirmer!.name}",
                                              style: TextStyle(
                                                color: blackColor4,
                                                fontSize: 10,
                                                fontFamily: "Roboto-regular",
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: double.maxFinite,
                                  child: widget.approvalFlows[index].status ==
                                          "approved"
                                      ? Icon(
                                          Icons.check,
                                          size: 80,
                                          color: Colors.green.withOpacity(0.1),
                                        )
                                      : Icon(
                                          Icons.close,
                                          size: 80,
                                          color: Colors.green.withOpacity(0.1),
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
              widget.approvalFlows[index].status == "approved"
                  ? Container(
                      child: Container(
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
                      ),
                    )
                  : Container(
                      child: Container(
                        alignment: Alignment.center,
                        width: 73,
                        height: 17,
                        decoration: BoxDecoration(
                            color: redColorInfo,
                            borderRadius: BorderRadius.circular(10)),
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
                      ),
                    ),
            ],
          ),
        );
      })),
    );
  }

  Widget _rejectedinfo() {
    return Container(
      width: Get.mediaQuery.size.width,
      decoration: BoxDecoration(
          color: redColorInfo, borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Tanggal",
                              style: TextStyle(
                                  fontFamily: "Roboto-medium",
                                  fontSize: 11,
                                  color: blackColor2,
                                  letterSpacing: 0.5),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${Waktu(DateTime.now()).yMMMMEEEEd()}",
                              style: TextStyle(
                                  fontFamily: "Roboto-regular",
                                  fontSize: 10,
                                  color: blackColor4,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Waktu",
                                style: TextStyle(
                                    fontFamily: "Roboto-medium",
                                    fontSize: 11,
                                    color: blackColor2,
                                    letterSpacing: 0.5),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "17:00:00",
                                style: TextStyle(
                                    fontFamily: "Roboto-regular",
                                    fontSize: 10,
                                    color: blackColor4,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ditotak Oleh :",
                    style: TextStyle(
                        fontFamily: "Roboto-medium",
                        fontSize: 11,
                        color: blackColor2,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rifan Hidayat",
                    style: TextStyle(
                        fontFamily: "Roboto-regular",
                        fontSize: 10,
                        color: blackColor4,
                        letterSpacing: 0.5),
                  ),
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
                  Text(
                    "Catatan",
                    style: TextStyle(
                        fontFamily: "Roboto-medium",
                        fontSize: 11,
                        color: blackColor2,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "-",
                    style: TextStyle(
                        fontFamily: "Roboto-regular",
                        fontSize: 10,
                        color: blackColor4,
                        letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _approvedInfo() {
    return Container(
      width: Get.mediaQuery.size.width,
      decoration: BoxDecoration(
          color: greenColorInfo, borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Tanggal",
                              style: TextStyle(
                                  fontFamily: "Roboto-medium",
                                  fontSize: 11,
                                  color: blackColor2,
                                  letterSpacing: 0.5),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${Waktu(DateTime.now()).yMMMMEEEEd()}",
                              style: TextStyle(
                                  fontFamily: "Roboto-regular",
                                  fontSize: 10,
                                  color: blackColor4,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Waktu",
                                style: TextStyle(
                                    fontFamily: "Roboto-medium",
                                    fontSize: 11,
                                    color: blackColor2,
                                    letterSpacing: 0.5),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "17:00:00",
                                style: TextStyle(
                                    fontFamily: "Roboto-regular",
                                    fontSize: 10,
                                    color: blackColor4,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Diterima Oleh :",
                    style: TextStyle(
                        fontFamily: "Roboto-medium",
                        fontSize: 11,
                        color: blackColor2,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rifan Hidayat",
                    style: TextStyle(
                        fontFamily: "Roboto-regular",
                        fontSize: 10,
                        color: blackColor4,
                        letterSpacing: 0.5),
                  ),
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
                  Text(
                    "Catatan",
                    style: TextStyle(
                        fontFamily: "Roboto-medium",
                        fontSize: 11,
                        color: blackColor2,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "-",
                    style: TextStyle(
                        fontFamily: "Roboto-regular",
                        fontSize: 10,
                        color: blackColor4,
                        letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
