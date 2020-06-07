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
  void didChangeDependencies() {
    checkLogin();
  }

  void checkLogin() async {
    if ((await FirebaseAuth.instance.currentUser()) != null) {
      // await EncryptionHelper.createHelper("123456");
      // Navigator.pushReplacementNamed(context,"/tokens");
    }
  }

  Future<void> getResponse() async {}

  void register() async {
    var auth = Authentication();
    var status = await auth.register(
      StringBuffer("ranapushpenderindia@gmail.com"),
      StringBuffer("123456"),
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
        StringBuffer("pushpender661@gmail.com"),
        StringBuffer("123456"),
      ));
      if (result) {
        Navigator.of(context).pushReplacementNamed("/tokens");
      }
    } catch (e) {
      print(
          "Invalid username or password or the user exists: ${e.toString()} ===");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
