// import 'dart:convert';
//
// import 'package:unis_project/models/url.dart';
// import 'package:http/http.dart' as http;
//
// class StudyMakeDto {
//   String roomName; // 스터디 이름
//   String? code; // 비밀번호(공개방이면 null 값)
//   String course; // 과목
//   int maxNum; // 최대인원
//   String studyIntroduction; // 소개
//   String leader; // 그룹장
//   String startDate; // 시작일
//   bool isOpen; // 공개 여부
//
//   StudyMakeDto({
//   required this.roomName,
//   this.code,
//   required this.course,
//   required this.maxNum,
//   required this.studyIntroduction,
//   required this.leader,
//   required this.startDate,
//   required this.isOpen,
//   });
//
//   StudyMakeDto.defaultValues()
//       : roomName = '다트 프로그래밍 스터디',
//         code = '1234',
//         course = '모바일 앱 개발',
//         maxNum = 5,
//         studyIntroduction = '다트 언어 스터디 모집',
//         leader = 'abc',
//         startDate = '2023-11-15',
//         isOpen = true;
//
//   factory StudyMakeDto.fromJson(Map<String, dynamic> json) {
//     return StudyMakeDto(
//       roomName: json['roomName'],
//       code: json['code'],
//       course: json['course'],
//       maxNum: json['maxNum'],
//       studyIntroduction: json['studyIntroduction'],
//       leader: json['leader'],
//       startDate: json['startDate'],
//       isOpen: json['isOpen'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'roomName': roomName,
//       'code': code,
//       'course': course,
//       'maxNum': maxNum,
//       'studyIntroduction': studyIntroduction,
//       'leader': leader,
//       'startDate': startDate,
//       'isOpen': isOpen,
//     };
//   }
// }
//
//
//
// class StudyMakeModel {
//   static Future<bool> makeStudyRoom(StudyMakeDto info) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$BASE_URL/study/make'),
//
//         body: jsonEncode(info.toJson()), // StudyMakeDto 객체를 JSON 문자열로 변환하여 요청 본문에 추가
//       );
//
//       if (response.statusCode == 200) {
//         final String result = response.body;
//         return result == 'ok'; // API에서 'ok'을 리턴하면 스터디 생성 성공
//
//       } else if (response.statusCode == 400) {
//         final String result = response.body;
//         return result == 'false'; // API에서 'false'를 리턴하면 중복된 방 이름이 있는 경우
//
//       } else {
//         throw Exception('Failed to make study: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to make study: $e');
//     }
//   }
// }
//
//
//
//
//
//
