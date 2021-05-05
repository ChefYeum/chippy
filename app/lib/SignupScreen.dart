import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chippy'),
      ),
      body: Center(
          child: Column(
        children: [
          Text("Sign up to Chippy"),
          TextField(),
          TextField(),
          ElevatedButton(
            child: Text('Register'),
            onPressed: () {}, // TODO: add signup
          )
        ],
      )),
    );
  }
}
