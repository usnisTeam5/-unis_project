import 'package:flutter/material.dart';
import '../models/register.dart';

class UserViewModel extends ChangeNotifier {
  final ApiService _apiService;
  VerificationDto? _verificationDto; // 이메일 인증 후 정보
  VerificationCheckDto? _verificationCheckDto;
  UserDto? _userDto;

  String? _authenticationStatusEmail; // 닉네임 중복 체크 ok false
  String? _authenticationStatusCode; // 닉네임 중복 체크 ok false
  String? _authenticationStatusNickname; // 닉네임 중복 체크 ok false
  String? _registrationStatus;

  UserViewModel(this._apiService);

  // Getter for the verification DTO
  VerificationDto? get verificationDto => _verificationDto;
  VerificationCheckDto? get verificationCheckDto => _verificationCheckDto;
  UserDto? get userDto => _userDto ;

  set userDto(UserDto? newUserDto) {
    _userDto = newUserDto;
  }
  // Getter for authentication status
  String? get authenticationStatusEmail => _authenticationStatusEmail;
  String? get authenticationStatusCode => _authenticationStatusCode;
  String? get authenticationStatusNickname => _authenticationStatusNickname;

  // Getter for registration status
  String? get registrationStatus => _registrationStatus;

  // Method to handle email authentication
  Future<void> authenticateEmail(String email) async {
    _verificationDto = await _apiService.checkEmailEnroll(email);
    _authenticationStatusEmail = _verificationDto?.msg;
    // Notify listeners to update UI
    notifyListeners();
  }

  // Method to handle code checking
  Future<void> checkCode(VerificationCheckDto info) async {
    String? result = await _apiService.checkCode(info);
    _authenticationStatusCode = result;
    // Notify listeners to update UI
    notifyListeners();
  }

  // Method to handle nickname duplication check
  Future<void> dupCheckNickname(String nickname) async {
    String? result = await _apiService.dupCheckNickname(nickname);
    _authenticationStatusNickname = result;
    // Notify listeners to update UI
    notifyListeners();
  }

  // Method to handle user registration
  Future<void> enroll(UserDto user) async {
    String? result = await _apiService.enroll(user);
    _registrationStatus = result;
    // Notify listeners to update UI
    notifyListeners();
  }
}
