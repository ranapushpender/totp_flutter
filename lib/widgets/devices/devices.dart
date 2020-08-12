import "package:flutter/material.dart";
import 'package:totp_app/widgets/devices/device_item.dart';
import '../../models/Device.dart';

class DevicesScreen extends StatelessWidget {
  final devicesToShow;

  DevicesScreen({this.devicesToShow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 130),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              75 -
              65,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            itemBuilder: (buildContext, index) {
              return index == 0
                  ? SizedBox(
                      height: 28,
                    )
                  : DeviceItem(
                      device: devicesToShow[index - 1],
                    );
            },
            itemCount: devicesToShow.length + 1,
          ),
        ),
      ),
    );
  }
}
