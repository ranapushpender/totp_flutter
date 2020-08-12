import "package:flutter/material.dart";
import 'package:barcode_scan/barcode_scan.dart';
import 'package:totp_app/models/Device.dart';
import '../../models/Token.dart';
import '../../otp/otp.dart';

class AddDeviceBottomSheet extends StatefulWidget {
  final addDevice;

  AddDeviceBottomSheet({this.addDevice});

  @override
  _AddDeviceBottomSheet createState() => _AddDeviceBottomSheet();
}

class _AddDeviceBottomSheet extends State<AddDeviceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      width: 100,
      height: 310,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter the details",
            style: TextStyle(
              fontSize: 22,
              color: Color.fromRGBO(60, 60, 60, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration:
                InputDecoration(labelText: "Enter device key or use camera"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Enter device name"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "USE CAMERA",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  var result = await BarcodeScanner.scan();
                  print(result.rawContent.toString().split("*****")[0]);
                  print(result.rawContent.toString().split("*****")[1]);
                  final device = new Device(
                    deviceName: result.rawContent.toString().split("*****")[0],
                    devicePublicKey:
                        result.rawContent.toString().split("*****")[1],
                    deviceLastSeen: '22-08-20',
                    deviceOnline: true,
                  );
                  await widget.addDevice(device);
                  return;
                },
              ),
              RaisedButton(
                elevation: 0,
                color: Color.fromRGBO(55, 163, 255, 1),
                onPressed: () {},
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
