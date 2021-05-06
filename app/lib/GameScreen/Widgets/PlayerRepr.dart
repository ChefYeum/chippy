import 'package:flutter/material.dart';
import '../PlayerState.dart';

class PlayerRepr extends StatelessWidget {
  final PlayerState playerState;

  PlayerRepr({@required this.playerState});

  // PlayerRepr getPlayerRepr() {
  //   return PlayerRepr(
  //       playerDisplayedName: this.displayedName,
  //       playerChipCount: this.chipCount);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(this.playerState.displayedName),
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
                Text("🪙 ${playerState.chipCount}"),
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
