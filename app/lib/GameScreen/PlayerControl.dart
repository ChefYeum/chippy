import 'package:flutter/material.dart';

import 'ChipBar.dart';

class PlayerControl extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerControl> {
  int _chipToCall = 0;

  void _incr(int chipIncr) {
    setState(() {
      _chipToCall += chipIncr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DragTarget<PokerChip>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 50.0,
              width: 50.0,
              color: Colors.cyan,
            );
          },
          onWillAccept: (_) => true,
          onAccept: (_) => _incr(50)),
      Text('$_chipToCall'),
      ChipBar()
    ]);
  }
}
