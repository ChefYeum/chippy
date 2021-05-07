import 'package:chippy/GameScreen/ChipBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'PlayerState.dart';
import 'WebSocketSignal.dart';
import 'Widgets/BoardRepr.dart';

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
      displayedName: 'ChefYeum',
      chipCount: 5020); // TODO: update it from route argument

  var playerUUIDs = [];
  var playerStateMap = {};

  void _incrChipToCall(int n) {
    if (myState.chipCount >= n) {
      setState(() {
        myState.chipCount -= n;
        _chipToCall += n;
      });
    }
  }

  void _callChips() {
    // if (_controller.text.isNotEmpty) {
    //   widget.channel.sink.add(_controller.text);
    // }

    // TODO: remove after testing
  }

  // Called when victory claimed
  void _resetPot() {
    setState(() {
      myState.chipCount += _chipToCall;
      _chipToCall = 0;
      _potChipCount = 0;
    });
  }

  // Called when a new player joins
  void _addPlayer(String uuid, displayedName, chipCount) {
    setState(() {
      playerUUIDs.add(uuid);
      playerStateMap[uuid] =
          PlayerState(displayedName: displayedName, chipCount: chipCount);
    });
  }

  void _victoryClaimed() {}

  void _victoryApproved() {}

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playerToken = ModalRoute.of(context).settings.arguments;
    widget.channel.sink.add('join|$playerToken');

    var pot = Text("$_potChipCount");
    var board = BoardRepr(
        playerStateMap: playerStateMap, playerIDs: playerUUIDs, pot: pot);

    var debugTools = Row(children: [
      TextButton(
          onPressed: () => _addPlayer(
              "uuid${playerUUIDs.length}", "Player${playerUUIDs.length}", 5000),
          child: Text("Add Player"))
    ]);
    var screen = Scaffold(
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
        debugTools,
        Expanded(child: Container(color: Color(0xff243010), child: ChipBar()))
      ]),
    );
    return StreamBuilder(
      stream: widget.channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WebSocketSignal(snapshot.data);
        }
        return screen;
      },
    );
  }
}
