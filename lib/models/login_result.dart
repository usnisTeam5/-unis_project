import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResult {
  String msg;
  int userKey;
  String userNickName;

  LoginResult({
    required this.msg,
    required this.userKey,
    required this.userNickName,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      msg: json['msg'],
      userKey: json['userKey'],
      userNickName: json['userNickName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'userKey': userKey,
      'userNickName': userNickName,
    };
  }

  static Future<LoginResult?> login(String email, String password) async {
    final url = Uri.parse('http://3.35.21.123:8080/user/login');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      final responseData = jsonDecode(response.body);
      return LoginResult.fromJson(responseData);
    } else {
      // 로그인 실패
      return null;
    }
  }
}
