import "package:flutter/material.dart";
import "./screens/login.dart";
import "./screens/panel.dart";
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import "./screens/panel.dart";

void main() async {
  return runApp(TotpApp());
}

class TotpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(55, 163, 255, 1));
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
      routes: {"/home": (context) => Panel()},
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*backgroundColor: Color.fromRGBO(55, 163, 255, 1),*/
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Login(),
      ),
    );
  }
}
