import 'package:flutter/material.dart';
import 'apiClient.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var signupRes;
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
    return Scaffold(
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
            },
          ),
          FutureBuilder<bool>(
              future: signupRes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data ? "yee" : "nay");
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
