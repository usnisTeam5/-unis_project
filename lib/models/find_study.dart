import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';

class StudyInfoDto { // 스터디 찾기 들어갔을 때 필요
  int roomKey;
  String roomName;
  String course;
  int maxNum;
  int curNum;
  String leader;
  String startDate;
  bool isOpen;
  String studyIntroduction;

  StudyInfoDto({
    required this.roomKey,
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.curNum,
    required this.leader,
    required this.startDate,
    required this.isOpen,
    required this.studyIntroduction,
  });

  factory StudyInfoDto.fromJson(Map<String, dynamic> json) {
    return StudyInfoDto(
      roomKey: json['roomKey'],
      roomName: json['roomName'],
      course: json['course'],
      maxNum: json['maxNum'],
      curNum: json['curNum'],
      leader: json['leader'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
      studyIntroduction: json['studyIntroduction'],
    );
  }
}

class RoomStatusDto { // 전체, 잔여석, 공개여부
  bool isAll;
  bool isSeatLeft;
  bool isOpen;

  RoomStatusDto({
    required this.isAll,
    required this.isSeatLeft,
    required this.isOpen,
  });
}

class StudyJoinDto { // 가입신청
  int roomKey;
  String code;

  StudyJoinDto({
    required this.roomKey,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomKey': roomKey,
      'code': code,
    };
  }
}

class StudyMakeDto { //  스터디 만들 때 넘기는 정보.
  String roomName;
  String course;
  int maxNum;
  String leader;
  String startDate;
  bool isOpen;
  String? code;
  String studyIntroduction;

  StudyMakeDto({
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.leader,
    required this.startDate,
    required this.isOpen,
    this.code,
    required this.studyIntroduction,
  });
}

class MyStudyInfoDto { // 밥
  int roomKey;
  String roomName;
  String course;
  int maxNum;
  int curNum;
  String startDate;
  String studyIntroduction;

  MyStudyInfoDto({
    required this.roomKey,
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.curNum,
    required this.startDate,
    required this.studyIntroduction,
  });

  factory MyStudyInfoDto.fromJson(Map<String, dynamic> json) {
    return MyStudyInfoDto(
      roomKey: json['roomKey'],
      roomName: json['roomName'],
      course: json['course'],
      maxNum: json['maxNum'],
      curNum: json['curNum'],
      startDate: json['startDate'],
      studyIntroduction: json['studyIntroduction'],
    );
  }
}

// API 요청 및 응답 처리 메서드
class StudyService {

  Future<List<StudyInfoDto>> getStudyRoomList( // 스터디 찾기에서 목록 얻어오기
      String nickname, RoomStatusDto roomStatus) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/study/$nickname'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      return jsonData.map((data) => StudyInfoDto.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load study rooms');
    }
  }

  Future<String> joinStudy(String nickname, StudyJoinDto joinInfo) async { // 스터디 가입
    final response = await http.post(
      Uri.parse('$BASE_URL/studyRoom/join/$nickname'),
      body: json.encode(joinInfo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to join study');
    }
  }

  Future<String> makeStudyRoom(StudyMakeDto info) async { // 스터디 생성.
    final response = await http.post(
      Uri.parse('$BASE_URL/study/make'),
      body: json.encode(info.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create study room');
    }
  }
// 다른 API들도 위와 같은 방식으로 구현
}
