import "package:flutter/material.dart";
import 'package:totp_app/authentication/auth.dart';
import 'package:totp_app/db/Database.dart';
import "../widgets/tokens/token_item.dart";
import "../widgets/tokens/add_bottom_sheet.dart";
import "../widgets/tokens/edit_bottom_sheet.dart";
import "../models/Token.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "../otp/otp.dart";
import "../encryption/encryption.dart";

// ***REMOVED***
class Panel extends StatefulWidget {
  Panel({Key key}) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  List<Token> tokens = [];
  int currentIndex;
  final database = Database();

  @override
  void initState() {
    currentIndex = 0;
    initTokens();
    super.initState();
  }

  void initTokens() {
    getTokens();
  }

  void getTokens() async {
    await EncryptionHelper.createHelper("123456");
    var localTokens = await Database().getAllTokens();
    setState(() {
      tokens = localTokens;
    });
    print("TOkens found : $tokens");
  }

  void addTokenTest() async {}

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

  void showEditDialog(int index) {
    print("Index to edit : $index");
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditBottomSheet(
            deleteToken: this.deleteToken,
            updateToken: this.updateToken,
            token: tokens[index]);
      },
    );
  }

  void deleteToken(Token token) async {
    await token.delete();
    refresh();
  }

  Future<void> addToken(AppOTP token) async {
    Token tk = Token.createFromOTPString(otpString: token.otpString);
    var result = await tk.save();
    if (result) {
      print("TOken saved");
      await refresh();
    } else {
      print("Token not saved");
    }
  }

  void updateToken(Token token) async {
    print("Updating ${token.secret} ${token.documentID}");
    await token.update();
    await refresh();
  }

  Future<void> refresh() async {
    var localTokens = await Database().getAllTokens();

    setState(() {
      tokens = localTokens;
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
              color: Colors.grey,
            ),
            title: Text(
              "OTP",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.backup,
              color: Colors.grey,
            ),
            title: Text(
              "Export",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.content_copy,
              color: Colors.grey,
            ),
            title: Text(
              "Feedback",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: Text(
              "Support",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
        currentIndex: 0,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
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
                            showEditDialog: this.showEditDialog,
                            index: index - 1);
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
                              onPressed: () async {
                                try{
                                  await Authentication().logout();
                                }
                                catch(e){

                                }
                                finally{
                                  Navigator.pushReplacementNamed(context, "/");
                                }
                                
                              },
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
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 5),
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
