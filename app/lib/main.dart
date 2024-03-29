import 'package:chippy/GameScreen/GameScreen.dart';
import 'package:chippy/LoginScreen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'GameScreen/GameScreen.dart';
import 'SignupScreen.dart';

void main() => runApp(MyApp());

const WEBSOCKET_URL = 'ws://59.11.190.155:9002';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/game': (_) => GameScreen(
              channel: IOWebSocketChannel.connect(WEBSOCKET_URL),
            )
      },
    );
  }
}
