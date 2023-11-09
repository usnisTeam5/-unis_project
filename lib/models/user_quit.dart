import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart';
class UserQuit {
  final String nickname;
  final int point;

  UserQuit({
    required this.nickname,
    required this.point,
  });

  factory UserQuit.fromJson(Map<String, dynamic> json) {
    return UserQuit(
      nickname: json['nickname'],
      point: json['point'],
    );
  }

  // 포인트 정보를 가져오는 API 호출
  static Future<UserQuit> fetchPointInfo(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/point?nickname=$nickname');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserQuit.fromJson(data);
    } else {
      throw Exception('Failed to load point information');
    }
  }

  // 회원 탈퇴 API 호출
  static Future<void> userQuit(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/quit?nickname=$nickname');
    final response = await http.post(
      url,
    );

    if (response.statusCode == 200) {
      // 회원 탈퇴 성공 시 작업 수행
    } else {
      throw Exception('Failed to quit user');
    }
  }
}
