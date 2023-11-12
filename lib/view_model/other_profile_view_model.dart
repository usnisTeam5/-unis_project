import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/other_profile_model.dart';



class UserProfileViewModel extends ChangeNotifier {
  UserProfileInfoForShow? _profileInfo;
  bool _isLoading = false;



  UserProfileInfoForShow? get profileInfo => _profileInfo;
  String get nickname => _profileInfo?.nickname ?? "정보없음";
  List<String?> get departments => _profileInfo?.departments ?? ["소프트웨어학부"];
  String get introduction => _profileInfo?.introduction ?? "정보없음";
  String get profileImage => _profileInfo?.profileImage ?? "message.profileImage";
  bool get isPick => _profileInfo?.isPick ?? true;
  bool get isFriend => _profileInfo?.isFriend ?? false;
  bool get isBlock => _profileInfo?.isBlock ?? false;
  int get question => _profileInfo?.question ?? 1;
  int get answer => _profileInfo?.answer ?? 2;
  int get studyCnt => _profileInfo?.studyCnt ?? 3;
  bool get isLoading => _isLoading;


  Future<void> fetchUserProfile(String nickname, String friendNickname) async { // 상대방 프로필 정보
    try {
      _isLoading = true;
      notifyListeners();
      _profileInfo = await UserProfileInfoForShow.fetchUserProfile(nickname, friendNickname);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("fetchUserProfileForShow viewmodel 에러");
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }



  Future<void> setPick(String currentUserNickname, String otherNickname) async {
    try {
      var response = await UserProfileInfoForShow.setPick(currentUserNickname, otherNickname);
      if (response == "ok") {
        // 서버로부터 최신 프로필 정보를 다시 불러오기
        await fetchUserProfile(currentUserNickname, otherNickname);
      } else {
        throw Exception('Failed to update pick status on server');
      }
    } catch (e) {
      print('Error setting pick: $e');
    }
  }

  Future<void> setFriend(String nickname, String otherNickname) async {
    try {
      var response = await UserProfileInfoForShow.setFriend(nickname, otherNickname);
      if (response == "ok") {
        await fetchUserProfile(nickname, otherNickname);
      } else {
        throw Exception('Failed to update friend status on server');
      }
    } catch (e) {
      print('Error setting friend: $e');
    }
  }

  Future<void> setBlock(String nickname, String otherNickname) async {
    try {
      var response = await UserProfileInfoForShow.setBlock(nickname, otherNickname);
      if (response == "ok") {
        await fetchUserProfile(nickname, otherNickname);
        resetOtherStates(); // 차단 상태가 변경되면 다른 상태들도 업데이트
      } else {
        throw Exception('Failed to update block status on server');
      }
    } catch (e) {
      print('Error setting block: $e');
    }
  }

  void resetOtherStates() {
    if (_profileInfo?.isBlock ?? false) {
      _profileInfo = _profileInfo?.copyWith(isPick: false, isFriend: false);
      // 기타 필요한 상태 초기화

      notifyListeners(); // UI 업데이트를 위해 호출
    }
  }

  void setUserProfileInfo(UserProfileInfoForShow info) {

    notifyListeners();
  }


}