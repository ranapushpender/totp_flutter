import "package:flutter/material.dart";
import "../../../authentication/auth.dart";

class Headerbar extends StatelessWidget {
  final String title;
  Headerbar({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "ADMIN",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {},
          ),
          Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          FlatButton(
            child: Text(
              "LOGOUT",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () async {
              try {
                await Authentication().logout();
              } catch (e) {} finally {
                Navigator.pushReplacementNamed(context, "/");
              }
            },
          ),
        ],
      ),
    );
  }
}
