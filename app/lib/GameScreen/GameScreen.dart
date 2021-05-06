import 'package:chippy/GameScreen/ChipBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'PlayerRepr.dart';

class GameScreen extends StatefulWidget {
  final WebSocketChannel channel;

  GameScreen({Key key, @required this.channel}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _potChipCount = 0;
  int _chipToCall = 0;
  String playerToken;

  var myState = PlayerState(
      username: 'chefyeum',
      displayedName: 'ChefYeum',
      chipCount: 5020); // TODO: update it from route argument

  var otherPlayerStates = [
    PlayerState(
        username: 'player1', displayedName: 'player1name', chipCount: 5000),
    PlayerState(
        username: 'player2', displayedName: 'player2name', chipCount: 5000),
  ];

  void _incrChipToCall(int n) {
    if (myState.chipCount >= n) {
      setState(() {
        myState.chipCount -= n;
        _chipToCall += n;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var pot = Text("$_potChipCount");
    playerToken = ModalRoute.of(context).settings.arguments;
    var board = Row(children: [
      Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < otherPlayerStates.length; i += 2)
                  otherPlayerStates[i].getPlayerRepr()
              ])),
      Expanded(
          child: Column(children: [
        Expanded(flex: 1, child: Center(child: pot)),
      ])),
      Expanded(
        flex: 1,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (var i = 1; i < otherPlayerStates.length; i += 2)
            otherPlayerStates[i].getPlayerRepr()
        ]),
      ),
    ]);

    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                DragTarget<PokerChip>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Container(color: Color(0xff87A330), child: board);
                    },
                    onWillAccept: (_) => true,
                    onAccept: (chip) => _incrChipToCall(chip.chipValue)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("🪙 ${myState.chipCount}"),
                    TextButton(
                      child: Text("Call $_chipToCall",
                          style: TextStyle(fontSize: 24)),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: _callChips,
                    )
                  ],
                )
              ],
            ),
            flex: 6),
        Expanded(child: Container(color: Color(0xff243010), child: ChipBar()))
      ]),
    );
  }

  void _callChips() {
    // if (_controller.text.isNotEmpty) {
    //   widget.channel.sink.add(_controller.text);
    // }
  }

  // Called when victory claimed
  void _resetPot() {
    myState.chipCount += _chipToCall;
    _chipToCall = 0;
    _potChipCount = 0;
  }

  // Called when a new player joins
  void _addPlayer() {}

  void _victoryClaimed() {}

  void _victoryApproved() {}

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
