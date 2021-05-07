import 'package:http/http.dart' as http;
import 'dart:convert';

const String HOST = '59.11.190.155:8081';
// const String HOST = 'localhost:8081';

Uri getUriForPath(String path) => Uri.http(HOST, path);

const POST_DEFAULT_HEADERS = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

Future<String> createUser(String id, name, pw) async {
  try {
    final http.Response response = await http.post(
      getUriForPath('/user'),
      headers: POST_DEFAULT_HEADERS,
      body:
          jsonEncode(<String, String>{'id': id, 'name': name, 'password': pw}),
    );
    if (response.statusCode == 200) {
      var resData = await jsonDecode(response.body)["data"];
      return resData["token"];
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

Future<String> login(String id, pw) async {
  try {
    final http.Response response = await http.post(
      getUriForPath('/user/login'),
      headers: POST_DEFAULT_HEADERS,
      body: jsonEncode(<String, String>{'id': id, 'password': pw}),
    );
    if (response.statusCode == 200) {
      var resData = await jsonDecode(response.body)["data"];
      return resData["token"];
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}
