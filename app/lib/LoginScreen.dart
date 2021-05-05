import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chippy'),
      ),
      body: Center(
          child: Column(
        children: [
          Text("Chippy"),
          TextField(),
          TextField(),
          ElevatedButton(
            child: Text('Login'),
            onPressed: () {
              Navigator.pushNamed(context, '/game'); //TODO: add auth
            },
          ),
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
          )
        ],
      )),
    );
  }
}
