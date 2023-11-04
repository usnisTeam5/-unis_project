import 'package:flutter/material.dart';
import '../models/subject_search.dart'; // SubjectSearch 클래스를 포함한 파일을 임포트합니다.

class SubjectSearchViewModel with ChangeNotifier {
  List<String> _subjects = [];
  bool _isLoading = false;

  List<String> get subjects => _subjects;
  bool get isLoading => _isLoading;

  // 과목 목록 검색
  void searchSubject(String keyword) async {
    _isLoading = true;
    notifyListeners(); // 상태가 변경되었음을 리스너들에게 알립니다.

    try {
      _subjects = await SubjectSearch().findSubject(keyword);
      // 검색이 성공적으로 완료되면, UI를 업데이트하기 위해 notifyListeners를 호출합니다.
    } catch (e) {
      _subjects = [
        '컴퓨터와 휴먼1',
        '인공지능과 윤리2',
        '빅데이터 분석3',
        '휴먼인터페이스미디어와 마법의 돌과 죄수4',
        '컴퓨터와 휴먼5',
        '인공지능과 윤리6',
        '빅데이터 분석7',
        '휴먼인터페이스미디어와 마법의 돌과 죄수8',
        '컴퓨터와 휴먼9',
        '인공지능과 윤리10',
        '빅데이터 분석11',
        '휴먼인터페이스미디어12',
      ];// 오류가 발생한 경우, 과목 목록을 비웁니다.
      // 오류 처리 로직을 여기에 추가할 수 있습니다.
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 상태가 변경되었음을 리스너들에게 알립니다.
    }
  }
}
