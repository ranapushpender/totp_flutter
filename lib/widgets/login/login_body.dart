import 'package:flutter/material.dart';
import "./login_fields.dart";
import "./login_buttons.dart";

class LoginBody extends StatelessWidget {
  const LoginBody({
    Key key,
  }) : super(key: key);

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
              LoginFields(),
              SizedBox(
                height: 20,
              ),
              LoginButtons(),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                child: Text("Forgot Password ?"),
                textColor: Color.fromRGBO(55, 163, 255, 1),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}