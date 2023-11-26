import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'url.dart';

class CourseAllDto {
  List<String> currentCourses;
  List<String> pastCourses;

  CourseAllDto({required this.currentCourses, required this.pastCourses});

  factory CourseAllDto.fromJson(Map<String, dynamic> json) {
    return CourseAllDto(
      currentCourses: List<String>.from(json['currentCourses']),
      pastCourses: List<String>.from(json['pastCourses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentCourses': currentCourses,
      'pastCourses': pastCourses,
    };
  }
}

// 학과 DTO
class DepartmentDto {
  List<String> depts;

  DepartmentDto({required this.depts});

  Map<String, dynamic> toJson() {
    return {
      'dept_name1': depts[0],
      'dept_name2': depts.length == 2 ? depts[1] : null,
    };
  }
}

// 과목 DTO
class CourseDto {
  List<String> courses;

  CourseDto({required this.courses});

  Map<String, dynamic> toJson() {
    return {
      'course': courses,
    };
  }
}

class UserProfileInfo {
  final String nickName;
  List<String> departments;
  String introduction;
  List<String> currentCourses;
  List<String> pastCourses;
  Uint8List profileImage;
  int point;
  int question;
  int answer;
  int studyCnt;
  double review;

  //static const BASE_URL = "http://3.35.21.123:8080";

  UserProfileInfo({
    required this.nickName,
    required this.departments,
    required this.introduction,
    required this.currentCourses,
    required this.pastCourses,
    required this.profileImage,
    required this.point,
    required this.question,
    required this.answer,
    required this.studyCnt,
    required this.review,
  });

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) {
    // json to userprofile.

    //List<String?> departmentsList = (json['departments'] as List?)?.map((item) => item as String?).toList() ?? [];

    return UserProfileInfo(
      nickName: json['nickName'],
      departments: List<String>.from(json['departments'] ?? []),
      introduction: json['introduction'] ?? '',
      currentCourses: List<String>.from(json['currentCourses'] ?? []),
      pastCourses: List<String>.from(json['pastCourses'] ?? []),
      // `profileImage` 처리는 Flutter 앱 내에서 이미지 처리 방식에 따라 달라질 수 있습니다.
      profileImage:
          json['profileImage'] ?? File('image/unis.png').readAsBytesSync(),
      // 예시로 네트워크 이미지를 사용하였습니다.
      point: json['point'],
      question: json['question'],
      answer: json['answer'],
      studyCnt: json['studyCnt'],
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    // 통신할 떄 필요
    return {
      'nickName': nickName,
      'departments': departments,
      'introduction': introduction,
      'currentCourses': currentCourses,
      'pastCourses': pastCourses,
      // `profileImage`에 대한 JSON 변환은 해당 이미지 처리 방식에 따라 달라질 수 있습니다.
      'profileImage': profileImage, // 예시로 네트워크 이미지의 URL을 사용하였습니다.
      'point': point,
      'question': question,
      'answer': answer,
      'studyCnt': studyCnt,
      'review': review,
    };
  }

  static Future<UserProfileInfo?> fetchUserProfile(String nickname) async {
    // 유저 프로필 정보 가져와서 UserProfileInfo 반환, 실패시 null 반환
    final response = await http.get(
      Uri.parse('$BASE_URL/user/profile?nickname=$nickname'),
    );
    try {
      if (response.statusCode == 200) {
        //print('Response data(유저정보): ${utf8.decode(response.bodyBytes)}'); // 확인
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));

        // 이미지 처리 base64 string으로 받아서 임시 파일에 profile_image.png로 저장 후 경로 반환.
        if (data['profileImage'] != null) {
          final bytes = base64Decode(data['profileImage']);

          data['profileImage'] = bytes; //
        } else {
          data['profileImage'] = File('image/unis.png').readAsBytesSync();
        }

        data['nickName'] = nickname; // 서버 응답에 없는 닉네임을 추가

        final temp = UserProfileInfo.fromJson(data);
        //print(" 유저정보 패치 ${temp.toJson()}");
        return temp;
      } else {
        throw Exception('Failed to load user profile'); //
      }
    } catch (error) {
      print("패치 오류 $error");
      // 네트워크 호출 중 발생한 예외 처리
      print("fetchUserprofile error ");
    }
    return null;
  }

