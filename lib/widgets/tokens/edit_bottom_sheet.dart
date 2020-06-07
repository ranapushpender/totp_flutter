import "package:flutter/material.dart";
import 'package:barcode_scan/barcode_scan.dart';
import "../../models/Token.dart";
import "../../otp/otp.dart";

class EditBottomSheet extends StatefulWidget {
  final deleteToken;
  final Token token;
  final updateToken;

  EditBottomSheet({this.deleteToken, this.token, this.updateToken});

  @override
  _EditBottomSheetState createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  TextEditingController secretController = TextEditingController();
  TextEditingController issuerController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController labelController = TextEditingController();

  @override
  void initState() {
    if (widget.token.secret != null) {
      secretController.text = widget.token.secret.toString();
    }
    if (widget.token.issuer != null) {
      issuerController.text = widget.token.issuer.toString();
    }
    if (widget.token.username != null) {
      usernameController.text = widget.token.username.toString();
    }
    if (widget.token.label != null) {
      labelController.text = widget.token.label.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      width: 100,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter the details",
            style: TextStyle(
              fontSize: 22,
              color: Color.fromRGBO(60, 60, 60, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Enter secret"),
            controller: secretController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Issuer"),
            controller: issuerController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Username"),
            controller: usernameController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Label"),
            controller: labelController,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  widget.deleteToken(widget.token);
                },
              ),
              RaisedButton(
                elevation: 0,
                color: Color.fromRGBO(55, 163, 255, 1),
                onPressed: () {
                  //print("Edited fields ${labelController.text}");
                  widget.token.secret.clear();
                  widget.token.secret = StringBuffer(secretController.text);
                  widget.token.issuer = issuerController.text.toString();
                  widget.token.username = usernameController.text;
                  widget.token.label = labelController.text;
                  widget.updateToken(widget.token);
                },
                child: Text(
                  "UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
