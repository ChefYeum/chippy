import 'package:flutter/material.dart';

class PlayerRepr extends StatelessWidget {
  final playerChipCount, playerDisplayedName;
  PlayerRepr({this.playerDisplayedName, this.playerChipCount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(this.playerDisplayedName),
      Center(
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
                Text("🪙 ${this.playerChipCount}"),
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
      )
    ]);
  }
}

class PlayerState {
  String username, displayedName;
  int chipCount = 0;

  PlayerState(
      {@required this.username,
      @required this.displayedName,
      @required this.chipCount});

  PlayerRepr getPlayerRepr() {
    return PlayerRepr(
        playerDisplayedName: this.displayedName,
        playerChipCount: this.chipCount);
  }
}
