import "package:flutter/material.dart";
import "../../models/Token.dart";
import "package:otp/otp.dart";
import "../../otp/otp_generator.dart";

class TokenItem extends StatefulWidget {
  Token token;
  final showEditDialog;
  final int index;
  final changeCurrentTokenAndSend;
  TokenItem(
      {this.token,
      this.showEditDialog,
      this.index,
      this.changeCurrentTokenAndSend});

  @override
  _TokenItemState createState() => _TokenItemState();
}

class _TokenItemState extends State<TokenItem> {
  String generatedToken;

  @override
  void initState() {
    generatedToken = "000000";
    generateCode();
    super.initState();
  }

  void generateCode() async {
    print("THe token ${widget.token.secret}");
    int toAdd = 0;
    var cdate = DateTime.now();
    if (cdate.second >= 30) {
      toAdd = 60 - cdate.second;
    } else {
      toAdd = 30 - cdate.second;
    }
    setState(() {
      generatedToken = OTPGenerator(token: widget.token).generateToken();
    });
    Future.delayed(Duration(seconds: toAdd), () {
      generateCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.only(left: 15, right: 0, top: 18, bottom: 18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(5, 5, 5, 0.07),
                  offset: Offset.zero,
                  spreadRadius: 5,
                  blurRadius: 5)
            ]),
        child: Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  widget.token.issuer == null
                      ? "I"
                      : widget.token.issuer.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22),
                ),
              ),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(98, 183, 255, 1),
                    Color.fromRGBO(18, 117, 201, 1),
                  ],
                ),
              ),
            ),
            //Heading
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () {
                    widget.showEditDialog(widget.index);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.token.issuer == null
                            ? "Unavailable"
                            : widget.token.issuer,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(88, 88, 88, 1),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.token.label,
                        style: TextStyle(
                          color: Color.fromRGBO(152, 152, 152, 1),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(this.generatedToken.toString()),
                    onPressed: () {
                      final snackBar = SnackBar(
                        content:
                            Text('Tap ok to send this to one of your devices'),
                        action: SnackBarAction(
                          label: "SEND",
                          onPressed: () {
                            widget.changeCurrentTokenAndSend(generatedToken);
                            print("YOLO");
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    textColor: Color.fromRGBO(25, 208, 36, 1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
