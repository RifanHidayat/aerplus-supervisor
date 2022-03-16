import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:superviso/repositories/api.dart';

class SickAttachmentPage extends StatefulWidget {
  SickAttachmentPage({this.image});

  var image;

  @override
  _SickAttachmentPageState createState() => _SickAttachmentPageState();
}

class _SickAttachmentPageState extends State<SickAttachmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black87,
          child: Center(
            child: Hero(
              tag: "avatar-1",
              child: Container(
                  child: widget.image == null
                      ? PhotoView(
                      imageProvider: const AssetImage(
                        "assets/absen.jpeg",
                      ))
                      : PhotoView(
                      imageProvider: NetworkImage(
                        "${image_url}/${widget.image}",
                      ))),
            ),
          ),
        ));
  }
}
