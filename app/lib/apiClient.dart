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
