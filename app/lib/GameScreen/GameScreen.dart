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
  int _potTotal = 0;
  int _chipToCall = 0;
  String playerToken;

  var playerStates = [
    PlayerState(username: 'chefyeum'),
    PlayerState(username: 'player1'),
    PlayerState(username: 'player2'),
  ];

  void _incrChipToCall(int n) {
    setState(() => _chipToCall += n);
  }

  @override
  Widget build(BuildContext context) {
    playerToken = ModalRoute.of(context).settings.arguments;
    var board = Row(children: [
      Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 1; i < playerStates.length; i += 2)
                  playerStates[i].getPlayerRepr()
              ])),
      Expanded(
          child: Column(children: [
        Expanded(flex: 1, child: Center(child: Text("$_potTotal"))),
        Expanded(flex: 1, child: Center(child: Text("$_chipToCall"))),
      ])),
      Expanded(
        flex: 1,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 2; i < playerStates.length; i += 2)
                playerStates[i].getPlayerRepr()
            ]),
      ),
    ]);

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0), // 20.0?
            child: Scaffold(
              body: Column(children: [
                Expanded(
                    child: DragTarget<PokerChip>(
                        builder: (
                          BuildContext context,
                          List<dynamic> accepted,
                          List<dynamic> rejected,
                        ) {
                          return Container(color: Colors.green, child: board);
                        },
                        onWillAccept: (_) => true,
                        onAccept: (chip) => _incrChipToCall(chip.chipValue)),
                    flex: 6),
                Expanded(
                    child: Container(color: Colors.brown, child: ChipBar()))
              ]),

              floatingActionButton: FloatingActionButton(
                onPressed: _callChips,
                // tooltip: 'Call chips',
                child: Icon(Icons.send),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }

  void _callChips() {
    // if (_controller.text.isNotEmpty) {
    //   widget.channel.sink.add(_controller.text);
    // }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
