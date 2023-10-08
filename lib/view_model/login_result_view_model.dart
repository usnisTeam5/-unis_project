import 'package:flutter/foundation.dart';
import '../models/login_result.dart';

class LoginViewModel with ChangeNotifier {
  LoginResult? _loginResult;
  bool _isLoading = false;
  String? _error;

  // Getter methods
  String? get msg => _loginResult?.msg;
  int? get userKey => _loginResult?.userKey;
  String? get userNickName => _loginResult?.userNickName;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setter methods
  set msg(String? newMsg) {
    if (_loginResult?.msg != newMsg) {
      _loginResult = LoginResult(
        msg: newMsg ?? "",
        userKey: _loginResult?.userKey ?? 0,
        userNickName: _loginResult?.userNickName ?? "",
      );
      notifyListeners();
    }
  }

  set userKey(int? newUserKey) {
    if (_loginResult?.userKey != newUserKey) {
      _loginResult = LoginResult(
        msg: _loginResult?.msg ?? "",
        userKey: newUserKey ?? 0,
        userNickName: _loginResult?.userNickName ?? "",
      );
      notifyListeners();
    }
  }

  set userNickName(String? newUserNickName) {
    if (_loginResult?.userNickName != newUserNickName) {
      _loginResult = LoginResult(
        msg: _loginResult?.msg ?? "",
        userKey: _loginResult?.userKey ?? 0,
        userNickName: newUserNickName ?? "",
      );
      notifyListeners();
    }
  }

  set isLoading(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  set error(String? newError) {
    if (_error != newError) {
      _error = newError;
      notifyListeners();
    }
  }

  // 로그인 메서드 (이전 내용과 동일)
  Future<void> login(String id, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _loginResult = LoginResult(
      msg: "로그인 성공",
      userKey: int.tryParse(id) ?? 0,
      userNickName: password,
    );

    _isLoading = false;
    notifyListeners();
  }

// 추가로 필요한 로직 (로그아웃, 로그인 상태 초기화 등)은 여기에 추가하면 됩니다.
}
