import 'package:chippy/LoginScreen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'GameScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/game': (_) => GameScreen(
              title: title,
              channel: IOWebSocketChannel.connect('ws://59.11.190.155:9002'),
            )
      },
    );
  }
}