  Future<String> setImage(String nickname, Uint8List bytes) async {
    // 이미지 파일을 Base64 문자열로 인코딩

    // profileImage에 경로 저장
    profileImage = bytes;
    final String base64Image = base64Encode(bytes);

    // 프로필 이미지 업로드 API 호출
    final url = Uri.parse('$BASE_URL/user/profile/setImage/$nickname');
    // HTTP 헤더에 'Content-Type': 'application/json'을 추가
    //final headers = {'Content-Type': 'application/json'};
    // 요청 본문에 Base64 인코딩된 이미지 데이터를 담은 JSON 생성
    final body = {'img': base64Image};
    // print("sdfdf    $body");
    // POST 요청을 전송
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    // 응답 처리
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // 오류 메시지 출력
      print('Failed to upload profile image: ${response.body}');
      return 'error';
    }
  }

  Future<String> setIntroduction(String nickname, String introduction) async {
    // 자기소개 성공시 ok 반환 아닐시에 오류 던짐
    // 자기 소개 업데이트 API 호출
    final url = Uri.parse(
        '$BASE_URL/user/profile/setIntroduction/$nickname?introduction=$introduction');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      this.introduction = introduction;
      return response.body;
    } else {
      throw Exception('Failed to update introduction');
    }
  }

  Future<String> changeCourseNowToPast(
      String nickname, String courseName) async {
    // 현재 과목을 수강한 과목으로 변경하는 API 호출
    currentCourses.remove(courseName);
    pastCourses.add(courseName);
    final url = Uri.parse(
        '$BASE_URL/user/profile/nowToPastCourse/$nickname?courseName=$courseName');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // 업데이트 성공 시 처리
      // 예: currentCourses에서 해당 과목 삭제, pastCourses에 추가
      return response.body; // ok
    } else {
      pastCourses.remove(courseName);
      currentCourses.add(courseName);
      throw Exception(
          'Failed to change course from now to past ${response.statusCode}');
    }
  }

  Future<String> changeCoursePastToNow(
      String nickname, String courseName) async {
    // 수강한 과목을 현재 과목으로 변경하는 API 호출
    pastCourses.remove(courseName);
    currentCourses.add(courseName);
    final url = Uri.parse(
        '$BASE_URL/user/profile/PastToNowCourse/$nickname?courseName=$courseName');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // 업데이트 성공 시 처리
      // 예: pastCourses에서 해당 과목 삭제, currentCourses에 추가
      return response.body;
    } else {
      currentCourses.remove(courseName);
      pastCourses.add(courseName);
      throw Exception('Failed to change course from past to now');
    }
  }

  Future<String> setDepartment(
      String nickname, DepartmentDto departmentDto) async {
    // 학과 선택

    final response = await http.post(
      Uri.parse('$BASE_URL/user/profile/setDepartment/$nickname'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(departmentDto.toJson()),
    );

    if (response.statusCode == 200) {
      departments[0] = departmentDto.depts[0];
      if (departments.length == 2) departments.removeLast();
      if (departmentDto.depts.length == 2)
        departments.add(departmentDto.depts[1]);
      return response.body;
    } else {
      throw Exception('Failed to set department : ${response.body}');
    }
  }

  Future<String> setCourseAll(String nickname, CourseAllDto course) async {
    final url = Uri.parse('$BASE_URL/user/profile/setCourseAll/$nickname');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(course.toJson());

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      currentCourses = course.currentCourses;
      pastCourses = course.pastCourses;
      return 'ok';
    } else {
      throw Exception('Failed to set course data.');
    }
  }

  Future<void> setPoint(String nickname, int point) async {
    print("nickname $nickName, setPoint: ${point}");
    final response = await http.post(
      Uri.parse('$BASE_URL/user/profile/point?nickname=$nickname&point=$point')
    );

    if (response.statusCode == 200) {
      // 요청 성공 처리
      print('Point updated successfully');
    } else {
      // 요청 실패 처리
      print('Failed to update point');
    }
  }

  Future<void> minusPoint(String nickname, int point) async {
    final url = Uri.parse('$BASE_URL/user/profile/point/minus?nickname=$nickname&point=$point');

    // POST 요청을 보냅니다.
    final response = await http.post(url);

    // 응답을 콘솔에 출력합니다.
    print("모델: ${response.body}");

    // 요청이 성공했는지 확인합니다.
    if (response.statusCode != 200) {
      throw Exception('Failed to minus points');
    }

    // 여기에서 추가적인 데이터 처리나 상태 변경이 필요할 수 있습니다.
    // 예를 들어, 응답 데이터를 디코드하고 사용할 수 있습니다.
    // var data = jsonDecode(utf8.decode(response.bodyBytes));
  }

  // Function to get points for a user by nickname
  Future<int> getUserPoints(String nickname) async {
    // Construct the URL for the GET request
    final url = Uri.parse('$BASE_URL/user/getPoint?nickname=$nickname');

    try {
      // Send the GET request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {

        print("Model: ${response.body}");

        return int.parse(response.body);
      } else {
        // Handle the case when the server returns a non-200 HTTP status code
        print('Server error: ${response.statusCode}');
        throw Exception('Failed to load points');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request
      print('Error occurred: $e');
      throw Exception('Failed to load points');
    }
  }


// // 과목 설정 함수
//   Future<String> setCourse(String nickname, CourseDto courseDto) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/user/profile/setCourse/$nickname'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: json.encode(courseDto.toJson()),
//     );
//
//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('Failed to set course');
//     }
//   }
//
// // 과목 삭제 함수
//   Future<String> removeCourse(String nickname, CourseDto courseDto) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/user/profile/removeCourse/$nickname'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: json.encode(courseDto.toJson()),
//     );
//
//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('Failed to remove course');
//     }
//   }


}
