import 'package:flutter/material.dart';

class LoginFields extends StatelessWidget {

  final usernameController;
  final passwordController;

 LoginFields({
   this.usernameController,
   this.passwordController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          clipBehavior: Clip.antiAlias,
          height: 45,
          child: TextField(
            controller: this.usernameController,
            style: TextStyle(color: Color.fromRGBO(55, 163, 255, 1)),
            decoration: InputDecoration(
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
              border: InputBorder.none,
              hintText: "Username",
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          clipBehavior: Clip.antiAlias,
          height: 45,
          child: TextField(
            controller: this.passwordController,
            style: TextStyle(color: Color.fromRGBO(55, 163, 255, 1)),
            decoration: InputDecoration(
              fillColor: Color.fromRGBO(245, 245, 245, 1),
              filled: true,
              border: InputBorder.none,
              hintText: "Password",
            ),
          ),
        ),
      ],
    );
  }
}