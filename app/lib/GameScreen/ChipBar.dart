import 'package:flutter/material.dart';

class ChipBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var v in [25, 100, 500, 1000]) PokerChip(chipValue: v)
        ]
            .map((chip) => Draggable<PokerChip>(
                  data: chip,
                  child: chip,
                  feedback: chip,
                ))
            .toList());
  }
}

class PokerChip extends StatelessWidget {
  final int chipValue;
  PokerChip({this.chipValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 90,
            width: 90,
            child: Image.asset('lib/assets/chip$chipValue.png')),
        Text("$chipValue",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
      alignment: Alignment.center,
    );
  }
}
