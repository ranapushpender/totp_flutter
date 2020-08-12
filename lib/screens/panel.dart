import "package:flutter/material.dart";
import 'package:totp_app/authentication/auth.dart';
import 'package:totp_app/db/Database.dart';
import 'package:totp_app/models/Device.dart';
import 'package:totp_app/widgets/devices/add_device_bottom_sheet.dart';
import 'package:totp_app/widgets/devices/devices.dart';
import 'package:totp_app/widgets/export/export.dart';
import 'package:totp_app/widgets/panel/header.dart';
import "../widgets/tokens/token_item.dart";
import "../widgets/tokens/add_bottom_sheet.dart";
import "../widgets/tokens/edit_bottom_sheet.dart";
import "../models/Token.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "../otp/otp.dart";
import "../encryption/encryption.dart";
import "../widgets/tokens/token_list.dart";

// ***REMOVED***
class Panel extends StatefulWidget {
  Panel({Key key}) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  int currentIndex = 0;
  String searchString = "";
  List<Widget> widgets = [];
  final List<Map<String, dynamic>> navigationItems = [
    {"tag": "OTP", "icon": Icons.list, "title": "Tokens"},
    {"tag": "Devices", "icon": Icons.tap_and_play, "title": "Devices"},
    {"tag": "Export", "icon": Icons.person, "title": "Export"},
  ];
  List<Device> devicesList = [];
  final addBottomSheets = [];
  @override
  void initState() {
    super.initState();
    addBottomSheets.add(AddBottomSheet(addToken: this.addToken));
    addBottomSheets.add(AddDeviceBottomSheet(addDevice: this.addDevice));
    initializeDevices();
  }

  void initializeDevices() {
    getDevices();
  }

  void getDevices() async {
    (await Database().getAllDevicesStream()).listen((event) async {
      var tokenDocuments = event.documents;
      var localDeviceList = await Future.wait(
        tokenDocuments.map(
          (e) async {
            print("DEVICE");
            print(e.documentID);
            Device device = Device(
              id: e.documentID,
              deviceName: e["deviceName"],
              devicePublicKey: e["devicePublicKey"],
              deviceLastSeen: '22-08-2019',
              deviceOnline: true,
            );
            return device;
          },
        ),
      );
      setState(() {
        devicesList = localDeviceList;
      });
    });
  }

  void onSearchTextChanged(eventData) {
    setState(() {
      this.searchString = eventData;
    });
    print("Search string $searchString");
  }

  Future<void> addToken(AppOTP token) async {
    Token tk = Token.createFromOTPString(otpString: token.otpString);
    var result = await tk.save();
    if (result) {
      print("TOken saved");
    } else {
      print("Token not saved");
    }
  }

  Future<void> addDevice(Device device) async {
    print("Device");
    print(device.devicePublicKey);
    print(await device.save());
  }

  @override
  Widget build(BuildContext context) {
    widgets = [
      TokenList(
        searchString: this.searchString,
      ),
      DevicesScreen(devicesToShow: devicesList),
      Export(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          ...(this.navigationItems.map(
            (e) {
              return BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(
                  e["icon"],
                  color: Colors.grey,
                ),
                title: Text(
                  e["tag"],
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          ).toList())
        ],
        currentIndex: this.currentIndex,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          setState(() {
            this.currentIndex = value;
          });
        },
      ),
      floatingActionButton: (currentIndex == 0 || currentIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return addBottomSheets[currentIndex];
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          PanelHeader(
            title: this.navigationItems[this.currentIndex]["title"],
            tag: this.navigationItems[this.currentIndex]["tag"],
            searchFunction: this.onSearchTextChanged,
          ),
          this.widgets[this.currentIndex],
        ],
      ),
    );
  }
}
