
import 'package:flutter/material.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/models/user_location.dart';


class MapPinPillComponent extends StatefulWidget {

  double pinPillPosition;
  UserLocation currentlySelectedPin;

  MapPinPillComponent({ required this.pinPillPosition, required this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
              ]
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50, height: 50,
                margin: EdgeInsets.only(left: 10),
                child: ClipOval(child: Image.asset(widget.currentlySelectedPin.avatarPath.toString(), fit: BoxFit.cover )),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(widget.currentlySelectedPin.locationName.toString(), style: TextStyle(color: greyColor))),
                      // Text('Latitude: ${widget.currentlySelectedPin.location!..toString()}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      //
                      //Text('Longitude: ${widget.currentlySelectedPin.location!.longitude.toString()}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(15),
              //   child: Image.asset(widget.currentlySelectedPin.pinPath.toString(), width: 50, height: 50),
              // )
            ],
          ),
        ),
      ),
    );
  }

}