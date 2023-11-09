import 'package:flutter/material.dart';
import '../models/user_profile_info.dart';  // UserProfileInfo 클래스의 경로를 넣어주세요

class UserProfileViewModel with ChangeNotifier {
  UserProfileInfo? _profileInfo;
  bool _isLoading = false;

  UserProfileInfo get profileInfo => _profileInfo!;
  String get nickName => _profileInfo!.nickName;
  List<String?> get departments => _profileInfo!.departments;
  String get introduction => _profileInfo!.introduction;
  List<String> get currentCourses => _profileInfo!.currentCourses;
  List<String> get pastCourses => _profileInfo!.pastCourses;
  String get profileImage => _profileInfo!.profileImage;
  int get point => _profileInfo!.point;
  int get question => _profileInfo!.question;
  int get answer => _profileInfo!.answer;
  int get studyCnt => _profileInfo!.studyCnt;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfile(String nickName) async { // 유저 프로필 정보 가져옴. 실패시에 모델에서 오류 던진 것 받아서 뷰로 던짐
    try {
      _isLoading = true;
      notifyListeners();
      _profileInfo = await UserProfileInfo.fetchUserProfile(nickName);
      //_profileInfo ??= UserProfileInfo.defaultValues();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("fetchUserprofile viewmodel 에러");
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  // 모델 클래스의 함수를 활용하여 프로필 이미지 업데이트
  Future<void> updateProfileImage(String imagePath) async {
    await _profileInfo!.setImage(_profileInfo!.nickName, imagePath); // 모델 클래스의 setImage 함수 활용
    notifyListeners();
  }

  // 모델 클래스의 함수를 활용하여 자기 소개 업데이트
  Future<void> updateIntroduction(String newIntroduction) async {
    await _profileInfo!.setIntroduction(_profileInfo!.nickName, newIntroduction); // 모델 클래스의 setIntroduction 함수 활용
    notifyListeners();
  }
// 통신 추가 필요.
  // 수강 중인 과목 변경 (체크 해제)
  Future<void> changeCourseNowToPast(String courseName) async {
    await _profileInfo!.changeCourseNowToPast(_profileInfo!.nickName, courseName);
    notifyListeners();
  }

  // 수강한 과목 변경 (체크)
  Future<void> changeCoursePastToNow(String courseName) async{
    await _profileInfo!.changeCoursePastToNow(_profileInfo!.nickName, courseName);
    notifyListeners();
  }

// 필요한 다른 메서드들을 여기에 추가하세요 (예: 프로필 정보 변경, 포인트 증가 등)
}
