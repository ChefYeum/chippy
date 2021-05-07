import 'package:flutter/material.dart';

class PlayerState {
  String displayedName, uuid;
  int chipCount = 0;

  PlayerState(
      {@required this.uuid,
      @required this.displayedName,
      @required this.chipCount});

  void addChip(int chipIncr) {
    chipCount += chipIncr;
  }
}
