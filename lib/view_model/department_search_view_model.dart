import 'package:flutter/material.dart';
import '../models/department_search.dart'; // DepartmentSearch 클래스를 포함한 파일을 임포트합니다.

class DepartmentSearchViewModel with ChangeNotifier {
  List<String> _departments = [];
  bool _isLoading = false;

  List<String> get departments => _departments;
  bool get isLoading => _isLoading;

  // 학과 목록 검색
  void searchDepartment(String deptName) async {
    _isLoading = true;
    notifyListeners(); // 상태가 변경되었음을 리스너들에게 알립니다.

    try {
      _departments = await DepartmentSearch().findDepartment(deptName);
      // 검색이 성공적으로 완료되면, UI를 업데이트하기 위해 notifyListeners를 호출합니다.
      print("Hello");
    } catch (e) {
      _departments = [];// 오류가 발생한 경우, 학과 목록을 비웁니다.
      // 오류 처리 로직을 여기에 추가할 수 있습니다.
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 상태가 변경되었음을 리스너들에게 알립니다.
    }
  }
}
