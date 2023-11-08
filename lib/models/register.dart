import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';
// VerificationDto.dart
class VerificationDto {
  String? verificationHashcode; //해시코드
  int? epochSecond; // 나중에 인증번호 확인할 때 시간
  String? msg; // noEmailForm , duplicate, ok

  VerificationDto({this.verificationHashcode, this.epochSecond, this.msg});

  factory VerificationDto.fromJson(Map<String, dynamic> json) {
    return VerificationDto(
      verificationHashcode: json['verificationHashcode'],
      epochSecond: json['epochSecond'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verificationHashcode': verificationHashcode,
      'epochSecond': epochSecond,
      'msg': msg,
    };
  }
}

// VerificationCheckDto.dart
class VerificationCheckDto {
  int? verificationNum; // 이메일로 받은 인증번호
  int? epochSecond;
  String? email;
  String? verificationHashcode;

  VerificationCheckDto({this.verificationNum, this.epochSecond, this.email, this.verificationHashcode});

  Map<String, dynamic> toJson() {
    return {
      'verificationNum': verificationNum, // 이메일로 받은 인증번호
      'epochSecond': epochSecond,
      'email': email,
      'verificationHashcode': verificationHashcode,
    };
  }
}

// UserDto.dart
class UserDto {
  String? email;
  String? password;
  String? nickname;
  String? deptName1;
  String? deptName2; // 만약 전공이 1개라면 null을 반환
  List<String>? courseNames;

  UserDto({this.email, this.password, this.nickname, this.deptName1, this.deptName2, this.courseNames});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'dept_name1': deptName1,
      'dept_name2': deptName2,
      'course_name': courseNames,
    };
  }
}

class ApiService {
  //final String baseUrl = "http://3.35.21.123:8080"; // 여기에 실제 API URL을 적용하세요.

  // 인증하기 버튼을 눌렀을 때 호출되는 함수
  Future<VerificationDto?> checkEmailEnroll(String email) async {

    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9]+@cau.ac.kr$');

    // 이메일 형식이 올바른지 확인
    if (!emailRegex.hasMatch(email)) {
      print('이메일 형식이 올바르지 않습니다.');
      return null;
    }

    final response = await http.post(
      Uri.parse('$BASE_URL/user/authenticate?email=$email'),
    );

    if (response.statusCode == 200) {
      return VerificationDto.fromJson(json.decode(response.body));
    } else {
      // 오류 처리
      return null;
    }
  }

  // 확인 버튼을 눌렀을 때 호출되는 함수
  Future<String?> checkCode(VerificationCheckDto info) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/user/authenticate/check'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(info.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // 오류 처리
      return null;
    }
  }

  // 닉네임 중복 확인 버튼을 눌렀을 때 호출되는 함수
  Future<String?> dupCheckNickname(String nickname) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/user/nickname/dupCheck?nickname=$nickname'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // 오류 처리
      return null;
    }
  }

  // 회원가입 버튼을 눌렀을 때 호출되는 함수
  Future<String?> enroll(UserDto user) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/user/enroll'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to enroll user: ${response.statusCode}, Response: ${response.body}');
      return null;
    }
  }
}
