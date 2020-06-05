import "package:flutter/material.dart";
import "../../models/Token.dart";
import "package:otp/otp.dart";

class TokenItem extends StatefulWidget {
  Token token;
  TokenItem({this.token});

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
    var tk = await widget.token.getToken;
    print("Token Item : $tk");
    setState(() {
      var cdate = DateTime.now();
      try {
        generatedToken = OTP
            .generateTOTPCodeString(
              tk,
              cdate.toUtc().millisecondsSinceEpoch,
              interval: 30,
              length: 6,
              algorithm: Algorithm.SHA1,
            )
            .toString();
      } catch (StackTrace) {
        generatedToken = "INVALID";
      }
    });
    int toAdd = 0;
    var cdate = DateTime.now();
    if (cdate.second >= 30) {
      toAdd = 60 - cdate.second;
    } else {
      toAdd = 30 - cdate.second;
    }
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
                  widget.token.website == null
                      ? "I"
                      : widget.token.website.substring(0, 1).toUpperCase(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.token.website == null
                          ? "Unavailable"
                          : widget.token.website,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(88, 88, 88, 1),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.token.email,
                      style: TextStyle(
                        color: Color.fromRGBO(152, 152, 152, 1),
                      ),
                    )
                  ],
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
                    onPressed: () {},
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
