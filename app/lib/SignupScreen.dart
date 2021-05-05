import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class SignupInfo {
//   final String username, password;
//   SignupInfo({@required this.username, @required this.password});
// }

Future<String> fetchString() async {
  final response = await http.get(Uri.http('localhost:8081', '/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to request');
  }
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Future<String> futureStr;

  @override
  void initState() {
    super.initState();
    futureStr = fetchString();
  }

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
          FutureBuilder<String>(
              future: futureStr,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              }),
          ElevatedButton(
            child: Text('Register'),
            onPressed: () {}, // TODO: add signup
          )
        ],
      )),
    );
  }
}
