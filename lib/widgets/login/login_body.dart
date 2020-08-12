import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "./login_fields.dart";
import "./login_buttons.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "../../encryption/encryption.dart";
import "package:flutter/services.dart";
import "../../authentication/auth.dart";

class LoginBody extends StatefulWidget {
  Firestore db;

  LoginBody({
    Key key,
  }) : super(key: key) {
    db = Firestore.instance;
  }

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void initState() {
    usernameController.text = "pushpender661@gmail.com";
    passwordController.text = "123456";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    checkLogin();
  }

  void checkLogin() async {
    if (await Authentication().isLoggedIn()) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  Future<void> getResponse() async {}

  void register() async {
    var auth = Authentication();
    var status = await auth.register(
      StringBuffer(usernameController.text),
      StringBuffer(passwordController.text),
    );
    if (status) {
      print("Register successful");
    } else {
      print("Error already registerd");
    }
  }

  void login() async {
    try {
      var result = await (Authentication().login(
        StringBuffer(usernameController.text),
        StringBuffer(passwordController.text),
      ));
      if (result) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
    } catch (e) {
      print(
          "Invalid username or password or the user exists: ${e.toString()} ===");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/login-image.png",
          width: 108,
          height: 117,
        ),
        SizedBox(
          height: 60,
        ),
        Container(
          width: 330,
          margin: EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(5, 5, 5, 0.07),
                      offset: Offset.zero,
                      spreadRadius: 10,
                      blurRadius: 10)
                ]),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Color.fromRGBO(55, 163, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  LoginFields(
                    usernameController: usernameController,
                    passwordController: passwordController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LoginButtons(
                    login: this.login,
                    register: this.register,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text("Forgot Password ?"),
                    textColor: Color.fromRGBO(55, 163, 255, 1),
                    onPressed: () {
                      getResponse();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
