import '../models/password_reset.dart';
import 'package:flutter/material.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationService _authService = AuthenticationService();
  VerificationDto? _verificationInfo;
  VerificationCheckDto? _verificationCheckDto;
  String? _error;

  VerificationDto? get verificationInfo => _verificationInfo;
  VerificationCheckDto? get verificationCheckDto => _verificationCheckDto;

  String? get error => _error;

  String? _authenticationStatusEmail; // 닉네임 중복 체크 ok false
  String? _authenticationStatusCode; // 닉네임 중복 체크 ok false

  String? get authenticationStatusEmail => _authenticationStatusEmail;
  String? get authenticationStatusCode => _authenticationStatusCode;

  void setEmailVerificationStatus(VerificationDto? info) {
    _verificationInfo = info;
    _authenticationStatusEmail = _verificationInfo?.msg;
    notifyListeners();
  }

  void setError(String? e) {
    _error = e;
    notifyListeners();
  }

  // 이메일 인증 요청
  Future<void> authenticateEmail(String email) async {
    var response = await _authService.authenticateEmail(email);
    print('${response?.msg} ${response?.epochSecond} ${response?.verificationHashcode}');
    if (response != null && response.msg == 'ok') {
      setEmailVerificationStatus(response);
    } else {
      _authenticationStatusEmail = response?.msg;
      notifyListeners();
      setError('이메일 인증에 실패하였습니다.');
    }
  }

  // 인증번호 확인 요청
  Future<void> checkCode(VerificationCheckDto info) async {
    var response = await _authService.checkVerificationCode(info);
    if (response == 'ok') {
      setError(null);
      _authenticationStatusCode = 'ok'; // 닉네임 중복 체크 ok false
    } else {
      setError('인증번호 확인에 실패하였습니다.');
    }
  }

  // 비밀번호 변경 요청
  Future<void> changePassword(LoginDataDto data) async {
    var response = await _authService.changePassword(data);

    if (response == 'ok') {
      setError(null);
    } else {
      setError('비밀번호 변경에 실패하였습니다.');
    }
  }
}
