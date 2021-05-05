import 'package:flutter/material.dart';

class PlayerRepr extends StatelessWidget {
  final playerChipCount, playerUsername;
  PlayerRepr({this.playerUsername, this.playerChipCount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(this.playerUsername),
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
                Text(this.playerChipCount.toString()),
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
  String username;
  int chipCount = 0;

  PlayerState({@required this.username});

  void incrChipCount(int n) {
    this.chipCount += n;
  }

  PlayerRepr getPlayerRepr() {
    return PlayerRepr(
        playerUsername: this.username, playerChipCount: this.chipCount);
  }
}
