import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/other_profile_model.dart';



class UserProfileViewModel with ChangeNotifier {
  UserProfileInfoForShow? _profileInfo;
  bool _isLoading = false;

  bool _isFavoriteSelected = false;
  bool get isFavoriteSelected => _isFavoriteSelected;


  UserProfileInfoForShow? get profileInfo => _profileInfo;
  String get nickname => _profileInfo?.nickname ?? "정보없음";
  List<String?> get departments => _profileInfo?.departments ?? [];
  String get introduction => _profileInfo?.introduction ?? "정보없음";
  String get profileImage => _profileInfo?.profileImage ?? "";
  bool get isPick => _profileInfo?.isPick ?? false;
  bool get isFriend => _profileInfo?.isFriend ?? false;
  bool get isBlock => _profileInfo?.isBlock ?? false;
  int get question => _profileInfo?.question ?? 1;
  int get answer => _profileInfo?.answer ?? 2;
  int get studyCnt => _profileInfo?.studyCnt ?? 3;
  bool get isLoading => _isLoading;


  Future<void> fetchUserProfile(String nickname) async {
    try {
      _isLoading = true;
      notifyListeners();
      _profileInfo = await UserProfileInfoForShow.fetchUserProfile(nickname);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("fetchUserProfileForShow viewmodel 에러");
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }


  Future<void> toggleFavorite(String nickname, String otherNickname) async { // 찜하기를 선택했을 때
    await UserProfileInfoForShow.setPick(_profileInfo!.nickname, otherNickname);
    notifyListeners();
  }


















}

