import "package:flutter/material.dart";
import "../widgets/tokens/token_item.dart";
import "../widgets/tokens/add_bottom_sheet.dart";
import "../widgets/tokens/edit_bottom_sheet.dart";
import "../models/Token.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "../encryption/otp.dart";

// ***REMOVED***
class Tokens extends StatefulWidget {
  Tokens({Key key}) : super(key: key);

  @override
  _TokensState createState() => _TokensState();
}

class _TokensState extends State<Tokens> {
  List<Token> tokens = [];
  List<AppOTP> tokenStrings = [];
  Firestore db;
  FirebaseUser user;

  @override
  void initState() {
    initTokens();
    super.initState();
  }

  void initTokens() {
    getTokens();
  }

  void getTokens() async {
    //
    db = Firestore.instance;
    user = await FirebaseAuth.instance.currentUser();
    var tokenDocuments = (await db
            .collection("/users")
            .document(user.uid)
            .collection("tokens")
            .getDocuments())
        .documents;

    tokens = await Future.wait(tokenDocuments.map((e) async {
      AppOTP otp = AppOTP(otpString: new StringBuffer(e["otpString"]));
      //    print("OTP : ${otp.otpString}");
//      var otpTest = (await otp.decryptedString).toString();
      var decryptedTest = await otp.decryptedString;
      //return Token();
      return Token.createFromOTPString(otpString: await otp.decryptedString,documentID: e.documentID);
    }));

    setState(() {
      tokens = tokens;
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
            deleteToken: this.deleteToken, index: index, token: tokens[index]);
      },
    );
  }

  void deleteToken(int index) async {
    print("Deleting${tokens[index].documentID}");
    await db.collection("/users").document(user.uid).collection("tokens").document(tokens[index].documentID).delete();
    refresh();
  }

  Future<void> addToken(AppOTP token) async {
    Token.createFromOTPString(otpString: await token.decryptedString);
    try {
      db.collection("/users").document(user.uid).collection("tokens").add(
            token.toMap(),
          );
      Token tokenToAdd = Token.createFromOTPString(
        otpString: await token.decryptedString,
      );
      refresh();
    } catch (e) {
      print("Error while adding : $e");
    }
  }

  Future<void> refresh() async {
    var tokenDocuments = (await db
            .collection("/users")
            .document(user.uid)
            .collection("tokens")
            .getDocuments())
        .documents;

    tokens = await Future.wait(tokenDocuments.map((e) async {
      AppOTP otp = AppOTP(otpString: new StringBuffer(e["otpString"]));
      //    print("OTP : ${otp.otpString}");
//      var otpTest = (await otp.decryptedString).toString();
      var decryptedTest = await otp.decryptedString;
      //return Token();
      return Token.createFromOTPString(otpString: await otp.decryptedString);
    }));

    setState(() {
      tokens = tokens;
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
