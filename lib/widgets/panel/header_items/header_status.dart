import "package:flutter/material.dart";

class HeaderStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25),
    );
  }
}
