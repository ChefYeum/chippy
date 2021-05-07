import 'package:chippy/GameScreen/ChipBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'PlayerState.dart';
import 'WebSocketClient.dart';
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

  String _myToken;
  PlayerState myState;
  List<String> playerUUIDs = [];
  Map<String, PlayerState> playerStateMap = {};

  WebSocketClient wsClient;

  @override
  initState() {
    super.initState();

    // Workaround to access arguments
    Future.delayed(Duration.zero, () {
      setState(() {
        _myToken = ModalRoute.of(context).settings.arguments;
        wsClient = WebSocketClient(widget.channel, _myToken);
      });
    });

    // TODO: update it from route argument
    myState = PlayerState(displayedName: 'ChefYeum', chipCount: 5020);
  }

  void _incrChipToCall(int n) {
    if (myState.chipCount >= n) {
      setState(() {
        myState.chipCount -= n;
        _chipToCall += n;
      });
    }
  }

  void _callChips() {}

  // Called when a new player joins
  void _addPlayer(String uuid, displayedName, chipCount) {
    setState(() {
      playerUUIDs.add(uuid);
      playerStateMap[uuid] =
          PlayerState(displayedName: displayedName, chipCount: chipCount);
    });
  }

  void _claimVictory() {}

  // Popup to ask player for victory approval
  // Close popup if approved by another player (or majority voting?)
  Future<void> _victoryClaimedBy(String claimingPlayerUUID) {
    var claimingPlayerDisplayedName =
        playerStateMap[claimingPlayerUUID].displayedName;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Victory Claimed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '$claimingPlayerDisplayedName has claimed victory to win the pot of $_potChipCount.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Deny'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _victoryApproved(String winningPlayerUUID) {
    setState(() {
      // Reset chip-to-call
      myState.chipCount += _chipToCall;
      _chipToCall = 0;

      // Add the pot amount to winning player and reset
      this.playerStateMap[winningPlayerUUID].addChip(_potChipCount);
      _potChipCount = 0;
    });
  }

  @override
  void dispose() {
    wsClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pot = Text("$_potChipCount");
    var board = BoardRepr(
        playerStateMap: playerStateMap, playerIDs: playerUUIDs, pot: pot);

    var debugTools = Row(children: [
      TextButton(
          onPressed: () => _addPlayer(
              "uuid${playerUUIDs.length}", "Player${playerUUIDs.length}", 5000),
          child: Text("Add Player")),
      TextButton(
          // TODO: assumes there is at least one player
          onPressed: () => _victoryClaimedBy(playerUUIDs[0]),
          child: Text("Test")),
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
      stream: wsClient.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data) {
            case "Hi. I'm Chippy. Who are you?":
              wsClient.join();
              break;
            default:
          }
        }
        return screen;
      },
    );
  }
}
