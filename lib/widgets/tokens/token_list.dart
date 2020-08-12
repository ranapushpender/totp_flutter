import "package:flutter/material.dart";
import 'package:totp_app/authentication/auth.dart';
import 'package:totp_app/db/Database.dart';
import "../../widgets/tokens/token_item.dart";
import "../../widgets/tokens/add_bottom_sheet.dart";
import "../../widgets/tokens/edit_bottom_sheet.dart";
import "../../models/Token.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "../../otp/otp.dart";
import "../../encryption/encryption.dart";

// ***REMOVED***
class TokenList extends StatefulWidget {
  final String searchString;
  final changeCurrentTokenAndSend;
  TokenList({Key key, this.searchString, this.changeCurrentTokenAndSend})
      : super(key: key);

  @override
  _TokenListState createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  List<Token> tokens = [];
  final database = Database();

  @override
  void initState() {
    initTokens();
    super.initState();
  }

  void initTokens() {
    getTokens();
  }

  void getTokens() async {
    (await Database().getAllTokensStream()).listen((event) async {
      var tokenDocuments = event.documents;
      var localTokens = await Future.wait(
        tokenDocuments.map(
          (e) async {
            AppOTP otp = AppOTP(otpString: new StringBuffer(e["otpString"]));
            return Token.createFromOTPString(
                otpString: await otp.decryptedString, documentID: e.documentID);
          },
        ),
      );
      setState(() {
        tokens = localTokens;
      });
    });
  }

  void addTokenTest() async {}

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
    print("Token Object Created");
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
    print("Executed ${widget.searchString}");
    final tokensToShow = (widget.searchString == null ||
            widget.searchString == "")
        ? tokens
        : tokens.where((element) {
            if (element.label
                    .toLowerCase()
                    .contains(this.widget.searchString.toLowerCase().trim()) ||
                element.issuer
                    .toLowerCase()
                    .contains(this.widget.searchString.toLowerCase().trim())) {
              return true;
            } else {
              return false;
            }
          }).toList();

    return Container(
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
                      token: tokensToShow[index - 1],
                      showEditDialog: this.showEditDialog,
                      index: index - 1,
                      changeCurrentTokenAndSend:
                          widget.changeCurrentTokenAndSend,
                    );
            },
            itemCount: tokensToShow.length + 1,
          ),
        ),
      ),
    );
  }
}
