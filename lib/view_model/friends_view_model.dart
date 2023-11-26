import 'package:flutter/foundation.dart';
import '../models/friends_model.dart';

class FriendsProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  bool _isLoading = false;
  List<UserInfoMinimumDto> friendList = [];
  List<UserInfoMinimumDto> blockList = [];
  List<UserInfoMinimumDto> pickList = [];

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void notify(){
      notifyListeners();
  }
  // 친구 목록 가져오기
  Future<void> fetchFriends(String nickname) async {
    setLoading(true);
    try {
      friendList = await _userService.getFriends(nickname);
    } catch (e) {
      // 예외 처리 로직
      print('Error fetching friend list: $e');
    } finally {
      setLoading(false);
    }
  }

  // 차단 목록 가져오기
  Future<void> fetchBlocks(String nickname) async {
    setLoading(true);
    try {
      blockList = await _userService.getBlocks(nickname);
    } catch (e) {
      // 예외 처리 로직
      print('Error fetching block list: $e');
    } finally {
      setLoading(false);
    }
  }

  // 찜 목록 가져오기
  Future<void> fetchPicks(String nickname) async {
    setLoading(true);
    try {
      pickList = await _userService.getPicks(nickname);
    } catch (e) {
      // 예외 처리 로직
      print('Error fetching pick list: $e');
    } finally {
      setLoading(false);
    }
  }
}
