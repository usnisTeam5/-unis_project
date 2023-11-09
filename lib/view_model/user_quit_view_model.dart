import 'package:flutter/foundation.dart';
import '../models/user_quit.dart';

class UserQuitViewModel with ChangeNotifier {
  UserQuit? _userQuit;
  bool _isLoading = false;
  String? _error;

  UserQuit? get userProfile => _userQuit;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void reset() {
    _error = null;
    _isLoading = false;
    _userQuit = null;
    notifyListeners();
  }

  Future<void> fetchPointInfo(String nickname) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userQuit = await UserQuit.fetchPointInfo(nickname);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> userQuit(String nickname) async {
    try {
      _isLoading = true;
      notifyListeners();

      await UserQuit.userQuit(nickname);

      // Optionally reset userProfile or update as per requirement
      _userQuit = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
