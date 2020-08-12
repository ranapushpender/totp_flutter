import "package:flutter/material.dart";
import 'package:totp_app/widgets/devices/device_item.dart';
import '../../models/Device.dart';

class DevicesScreen extends StatelessWidget {
  final devicesToShow;
  final currentToken;

  DevicesScreen({this.devicesToShow, this.currentToken});

  void onDeviceItemClick(Device device) {
    print("Sending TOken : " + device.sendToken(this.currentToken));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 180),
      child: Column(
        children: <Widget>[
          Text(
            "Tap a device name to send the token : $currentToken",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  75 -
                  65 -
                  85,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                itemBuilder: (buildContext, index) {
                  return index == 0
                      ? SizedBox(
                          height: 10,
                        )
                      : DeviceItem(
                          device: devicesToShow[index - 1],
                          onDeviceItemClick: onDeviceItemClick,
                        );
                },
                itemCount: devicesToShow.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
