import 'url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class UserProfileInfoForShow {
  final String nickname;
  final List<String> departments;
  final String introduction;
  final String profileImage;
  final bool isPick;
  final bool isFriend;
  final bool isBlock;
  final int question;
  final int answer;
  final int studyCnt;

  UserProfileInfoForShow({
    required this.nickname,
    required this.departments,
    required this.introduction,
    required this.profileImage,
    required this.isPick,
    required this.isFriend,
    required this.isBlock,
    required this.question,
    required this.answer,
    required this.studyCnt,
  });

  factory UserProfileInfoForShow.fromJson(Map<String, dynamic> json) {
    // departments를 리스트로 변환
    final departmentsList = (json['departments'] as List).cast<String>();

    return UserProfileInfoForShow(
      nickname: json['nickname'] as String,
      departments: departmentsList,
      introduction: json['introduction'] as String,
      profileImage: json['profileImage'] as String,
      isPick: json['isPick'] as bool,
      isFriend: json['isFriend'] as bool,
      isBlock: json['isBlock'] as bool,
      question: json['question'] as int,
      answer: json['answer'] as int,
      studyCnt: json['studyCnt'] as int,
    );
  }

  static Future<UserProfileInfoForShow?> fetchUserProfile(String nickname, String friendNickname) async {
    try {
      String baseUrl = "http://3.35.21.123:8080";
      String endpoint = "/user/profile/forShow?nickname=$nickname&friendNickname=$friendNickname";
      String fullUrl = baseUrl + endpoint;

      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return UserProfileInfoForShow.fromJson(jsonResponse);
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('fetchUserProfile error: $e');
      return null;
    }
  }


  static Future<String> setPick(String nickname, String otherNickname) async {
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setPick/$nickname');
    final response = await http.post(
      url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set pick');
    }
  }

  static Future<String> setFriend(String nickname, String otherNickname) async {
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setFriend/$nickname');
    final response = await http.post(
      url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set friend');
    }
  }

  static Future<String> setBlock(String nickname, String otherNickname) async {
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setBlock/$nickname');
    final response = await http.post(
      url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set block');
    }
  }

}
