import 'package:chippy/apiClient.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loginRes;
  final Map<String, TextEditingController> _controllers = {
    "id": TextEditingController(),
    "pw": TextEditingController()
  };

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
          TextField(
            controller: _controllers["id"],
          ),
          TextField(
            controller: _controllers["pw"],
          ),
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
          ElevatedButton(
            child: Text('Login'),
            onPressed: () async {
              loginRes =
                  login(_controllers["id"].text, _controllers["pw"].text);
              var token = await loginRes;

              Navigator.pushNamed(context, '/game', arguments: token);
            },
          ),
          ElevatedButton(
            child: Text('Dev Login'),
            onPressed: () async {
              loginRes = login("admin", "admin");
              var token = await loginRes;

              Navigator.pushNamed(context, '/game', arguments: token);
            },
          ),
          FutureBuilder<String>(
              future: loginRes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      )),
    );
  }
}
