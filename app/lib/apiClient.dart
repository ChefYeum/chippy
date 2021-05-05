import 'package:http/http.dart' as http;
import 'dart:convert';

Uri getUriForPath(String path) => Uri.http('localhost:8081', path);

Future<bool> createUser(String id, name, pw) async {
  final http.Response response = await http.post(
    getUriForPath('/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'id': id, 'name': name, 'password': pw}),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to sign up');
  }
}

Future<String> login(String id, pw) async {
  final http.Response response = await http.post(
    getUriForPath('/user/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'id': id, 'password': pw}),
  );
  if (response.statusCode == 200) {
    return "token goes here?";
  } else {
    throw Exception('Failed to login');
  }
}
