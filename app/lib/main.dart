import 'package:chippy/LoginScreen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'ChatScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/game': (_) => ChatScreen(
              channel: IOWebSocketChannel.connect('ws://59.11.190.155:9002'),
            )
      },
    );
  }
}
