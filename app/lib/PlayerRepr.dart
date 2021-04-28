import 'package:flutter/material.dart';

class PlayerRepr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("SomePlayerName"), circle]);
  }
}

var circle = Center(
  child: Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    width: 90,
    height: 45,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("5020"),
        ],
      ),
    ),
    decoration: BoxDecoration(
      border: Border.all(width: 3),
      borderRadius: BorderRadius.all(
        Radius.circular(200),
      ),
      color: Colors.yellow,
    ),
  ),
);
