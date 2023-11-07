import 'package:http/http.dart' as http;
import 'dart:convert';


// 이메일 인증을 위한 DTO
class VerificationDto {
  String? verificationHashcode;
  int? epochSecond;
  String? msg;

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

// 인증번호 확인을 위한 DTO
class VerificationCheckDto {
  int? verificationNum;
  int? epochSecond;
  String? email;
  String? verificationHashcode;

  VerificationCheckDto({
    this.verificationNum,
    this.epochSecond,
    this.email,
    this.verificationHashcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'verificationNum': verificationNum,
      'epochSecond': epochSecond,
      'email': email,
      'verificationHashcode': verificationHashcode,
    };
  }
}

// 비밀번호 변경을 위한 DTO
class LoginDataDto {
  String? email;
  String? password;

  LoginDataDto({this.email, this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthenticationService {
  // 서버의 base URL
  final String baseUrl = "http://3.35.21.123:8080";

  // 이메일 인증
  Future<VerificationDto?> authenticateEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/find/authenticate/pw?email=$email'),
    );

    if (response.statusCode == 200) {
      return VerificationDto.fromJson(json.decode(response.body));
    } else {
      // Error handling
      print('Failed to authenticate email');
      return null;
    }
  }

  // 인증번호 확인
  Future<String?> checkVerificationCode(VerificationCheckDto info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/authenticate/check'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(info.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // Error handling
      print('Failed to check verification code');
      return null;
    }
  }

  // 비밀번호 변경
  Future<String?> changePassword(LoginDataDto data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/changePassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // Error handling
      print('Failed to change password');
      return null;
    }
  }
}
