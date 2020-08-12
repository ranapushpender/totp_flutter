import "package:flutter/material.dart";

class Searchbar extends StatefulWidget {
  final searchFunction;

  Searchbar({this.searchFunction});

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextField(
          onChanged: widget.searchFunction,
          controller: this.searchController,
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
    );
  }
}
