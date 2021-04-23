import 'package:flutter/material.dart';

class ChipBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chip = Chip();
    return Column(children: [
      Draggable<Chip>(
        child: chip,
        feedback: chip,
        childWhenDragging: chip,
      )
    ]);
  }

  // return Draggable<Image>(
  //   c
  // );
}

class Chip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/chip.png');
  }
}
