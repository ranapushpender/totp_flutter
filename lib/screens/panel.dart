import "package:flutter/material.dart";
import 'package:totp_app/authentication/auth.dart';
import 'package:totp_app/db/Database.dart';
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
  List<Widget> widgets = [
    TokenList(),
  ];
  final List<Map<String, dynamic>> navigationItems = [
    {
      "tag": "OTP",
      "icon": Icons.list,
      "title":"Tokens"
    },
    {
      "tag": "Export",
      "icon": Icons.tap_and_play,
      "title":"Export"
    },
    {
      "tag": "Support",
      "icon": Icons.person,
      "title":"Support"
    },
  ];


  @override
  Widget build(BuildContext context) {
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
      ),
      floatingActionButton: (currentIndex == 0)
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            )
          : null,
      body: Stack(alignment: Alignment.topCenter, children: <Widget>[
        PanelHeader(title:this.navigationItems[this.currentIndex]["title"],tag: this.navigationItems[this.currentIndex]["tag"],),
        this.widgets[this.currentIndex],
      ]),
    );
  }
}
