import 'package:flutter/material.dart';
import '../models/enroll_question.dart'; // MsgDto와 QaDto가 정의된 파일

class QaViewModel with ChangeNotifier {
  List<String> _userCourses = [];
  bool _isLoading = false;
  List<String> get userCourses => _userCourses;
  bool get isLoading => _isLoading;

  void setUserCourses(List<String> courses) {
    _userCourses = courses;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> getUserCourses(String nickname) async { // 유저의 코스를 받아옴
    setLoading(true);
    try {
      var courses = await QaService.getUserCourse(nickname);
      setUserCourses(courses);
    } catch (e) {
      // Error handling
      print('Error loading user courses: $e');
    }finally{
      setLoading(false);
    }

  }

  Future<void> enrollQuestion(QaDto question) async { // 등록함
    setLoading(true);
    try {
      await QaService.enrollQuestion(question);
      // 추가적인 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // Error handling
      print('Error enrolling question: $e');
    }
    setLoading(false);
  }

  Future<String> deleteQa(int qaKey) async { // 삭제함
    setLoading(true);
    try {
      String ans = await QaService.deleteQa(qaKey);
      setLoading(false);
      return ans; // no or ok;
      // 추가적인 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // Error handling
      print('Error deleting QA: $e');
      setLoading(false);
      return "no";
    }
  }
}
