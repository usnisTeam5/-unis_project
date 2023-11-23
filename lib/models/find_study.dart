import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';

class StudyInfoDto { // 스터디 찾기 들어갔을 때 필요
  int roomKey; // 스터디 고유키
  String roomName; // 스터디 제목
  String course; // 스터디 과목
  int maxNum; // 최대 인원수
  int curNum; // 현재 인원수
  String leader; // 스터디장 닉네임
  String startDate; // 시작일
  bool isOpen; // 공개 여부
  String studyIntroduction; // 스터디 소개글

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

  StudyInfoDto.defaultValues()
      : roomKey = -5,
        roomName = '다트 프로그래밍 스터디',
        course = '모바일 앱 개발',
        maxNum = 5,
        curNum = 1,
        leader = 'abc',
        startDate = '2023-11-20',
        isOpen = true,
        studyIntroduction = '다트 언어 스터디 모집';

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
  Map<String, dynamic> toJson() {
    return {
      'roomKey' : roomKey,
      'roomName': roomName,
      'course': course,
      'maxNum': maxNum,
      'curNum': curNum,
      'leader': leader,
      'startDate': startDate,
      'isOpen': isOpen,
      'studyIntroduction': studyIntroduction,
    };
  }
}

class RoomStatusDto {
  bool isAll;
  bool isSeatLeft;
  bool isOpen;

  RoomStatusDto({
    required this.isAll,
    required this.isSeatLeft,
    required this.isOpen,
  });

  factory RoomStatusDto.fromJson(Map<String, dynamic> json) {
    return RoomStatusDto(
      isAll: json['isAll'],
      isSeatLeft: json['isSeatLeft'],
      isOpen: json['isOpen'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'isAll': isAll,
      'isSeatLeft': isSeatLeft,
      'isOpen': isOpen,
    };
  }

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

class StudyMakeDto { //  스터디 생성에서 넘기는 정보.
  String roomName; // 스터디 이름
  String? code; // 비밀번호(공개방이면 null 값)
  String course; // 과목
  int maxNum; // 최대인원
  String studyIntroduction; // 소개
  String leader; // 그룹장
  String startDate; // 시작일
  bool isOpen; // 공개 여부

  StudyMakeDto({
    required this.roomName,
    this.code,
    required this.course,
    required this.maxNum,
    required this.studyIntroduction,
    required this.leader,
    required this.startDate,
    required this.isOpen,
  });

  StudyMakeDto.defaultValues()
      : roomName = '다트 프로그래밍 스터디',
        code = '1234',
        course = '모바일 앱 개발',
        maxNum = 5,
        studyIntroduction = '다트 언어 스터디 모집',
        leader = 'abc',
        startDate = '2023-11-15',
        isOpen = true;

  factory StudyMakeDto.fromJson(Map<String, dynamic> json) {
    return StudyMakeDto(
      roomName: json['roomName'],
      code: json['code'],
      course: json['course'],
      maxNum: json['maxNum'],
      studyIntroduction: json['studyIntroduction'],
      leader: json['leader'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'code': code,
      'course': course,
      'maxNum': maxNum,
      'studyIntroduction': studyIntroduction,
      'leader': leader,
      'startDate': startDate,
      'isOpen': isOpen,
    };
  }
}

// class MyStudyInfoDto {
//   int roomKey;
//   String roomName;
//   String course;
//   int maxNum;
//   int curNum;
//   String startDate;
//   String studyIntroduction;
//
//   MyStudyInfoDto({
//     required this.roomKey,
//     required this.roomName,
//     required this.course,
//     required this.maxNum,
//     required this.curNum,
//     required this.startDate,
//     required this.studyIntroduction,
//   });
//
//   factory MyStudyInfoDto.fromJson(Map<String, dynamic> json) {
//     return MyStudyInfoDto(
//       roomKey: json['roomKey'],
//       roomName: json['roomName'],
//       course: json['course'],
//       maxNum: json['maxNum'],
//       curNum: json['curNum'],
//       startDate: json['startDate'],
//       studyIntroduction: json['studyIntroduction'],
//     );
//   }
// }



// API 요청 및 응답 처리 메서드


class StudyService {

  Future<List<StudyInfoDto>> getStudyRoomList(String nickname, RoomStatusDto roomStatus) async {

    // StreamedRequest 객체를 생성하고, 메서드와 URI를 지정합니다.
    final request = http.StreamedRequest(
      'GET',
      Uri.parse('$BASE_URL/study/$nickname'),
    );

    // 필요한 헤더를 추가합니다.
    request.headers['Content-Type'] = 'application/json';

    // 요청 본문에 데이터를 추가합니다.
    request.sink.add(utf8.encode(jsonEncode(roomStatus.toJson())));
    request.sink.close();

    // 요청을 보냅니다.
    final streamedResponse = await request.send();

    // 스트림 응답을 Response 객체로 변환합니다.
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    // *********************************
    if (response.statusCode == 200) {
      final List<dynamic> studyInfoJsonList = jsonDecode(utf8.decode(response.bodyBytes));
      print("스터디 찾기 모델 $studyInfoJsonList");
      return studyInfoJsonList.map((json) => StudyInfoDto.fromJson(json)).toList();
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



  static Future<bool> makeStudyRoom(StudyMakeDto info) async { // 스터디 생성
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/study/make'),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(info.toJson()), // StudyMakeDto 객체를 JSON 문자열로 변환하여 요청 본문에 추가
      );

      if (response.statusCode == 200) {
        final String result = response.body;
        return result == 'ok'; // API에서 'ok'을 리턴하면 스터디 생성 성공

      } else if (response.statusCode == 400) {
        final String result = response.body;
        return result == 'false'; // API에서 'false'를 리턴하면 중복된 방 이름이 있는 경우

      } else {
        throw Exception('Failed to make study: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to make study: $e');
    }
  }





// 다른 API들도 위와 같은 방식으로 구현
}
