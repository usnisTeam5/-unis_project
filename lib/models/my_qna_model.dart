import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';  // BASE_URL이 정의된 파일

class QaListDto { // 리스트 가져옴
  final int qaKey;
  final String type;
  final String course;
  final String status; // 미답/ 진행/ 완료

  QaListDto({required this.qaKey, required this.type, required this.course, required this.status});

  factory QaListDto.fromJson(Map<String, dynamic> json) {
    return QaListDto(
      qaKey: json['qaKey'],
      type: json['type'],
      course: json['course'],
      status: json['status'],
    );
  }
}


class QaMsgDto { // 메세지 형식
  final String nickname;
  final String type;
  final String msg;
  final String img;
  final String time;
  final bool isAnonymity;

  QaMsgDto({required this.nickname, required this.type, required this.msg, required this.img, required this.time, required this.isAnonymity});

  factory QaMsgDto.fromJson(Map<String, dynamic> json) {
    return QaMsgDto(
      nickname: json['nickname'],
      type: json['type'],
      msg: json['msg'],
      img: json['img'],
      time: json['time'],
      isAnonymity: json['isAnonymity'],
    );
  }
}


class UserService {
  Future<List<QaListDto>> getAskList(String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/user/qa/ask?nickname=$nickname'));
    print("getAskList : ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes)); // base64 디코드.
      return jsonData.map((json) => QaListDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ask list');
    }
  }

  Future<List<QaListDto>> getAnswerList(String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/user/qa/answer?nickname=$nickname'));

    if (response.statusCode == 200) {

      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaListDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load answer list');
    }
  }

  Future<List<QaMsgDto>> getQaMessages(int qaKey) async {
    final response = await http.get(Uri.parse('$BASE_URL/user/qa?qaKey=$qaKey'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load QA messages');
    }
  }

  Future<double> getUserReview(String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/user/qa/review?nickname=$nickname'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user review');
    }
  }
}
