import "package:flutter/material.dart";
import "../widgets/tokens/token_item.dart";
import "../widgets/tokens/add_bottom_sheet.dart";
import "../models/Token.dart";
import "../db/TokenHelper.dart";

class Tokens extends StatefulWidget {
  Tokens({Key key}) : super(key: key);

  @override
  _TokensState createState() => _TokensState();
}

class _TokensState extends State<Tokens> {
  List<Token> tokens = [];

  @override
  void initState() {
    initTokens();
    super.initState();
  }

  void initTokens()  {
    getTokens();
  }

  void getTokens() async {
    tokens = await TokenHelper.getTokens();

  }

  void addTokenTest() async {
    /*Token token = Token(
        email: "dsds",
        id: 24342,
        token: "JBSWY3DPEHPK3PXP",
        website: "Alibaba.com");
    var tokenHelper = TokenHelper.init();
    await (tokenHelper.insertToken(token));
    var localTokens = (await tokenHelper.getTokens()) as List<Token>;
    setState(() {
      tokens = localTokens;
    });*/
  }

  void showAddSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddBottomSheet(
            addToken: this.addToken,
            tokenTest: this.addTokenTest,
          );
        });
  }

  void addToken(Token token) {
    setState(() {
      tokens.add(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.list,
              color: Colors.blue,
            ),
            title: Text(
              "Tokens",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.backup,
              color: Colors.blue,
            ),
            title: Text(
              "Backup",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.feedback,
              color: Colors.blue,
            ),
            title: Text(
              "Feedback",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            title: Text(
              "Support",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
        currentIndex: 1,
        showUnselectedLabels: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSheet(context);
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 185),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    75 -
                    65,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  itemBuilder: (buildContext, index) {
                    return index == 0
                        ? SizedBox(
                            height: 28,
                          )
                        : TokenItem(
                            token: tokens[index - 1],
                          );
                  },
                  itemCount: tokens.length + 1,
                ),
              ),
            ),
          ),
          Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/tokens-header.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                "ADMIN",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              onPressed: () {},
                            ),
                            Text(
                              "Tokens",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                "LOGOUT",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
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
                        height: 8,
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
                        padding: EdgeInsets.symmetric(horizontal: 25),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
