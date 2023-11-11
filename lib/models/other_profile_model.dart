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
  // 만족도가 없음

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
    // 이미지 처리 base64 string으로 받아서 임시 파일에 profile_image.png로 저장 후 경로 반환.

    Future<File?> getImageFile(String profileImage) async {
      try {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/profile_image.png');
        return file;
      } catch (error) {
        print('Error while getting image file: $error');
        return null;
      }
    }


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

  Map<String, dynamic> toJson() {
    // 통신할 떄 필요
    return {
      'nickname': nickname,
      'departments': departments,
      'introduction': introduction,
      'profileImage': profileImage,
      'isPick': isPick,
      'isFriend': isFriend,
      'isBlock': isBlock,
      'answer': answer,
      'question': question,
      'studyCnt': studyCnt,
    };
  }

  static Future<UserProfileInfoForShow?> fetchUserProfile(String nickname) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/profile/forShow?nickname=$nickname&friendNickname=$nickname'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));

        return UserProfileInfoForShow.fromJson(data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (error) {
      // 네트워크 호출 중 발생한 예외 처리
      print("fetchUserProfile error: $error");
      return null;
    }
  }


  static Future<String> setPick(String nickname, String otherNickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/setPick/$nickname');
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
    final url = Uri.parse('$BASE_URL/user/profile/setFriend/$nickname');
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
    final url = Uri.parse('$BASE_URL/user/profile/setBlock/$nickname');
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

  /*
  static Future<List<Msg>> getAllMsg(String nickname1, String nickname2) async {
    final url = Uri.parse('$BASE_URL/chat?nickname1=$nickname1&nickname2=$nickname2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((msgData) => Msg.fromJson(msgData)).toList();
    } else {
      throw Exception('Failed to get messages');
    }
  }

  static Future<String> sendMsg(SendMsg sendMsg) async {
    final url = Uri.parse('$BASE_URL/chat/send');
    final response = await http.post(
      url,
      body: json.encode(sendMsg.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to send message');
    }
  }

  static Future<List<Msg>> getMsg(String nickname1, String nickname2) async {
    final url = Uri.parse('$BASE_URL/chat/receive?nickname1=$nickname1&nickname2=$nickname2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((msgData) => Msg.fromJson(msgData)).toList();
    } else {
      throw Exception('Failed to receive messages');
    }
  }
  */
}
