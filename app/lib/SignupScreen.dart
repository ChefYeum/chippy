import 'package:flutter/material.dart';
import 'apiClient.dart';

class SignupScreen extends StatefulWidget {
  // @override
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
            onPressed: () async {
              signupRes = createUser(_controllers["id"].text,
                  _controllers["name"].text, _controllers["pw"].text);
              var token = await signupRes;

              if (token == null) {
                return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap a button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Unable to Sign up'),
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
                return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap a button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign Up Successful'),
                        actions: <Widget>[
                          TextButton(
                              child: Text('Join Game'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/game',
                                    arguments: token);
                              }),
                        ],
                      );
                    });
              }
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
