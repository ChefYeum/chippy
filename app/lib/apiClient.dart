import 'package:http/http.dart' as http;
import 'dart:convert';

Uri getUriForPath(String path) => Uri.http('59.11.190.155:8081', path);

const POST_DEFAULT_HEADERS = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

Future<String> createUser(String id, name, pw) async {
  final http.Response response = await http.post(
    getUriForPath('/user'),
    headers: POST_DEFAULT_HEADERS,
    body: jsonEncode(<String, String>{'id': id, 'name': name, 'password': pw}),
  );
  if (response.statusCode == 200) {
    var resData = await jsonDecode(response.body)["data"];
    return resData["token"];
  } else {
    throw Exception('Failed to sign up');
  }
}

Future<String> login(String id, pw) async {
  final http.Response response = await http.post(
    getUriForPath('/user/login'),
    headers: POST_DEFAULT_HEADERS,
    body: jsonEncode(<String, String>{'id': id, 'password': pw}),
  );
  if (response.statusCode == 200) {
    var resData = await jsonDecode(response.body)["data"];
    return resData["token"];
  } else {
    throw Exception('Failed to login');
  }
}
