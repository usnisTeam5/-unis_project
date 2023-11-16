import 'dart:convert';

import 'package:unis_project/models/url.dart';
import 'package:http/http.dart' as http;

///  이것은 내 스터디에서 필요한 정보입니다!
///

class MyStudyInfo { // 스터디 탭 클릭 시 받아오는 정보를 가공해서 유저한테 보여줄 정보. = DTO
  final int roomKey; // 스터디방 고유키
  String roomName; // 스터디 제목
  final String course; // 과목명
  int maxNum; // 최대인원수
  int curNum; // 현재인원수
  final String startDate; // 스터디 생성일, 2023-11-11 형태로 DB에 저장함. 스터디 생성할 때 DateTime 을 파싱해서 보냄.
  final String studyIntroduction; // 스터디 소개

  MyStudyInfo({
    required this.roomKey,
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.curNum,
    required this.startDate,
    required this.studyIntroduction,
  });

  // 이름 있는 생성자를 사용하여 기본값을 설정합니다.
  MyStudyInfo.defaultValues()
      : roomKey = -1,
        roomName = 'Intro to Dart Programming',
        course = 'Computer Science',
        maxNum = 5,
        curNum = 5,
        startDate = '2023-11-11',
        studyIntroduction = 'This is a beginner-friendly study group for Dart programming.';

  factory MyStudyInfo.fromJson(Map<String, dynamic> json) {
    return MyStudyInfo(
      roomKey: json['roomKey'],
      roomName: json['roomName'],
      course: json['course'],
      maxNum: json['maxNum'],
      curNum: json['curNum'],
      startDate: json['startDate'],
      studyIntroduction: json['studyIntroduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomKey': roomKey,
      'roomName': roomName,
      'course': course,
      'maxNum': maxNum,
      'num': curNum,
      'startDate': startDate,
      'studyIntroduction': studyIntroduction,
    };
  }
}

class MyStudyInfoModel {

  static Future<List<MyStudyInfo>> getMyStudyRoomList(String nickname) async { // 내 스터디 목록에 들어갔을 때
    final response = await http.get(
      Uri.parse('$BASE_URL/user/study?nickname=$nickname'),);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<MyStudyInfo> MyStudyInfoList =
      data.map((item) => MyStudyInfo.fromJson(item)).toList();
      return MyStudyInfoList;
    } else {
      throw Exception('Failed to load my study info ${response.body}');
    }
  }


}

