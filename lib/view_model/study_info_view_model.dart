import 'package:flutter/foundation.dart';
import '../models/study_info.dart';

class StudyInfoViewModel with ChangeNotifier {
  StudyInfo? _studyInfo;

  StudyInfoViewModel({StudyInfo? studyInfo})
      : _studyInfo = studyInfo ?? StudyInfo.defaultValues();

  // Getters
  StudyInfo? get studyInfo => _studyInfo;

  int get roomKey => _studyInfo?.roomKey ?? 0;
  String get roomName => _studyInfo?.roomName ?? '';
  String get course => _studyInfo?.course ?? '';
  int get maximumNum => _studyInfo?.maximumNum ?? 0;
  int get curNum => _studyInfo?.curNum ?? 0;
  String get leader => _studyInfo?.leader ?? '';
  String get startDate => _studyInfo?.startDate ?? '';
  bool get isOpen => _studyInfo?.isOpen ?? false;
  String get studyIntroduction => _studyInfo?.studyIntroduction ?? '';

  // Setters
  void updateRoomName(String newRoomName) {
    if (_studyInfo != null) {
      _studyInfo = StudyInfo(
        roomKey: _studyInfo!.roomKey,
        roomName: newRoomName,
        course: _studyInfo!.course,
        maximumNum: _studyInfo!.maximumNum,
        curNum: _studyInfo!.curNum,
        leader: _studyInfo!.leader,
        startDate: _studyInfo!.startDate,
        isOpen: _studyInfo!.isOpen,
        studyIntroduction: _studyInfo!.studyIntroduction,
      );
      notifyListeners();
    }
  }

  // Add other setters as needed

  void fromJson(Map<String, dynamic> json) {
    _studyInfo = StudyInfo.fromJson(json);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return _studyInfo?.toJson() ?? {};
  }
}
