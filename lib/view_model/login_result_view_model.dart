import 'package:flutter/foundation.dart';
import '../models/login_result.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginResult? _loginResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResult? get loginResult => _loginResult;
  String? get msg => _loginResult?.msg;
  String? get userNickName => _loginResult?.userNickName;
  int? get userKey => _loginResult?.userKey;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _loginResult = await LoginResult.login(email, password);
      _setLoading(false);

      if (_loginResult != null) {
        _setErrorMessage(null);
        return true;
      } else {
        _setErrorMessage('로그인 실패');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('로그인 중 오류 발생: $e');
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
