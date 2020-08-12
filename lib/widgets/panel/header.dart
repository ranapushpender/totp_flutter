import 'package:flutter/material.dart';
import 'package:totp_app/widgets/panel/header_items/header_bar.dart';
import 'package:totp_app/widgets/panel/header_items/header_status.dart';
import 'package:totp_app/widgets/panel/header_items/search_bar.dart';

class PanelHeader extends StatefulWidget {
  final String title;
  final String tag;
  final searchFunction;

  PanelHeader({this.title, this.tag, this.searchFunction});

  @override
  _PanelHeaderState createState() => _PanelHeaderState();
}

class _PanelHeaderState extends State<PanelHeader> {
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
                Headerbar(title: this.widget.title),
                (this.widget.tag == "OTP")
                    ? Searchbar(
                        searchFunction: widget.searchFunction,
                      )
                    : Container(),
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
