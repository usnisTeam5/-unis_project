import 'package:http/http.dart' as http;
import 'dart:convert';
 // 필요한 정보(뱐수)
// 백엔드 통시 관련 메소드
// fromJson
// toJson()

class LoginResult {
  String _msg; // 오류 메시지 잘받으면 ok, 아니면 error
  String _nickname; // 유저 닉네임을 반환한다.

  // 생성자에서 public 네임드 파라미터를 사용하고 private 변수에 할당
  LoginResult({ // 로그인 결과
    required String msg,
    required String nickname,
  })  : _msg = msg,
        _nickname = nickname;

  String get msg => _msg;
  String get nickname => _nickname;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      msg: json['msg'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'nickname': nickname,
    };
  }
}

//

class LoginService { // 로그인 백 프론트 연동
  static const BASE_URL = 'http://3.35.21.123:8080'; // 상수로 URL 관리

  static Future<LoginResult?> login(String id, String password) async {
    final url = Uri.parse('$BASE_URL/user/login');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': id,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // print("Model 200이 아닙니다sdfsdfsd\n");
      if (response.statusCode == 200) {
        //print("Model 200이 아닙니다sdfsdfsd\n");
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print('Response data: $responseData');
        return LoginResult.fromJson(responseData);
      } else {
        print("Model 200이 아닙니다\n");
      }
      print("Model 200이 아닙니다sdfsdfsd2222\n");
    } catch (error) {
      print("Model error\n");
    }
    return null;
  }
}