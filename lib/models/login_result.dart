import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResult {
  String msg;
  String userNickName;

  LoginResult({
    required this.msg,
    required this.userNickName,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      msg: json['msg'],
      userNickName: json['userNickName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'userNickName': userNickName,
    };
  }
}

class LoginService {
  static const BASE_URL = 'http://3.35.21.123:8080'; // 상수로 URL 관리

  static Future<LoginResult?> login(String email, String password) async {
    final url = Uri.parse('$BASE_URL/user/login');
    try {
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
        final responseData = jsonDecode(response.body);
        return LoginResult.fromJson(responseData);
      } else {
        // 추가적인 오류 처리
      }
    } catch (error) {
      // 네트워크 호출 중 발생한 예외 처리
    }
    return null;
  }
}