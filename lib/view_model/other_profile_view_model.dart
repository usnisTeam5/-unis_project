import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/other_profile_model.dart';



class UserProfileOtherViewModel extends ChangeNotifier {
  String _myNickname = "";
  // String _friendNickname = "";
  //
  String get myNickname => _myNickname;
  // String get friendNickname => _friendNickname;
  //
  //
  // void setUserNickname(String nickname) { // 내 닉네임 set
  //   _userNickname = nickname;
  //   notifyListeners();
  // }
  //
  // void setFriendNickname(String friendNickname) { // 상대방 닉네임
  //   _friendNickname = friendNickname;
  //   notifyListeners();
  // }

  UserProfileInfoForShow? _profileInfo = UserProfileInfoForShow.defaultValues(); // _profileInfo를 null로 초기화
  bool _isLoading = false;
  bool _isPick = false; // 초기값으로 false 설정

  UserProfileInfoForShow? get profileInfo => _profileInfo ;
  String get nickname => _profileInfo!.nickname ?? "정보없음";
  List<String> get departments => _profileInfo!.departments;
  String get introduction => _profileInfo!.introduction ?? "정보없음";
  String get profileImage => _profileInfo!.profileImage ?? 'image/unis.png';
  bool get isPick => _profileInfo!.isPick ?? true;
  bool get isFriend => _profileInfo!.isFriend ?? false;
  bool get isBlock => _profileInfo!.isBlock ?? false;
  int get question => _profileInfo!.question ?? 1;
  int get answer => _profileInfo!.answer ?? 2;
  int get studyCnt => _profileInfo!.studyCnt ?? 3;
  bool get isLoading => _isLoading;


  Future<void> fetchUserProfile(String userNickname, String friendNickname) async { // 상대방 들어갔을 때 정보 받아옴.
    try {
      _isLoading = true;
      notifyListeners();

      // _profileInfo를 UserProfileInfoForShow 클래스의 인스턴스로 초기화
      _profileInfo = await UserProfileInfoForShow.fetchUserProfile(userNickname, friendNickname);
      _myNickname = userNickname;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("fetchUserProfileForShow viewmodel 에러");
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }


  Future<void> setPick(String nickname, String otherNickname) async { // 찜/
    try {
      var response = await UserProfileInfoForShow.setPick(nickname, otherNickname);
      if (response == "ok") {
        // 서버로부터 최신 프로필 정보를 다시 불러오기
        await fetchUserProfile(nickname, otherNickname);
        // '찜' 상태 업데이트
        _isPick = !_isPick; // 현재 상태를 반전시킴
        notifyListeners(); // 리스너에게 상태 변경 알림
      } else {
        throw Exception('Failed to update pick status on server');
      }
    } catch (e) {
      print('Error setting pick: $e');
    }
  }


  Future<void> setFriend(String nickname, String otherNickname) async { // 친구
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

  Future<void> setBlock(String nickname, String otherNickname) async { // 차단
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

  void resetOtherStates() { // 차단 누르면 다 없어짐
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