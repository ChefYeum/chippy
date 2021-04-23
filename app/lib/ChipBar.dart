import 'package:flutter/material.dart';

class ChipBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chip = Chip();
    return Row(
        children: List.generate(
            4,
            (_) => Draggable<Chip>(
                  child: chip,
                  feedback: chip,
                  childWhenDragging: chip,
                )));
  }
}

class Chip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // TODO: Make chip size responsive
        height: 60,
        width: 60,
        child: Image.asset('lib/assets/chip.png'));
  }
}
