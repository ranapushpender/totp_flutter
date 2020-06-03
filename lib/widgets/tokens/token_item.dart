import "package:flutter/material.dart";

class TokenItem extends StatelessWidget {
  const TokenItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  "G",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22),
                ),
              ),
              width: 55,
              height: 55,
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
                      "Google.com",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(88, 88, 88, 1),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "ranapushpender",
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
                    child: Text("999 999"),
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
