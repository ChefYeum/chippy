import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> createUser(String id, name, pw) async {
  final http.Response response = await http.post(
    Uri.http('localhost:8081', '/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'id': id, 'name': name, 'password': pw}),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to load album');
  }
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var signupRes;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    "id": TextEditingController(),
    "name": TextEditingController(),
    "pw": TextEditingController()
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var status = FutureBuilder<String>(
        future: signupRes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        });

    var child = Scaffold(
      appBar: AppBar(
        title: Text('Chippy'),
      ),
      body: Center(
          child: Column(
        children: [
          Text("Sign up to Chippy"),
          TextField(
            controller: _controllers["name"],
          ),
          TextField(
            controller: _controllers["id"],
          ),
          TextField(
            controller: _controllers["pw"],
          ),
          ElevatedButton(
            child: Text('Register'),
            onPressed: () {
              signupRes = createUser(_controllers["id"].text,
                  _controllers["name"].text, _controllers["pw"].text);

              // Error handling:
              // if (response.statusCode == 201) {
              // } else {
              //   throw Exception('Failed to create album.');
              // }
            },
          ),
          status
        ],
      )),
    );

    return Form(key: _formKey, child: child);
  }
}
