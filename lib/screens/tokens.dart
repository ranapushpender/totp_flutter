import "package:flutter/material.dart";
import "../widgets/tokens/token_item.dart";

class Tokens extends StatefulWidget {
  Tokens({Key key}) : super(key: key);

  @override
  _TokensState createState() => _TokensState();
}

class _TokensState extends State<Tokens> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 180,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/tokens-header.png",
                  height: 180,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "ADMIN",
                              style: TextStyle(color: Colors.white,fontSize: 14),
                              
                            ),
                            Text(
                              "Tokens",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "LOGOUT",
                              style: TextStyle(color: Colors.white,fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(0, 3),
                                color: Color.fromRGBO(0, 0, 0, 0.20))
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        height: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: TextField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Color.fromRGBO(36, 129, 208, 1),
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.cloud_done,
                              color: Colors.white,
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Backed up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    75 -
                    105,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  itemBuilder: (buildContext, index) {
                    return TokenItem();
                  },
                  itemCount: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
