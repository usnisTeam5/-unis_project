import 'package:flutter/foundation.dart';
import '../models/login_result.dart';
class LoginViewModel extends ChangeNotifier {
  LoginResult? _loginResult; // 앞에 underbar가 붙으면 private란 뜻입니다.
  bool _isLoading = false;
  String? _error;

  LoginResult? get loginResult => _loginResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 예: 로그인 로직을 처리하는 메서드
  Future<void> login(String id, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // 이 부분에 실제 로그인 로직을 구현합니다. 예를 들어, 백엔드 API와 통신하는 코드가 들어갈 수 있습니다.
    // 예시 코드:
    // final response = await Api.login(id, password);
    // if (response.isSuccessful) {
    //   _loginResult = LoginResult.fromJson(response.data);
    // } else {
    //   _error = response.errorMessage;
    // }

    _isLoading = false;
    notifyListeners();
  }

// 로그아웃, 로그인 상태 초기화 등 다른 로직도 여기에 추가할 수 있습니다.
}
