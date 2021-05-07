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
          child: Container(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chippy"),
                  TextField(
                    controller: _controllers["id"],
                  ),
                  TextField(
                    controller: _controllers["pw"],
                    obscureText: true,
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
                      loginRes = login(
                          _controllers["id"].text, _controllers["pw"].text);
                      var token = await loginRes;

                      if (token == null) {
                        return showDialog<void>(
                            context: context,
                            barrierDismissible:
                                false, // user must tap a button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Unable to Login'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("Please try again."),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ],
                              );
                            });
                      } else {
                        Navigator.pushNamed(context, '/game', arguments: token);
                      }
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
                ],
              ))),
    );
  }
}
