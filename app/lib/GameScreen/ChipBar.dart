import 'package:flutter/material.dart';

class ChipBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chip = PokerChip();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            4,
            (_) => Draggable<PokerChip>(
                  data: chip,
                  child: chip,
                  feedback: chip,
                )));
  }
}

class PokerChip extends StatelessWidget {
  final int chipValue;
  PokerChip({this.chipValue});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90, width: 90, child: Image.asset('lib/assets/chip.png'));
  }
}
