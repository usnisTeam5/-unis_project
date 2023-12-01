import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/url.dart'; // BASE_URL을 포함하는 파일을 임포트

class UserService {
  // 친구 목록 가져오기
  Future<List<UserInfoMinimumDto>> getFriends(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/friend?nickname=$nickname');

    final response = await http.get(url);

    print("친구 목록: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => UserInfoMinimumDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load friend list');
    }
  }

  // 차단 목록 가져오기
  Future<List<UserInfoMinimumDto>> getBlocks(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/block?nickname=$nickname');

    final response = await http.get(url);

    print("차단 목록: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => UserInfoMinimumDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load block list');
    }
  }

  // 찜 목록 가져오기
  Future<List<UserInfoMinimumDto>> getPicks(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/pick?nickname=$nickname');

    final response = await http.get(url);

    print("찜 목록: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => UserInfoMinimumDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pick list');
    }
  }
}

class UserInfoMinimumDto {
  String nickname;
  String image; // 이미지를 base64로 인코딩한 문자열

  UserInfoMinimumDto({required this.nickname, required this.image});

  factory UserInfoMinimumDto.fromJson(Map<String, dynamic> json) {
    return UserInfoMinimumDto(
      nickname: json['nickname'],
      image: json['image'] ?? base64Encode(File('image/unis.png').readAsBytesSync()),
    );
  }
}
