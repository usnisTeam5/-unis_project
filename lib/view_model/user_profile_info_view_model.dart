import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/user_profile_info.dart';  // UserProfileInfo 클래스의 경로를 넣어주세요

class UserProfileViewModel with ChangeNotifier {
  UserProfileInfo? _profileInfo;
  bool _isLoading = false;

  UserProfileInfo get profileInfo => _profileInfo!;
  String get nickName => _profileInfo!.nickName;
  List<String> get departments => _profileInfo!.departments;
  String get introduction => _profileInfo!.introduction;
  List<String> get currentCourses => _profileInfo!.currentCourses;
  List<String> get pastCourses => _profileInfo!.pastCourses;
  Uint8List get profileImage => _profileInfo!.profileImage;
  int get point => _profileInfo!.point;
  int get question => _profileInfo!.question;
  int get answer => _profileInfo!.answer;
  int get studyCnt => _profileInfo!.studyCnt;
  bool get isLoading => _isLoading;
  double get review => _profileInfo!.review;


  void noti() {
    //_profileInfo!.point += point;
    notifyListeners(); // 변경 사항 알림
  }

  void incrementStudyCnt() {
    _profileInfo!.studyCnt++;
    notifyListeners(); // 변경 사항 알림
  }

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
  Future<void> updateProfileImage(Uint8List imagePath) async {
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

  Future<void> selectDepartment(DepartmentDto departmentDto) async {
    try {
      await _profileInfo!.setDepartment(nickName, departmentDto);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print(e.toString());
    }
  }

  Future<void> setCourseAll(CourseAllDto course) async {
    try {
      await _profileInfo!.setCourseAll(_profileInfo!.nickName, course);
      notifyListeners();
      // 성공적으로 저장한 경우 다른 작업을 수행할 수 있습니다.
    } catch (e) {
      // 저장 실패 시 예외 처리
      print('Failed to set course data: $e');
      rethrow;
    }
  }

  Future<void> setPoint(String nickname, int point) async {
    try {
      await _profileInfo!.setPoint(nickName, point);
      _profileInfo!.point += point; // 화면에 보여주기 위해서 추가
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print(e.toString());
    }
  }

  // // 과목 설정
  // Future<void> addCourse(CourseDto courseDto) async {
  //   try {
  //     await _profileInfo!.setCourse(nickName, courseDto);
  //     notifyListeners();
  //   } catch (e) {
  //     // 에러 처리
  //     print(e.toString());
  //   }
  // }
  //
  // // 과목 삭제
  // Future<void> deleteCourse(CourseDto courseDto) async {
  //   try {
  //     await _profileInfo!.removeCourse(nickName, courseDto);
  //     // 과목 목록에서 삭제된 과목 제거
  //     //courses.removeWhere((course) => courseDto.courses.contains(course));
  //     notifyListeners();
  //   } catch (e) {
  //     // 에러 처리
  //     print(e.toString());
  //   }
  // }
// 필요한 다른 메서드들을 여기에 추가하세요 (예: 프로필 정보 변경, 포인트 증가 등)
}

