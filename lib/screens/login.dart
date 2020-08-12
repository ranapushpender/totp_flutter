import 'package:flutter/material.dart';
import "../widgets/login/login_body.dart";
import "../authentication/auth.dart";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          LoginHeader(),
          Container(
            margin: EdgeInsets.only(top: 80),
            child: Align(
              child: LoginBody(),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        /*Image.asset(
          "assets/login-header.png",
          width: double.infinity,
          height: 500,
          fit: BoxFit.cover,
        ),*/
        Container(
          width: double.infinity,
          height: 480,
          decoration: BoxDecoration(color: Color.fromRGBO(55, 163, 255, 1)),
        ),
      ],
    );
  }
}
