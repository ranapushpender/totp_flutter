import 'package:flutter/material.dart';
import "../widgets/login/login_body.dart";
import "../authentication/auth.dart";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[LoginHeader(), LoginBody()],
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
        Image.asset(
          "assets/login-header.png",
          width: 420,
          height: 260,
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/login-image.png",
          width: 108,
          height: 117,
        ),
      ],
    );
  }
}



