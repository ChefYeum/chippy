import 'package:chippy/GameScreen/ChipBar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'PlayerRepr.dart';

// TODO: abstract it out as a UI widget
class GameScreen extends StatefulWidget {
  final WebSocketChannel channel;

  GameScreen({Key key, @required this.channel}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TextEditingController _controller = TextEditingController();

  int _potTotal = 0;
  int _chipToCall = 0;

  void _incrChipToCall(int n) {
    setState(() => _chipToCall += n);
  }

  @override
  Widget build(BuildContext context) {
    var board = Row(children: [
      Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PlayerRepr(playerUsername: "username1", playerChipCount: 5050),
              PlayerRepr(playerUsername: "username2", playerChipCount: 4950)
            ],
          )),
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
            PlayerRepr(playerUsername: "username3", playerChipCount: 1250),
            PlayerRepr(playerUsername: "username4", playerChipCount: 9050)
          ],
        ),
      )
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
                        onAccept: (_) => _incrChipToCall(50)),
                    flex: 6),
                Expanded(
                    child: Container(color: Colors.brown, child: ChipBar()))
              ]),

              // TODO: Adopt StreamBuilder as below
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Form(
              //       child: TextFormField(
              //         controller: _controller,
              //         decoration: InputDecoration(labelText: 'Send a message'),
              //       ),
              //     ),
              //     StreamBuilder(
              //       stream: widget.channel.stream,
              //       builder: (context, snapshot) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 24.0),
              //           child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
              //         );
              //       },
              //     )
              //   ],
              // ),
              floatingActionButton: FloatingActionButton(
                onPressed: _sendMessage,
                tooltip: 'Send message',
                child: Icon(Icons.send),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}