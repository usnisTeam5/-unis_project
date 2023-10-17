import 'package:flutter/foundation.dart';
import '../models/login_result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false; // 로딩중
  LoginResult? _loginResult; // 로그인 모델( msg와 nickname 포함)
  final storage = new FlutterSecureStorage();
  String? _errorMessage; // 에러 메시지 변수 추가

  bool get isLoading => _isLoading;
  LoginResult? get loginResult => _loginResult;
  String? get msg => _loginResult?.msg;
  String? get userNickName => _loginResult?.userNickName;
  String? get errorMessage => _errorMessage;  // getter for error message

  Future<void> storeLoginInfo(String id, String password) async {
    // ID와 비밀번호를 각각 다른 키로 저장
    await storage.write(key: "login_id", value: id);
    await storage.write(key: "login_password", value: password);
  }

  Future<bool> autoLogin() async {
    String? storedId = await storage.read(key: 'login_id');
    String? storedPassword = await storage.read(key: 'login_password');
    if (storedId != null && storedPassword != null) {
      return await login(storedId, storedPassword);
    }
    return false;
  }


  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _loginResult = await LoginService.login(email, password); // 모델에서 로그인 불러옴
      _setLoading(false);

      if (_loginResult != null) {
        _setErrorMessage(null);
        return true;
      } else {
        _setErrorMessage('정보가 일치하지 않습니다.');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('로그인 중 오류 발생: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _loginResult = null;
    await storage.delete(key: 'login_id');
    await storage.delete(key: 'login_password');
    notifyListeners();
  }

  void _setLoading(bool value) { // 로딩을 변환
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) { // 에러메시지
    _errorMessage = message;
    notifyListeners();
  }
}
