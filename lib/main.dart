import "package:flutter/material.dart";
import "./screens/login.dart";
import "./screens/tokens.dart";
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import "./db/TokenHelper.dart";

void main() async {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  wb.
  await TokenHelper.init();
  return runApp(TotpApp());
}

class TotpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(55, 163, 255, 1));
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Tokens(),
      routes: {"/tokens": (context) => Tokens()},
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
      backgroundColor: Color.fromRGBO(55, 163, 255, 1),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Login(),
      ),
    );
  }
}
