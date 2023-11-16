import 'dart:convert';

import 'package:unis_project/models/url.dart';
import 'package:http/http.dart' as http;

///  이것은 내 스터디에서 필요한 정보입니다!
///

class StudyInfo {
  final int roomKey; // 스터디방 고유키
  String roomName; // 스터디 제목
  final String course; // 과목명
  int maximumNum; // 최대인원수
  int curNum; // 현재인원수
  String leader; // 그룹장
  final String startDate; // 시작일
  bool isOpen; // 공개여부
  final String studyIntroduction; // 스터디 소개글

  StudyInfo({
    required this.roomKey,
    required this.roomName,
    required this.course,
    required this.maximumNum,
    required this.curNum,
    required this.leader,
    required this.startDate,
    required this.isOpen,
    required this.studyIntroduction,
  });

  // 이름 있는 생성자를 사용하여 기본값을 설정합니다.
  StudyInfo.defaultValues()
      : roomKey = 1001,
        roomName = 'Intro to Dart Programming',
        course = 'Computer Science',
        maximumNum = 10,
        curNum = 5,
        leader = 'JohnDoe',
        startDate = '2023-11-11',
        isOpen = true,
        studyIntroduction = 'This is a beginner-friendly study group for Dart programming.';
  factory StudyInfo.fromJson(Map<String, dynamic> json) {
    return StudyInfo(
      roomKey: json['roomKey'],
      roomName: json['roomName'],
      course: json['course'],
      maximumNum: json['maximumNum'],
      curNum: json['num'],
      leader: json['leader'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
      studyIntroduction: json['studyIntroduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomKey': roomKey,
      'roomName': roomName,
      'course': course,
      'maximumNum': maximumNum,
      'num': curNum,
      'leader': leader,
      'startDate': startDate,
      'isOpen': isOpen,
      'studyIntroduction': studyIntroduction,
    };
  }
}

class StudyInfoModel {

  static Future<List<StudyInfo>> getStudyRoomList(String nickname) async { // 처음 스터디 탭에 들어왔을 때
    final response = await http.get(
      Uri.parse('$BASE_URL/study/$nickname'),);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<StudyInfo> studyInfoList =
      data.map((json) => StudyInfo.fromJson(json)).toList();
      return studyInfoList;
    } else {
      throw Exception('Failed to load study info');
    }
  }


}

