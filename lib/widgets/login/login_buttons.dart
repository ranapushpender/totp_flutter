import "package:flutter/material.dart";

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      width: 200,
      child: Column(
        children: <Widget>[
          ButtonTheme(
            height: 45,
            minWidth: double.infinity,
            child: RaisedButton(
              elevation: 0,
              color: Color.fromRGBO(55, 163, 255, 1),
              onPressed: () { Navigator.of(context).pushNamed("/tokens"); },
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text("LOGIN"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ButtonTheme(
            minWidth: double.infinity,
            height: 45,
            child: OutlineButton(
              child: Text("REGISTER"),
              textColor: Color.fromRGBO(55, 163, 255, 1),
              borderSide: BorderSide(color: Color.fromRGBO(55, 163, 255, 1)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
