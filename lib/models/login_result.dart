import 'package:http/http.dart' as http;
import 'dart:convert';
 // 필요한 정보(뱐수)
// 백엔드 통시 관련 메소드
// fromJson
// toJson()

class LoginResult {
  String _msg; // 오류 메시지 잘받으면 ok, 아니면 error
  String _userNickName; // 유저 닉네임을 반환한다.

  // 생성자에서 public 네임드 파라미터를 사용하고 private 변수에 할당
  LoginResult({ // 로그인 결과
    required String msg,
    required String userNickName,
  })  : _msg = msg,
        _userNickName = userNickName;

  String get msg => _msg;
  String get userNickName => _userNickName;

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

//

class LoginService { // 로그인 백 프론트 연동
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