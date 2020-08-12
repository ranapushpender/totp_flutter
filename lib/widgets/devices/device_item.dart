import "package:flutter/material.dart";
import 'package:totp_app/models/Device.dart';

class DeviceItem extends StatelessWidget {
  final Device device;
  final onDeviceItemClick;
  DeviceItem({this.device, this.onDeviceItemClick});

  Widget build(BuildContext context) {
    return (Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.only(left: 15, right: 0, top: 18, bottom: 18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(5, 5, 5, 0.07),
                  offset: Offset.zero,
                  spreadRadius: 5,
                  blurRadius: 5)
            ]),
        child: Row(
          children: <Widget>[
            //Heading
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () {
                    onDeviceItemClick(device);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        device.deviceName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(88, 88, 88, 1),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        device.deviceLastSeen,
                        style: TextStyle(
                          color: Color.fromRGBO(152, 152, 152, 1),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("DELETE"),
                    onPressed: () async {
                      await device.delete();
                    },
                    textColor: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
