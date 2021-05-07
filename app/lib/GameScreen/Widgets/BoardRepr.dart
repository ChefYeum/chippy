import 'package:flutter/material.dart';

import 'PlayerRepr.dart';

class BoardRepr extends StatelessWidget {
  final playerStateMap, playerIDs, pot;
  BoardRepr(
      {@required this.playerStateMap,
      @required this.playerIDs,
      @required this.pot});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < playerIDs.length; i += 2)
                  PlayerRepr(playerState: playerStateMap[playerIDs[i]])
              ])),
      Expanded(
          child: Column(children: [
        Expanded(flex: 1, child: Center(child: this.pot)),
      ])),
      Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 1; i < playerIDs.length; i += 2)
                  PlayerRepr(playerState: playerStateMap[playerIDs[i]])
              ])),
    ]);
  }
}
