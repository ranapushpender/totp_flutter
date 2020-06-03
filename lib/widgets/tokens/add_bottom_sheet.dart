import "package:flutter/material.dart";
import 'package:barcode_scan/barcode_scan.dart';
import "../../models/Token.dart";

class AddBottomSheet extends StatelessWidget {

  final addToken;
  final tokenTest;

  AddBottomSheet({this.addToken,this.tokenTest});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      width: 100,
      height: 400,
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
            decoration: InputDecoration(labelText: "Enter token or use camera"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Enter website"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Enter username"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "USE CAMERA",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  var result = await BarcodeScanner.scan();
                  print(result.rawContent.toString());
                  Map<String,String> tokenInfo={};
                  String username = result.rawContent.split("totp/")[1].split("?")[0];
                  List<String> credentials = result.rawContent.split("totp/")[1].split("?")[1].split("&");

                  for(int i=0;i<credentials.length;i++)
                  {
                    tokenInfo[credentials[i].split("=")[0]] = credentials[i].split("=")[1];
                  }
                  var newToken = Token(email: username,id: DateTime.now().millisecondsSinceEpoch,token: tokenInfo["secret"],website: tokenInfo["issuer"]);
                  addToken(newToken);
                },
              ),
              RaisedButton(
                elevation: 0,
                color: Color.fromRGBO(55, 163, 255, 1),
                onPressed: () {this.tokenTest();},
                child: Text(
                  "SUBMIT",
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
