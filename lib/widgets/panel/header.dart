import 'package:flutter/material.dart';
import 'package:totp_app/widgets/panel/header_items/header_bar.dart';
import 'package:totp_app/widgets/panel/header_items/header_status.dart';
import 'package:totp_app/widgets/panel/header_items/search_bar.dart';

class PanelHeader extends StatelessWidget {
  final String title;
  final String tag;
  PanelHeader({this.title, this.tag});
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Headerbar(title: this.title),
                (this.tag == "OTP") ? Searchbar() : Container(),
                SizedBox(
                  height: 8,
                ),
                HeaderStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}