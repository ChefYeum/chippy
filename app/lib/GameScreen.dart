import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'ChipBar.dart';
import 'PlayerRepr.dart';

var layoutDev = Scaffold(
    body: Column(children: [
  Expanded(child: Container(color: Colors.green, child: playerBoard), flex: 6),
  Expanded(child: Container(color: Colors.brown, child: ChipBar()))
]));

var playerBoard = Row(children: [
  Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [PlayerRepr(), PlayerRepr()],
      )),
  Expanded(flex: 1, child: SizedBox(width: 50)),
  Expanded(
    flex: 1,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [PlayerRepr(), PlayerRepr()],
    ),
  )
]);

class GameScreen extends StatefulWidget {
  final WebSocketChannel channel;

  GameScreen({Key key, @required this.channel}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(0), // 20.0?
          child:
              layoutDev // For layout development - Adopt StreamBuilder as below
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
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
