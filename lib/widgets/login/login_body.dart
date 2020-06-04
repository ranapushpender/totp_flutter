import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "./login_fields.dart";
import "./login_buttons.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "../../encryption/encryption.dart";
import "package:flutter/services.dart";

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

  Future<void> getResponse() async {}

  void register() async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "pushpender661@gmail.com", password: "123456");
      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        if (!user.isEmailVerified) {
          user.sendEmailVerification();
        }
      } catch (e) {
        print("Some error has occured");
      }
    } catch (e) {
      print("Error user may already exist");
      print(e);
    }
  }

  void login() async {
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "pushpender661@gmail.com",
        password: "123456",
      );
      var currentUser = await FirebaseAuth.instance.currentUser();
      if (currentUser.isEmailVerified) {
        var uid = currentUser.uid;
        var document =
            await Firestore.instance.collection("/users").document(uid).get();

        if (!document.exists) {
          const platform = MethodChannel("com.flutter.epic/epic");
          print("Generating master key");
          List<dynamic> credentials = await EncryptionHelper.createMasterKey(
            new StringBuffer("123456"),
          );
          print(credentials);
          await Firestore.instance
              .collection("/users")
              .document(uid)
              .setData({"uid": uid});
          await Firestore.instance
              .collection("/users")
              .document(uid)
              .collection("keys")
              .document("masterKey")
              .setData(
            {
              "masterKey": credentials[0],
              "salt": credentials[1],
            },
          );
        } else {
          print("No need for master key");
        }
        //Navigator.pushReplacementNamed(context, "/tokens");
      } else {
        currentUser.sendEmailVerification();
        print("Email Verification sent");
      }
      print("Testing****");
      await EncryptionHelper.createHelper("123456");
      var encTestToken =await (await EncryptionHelper.createHelper("123456")).encrypt("I am pushpe");
      print(encTestToken);
      print(await (await EncryptionHelper.createHelper("123456")).decrypt(encTestToken));
      //Navigator.pushReplacementNamed(context, "/tokens");
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
