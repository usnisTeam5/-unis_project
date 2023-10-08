import 'package:flutter/foundation.dart';
import '../models/study_info.dart';

class StudyInfoViewModel with ChangeNotifier {
  StudyInfo? _studyInfo;

  StudyInfoViewModel({StudyInfo? studyInfo})
      : _studyInfo = studyInfo ?? StudyInfo.defaultValues();

  // Getters
  StudyInfo? get studyInfo => _studyInfo;

  int get roomNum => _studyInfo?.roomNum ?? 0;
  String get roomName => _studyInfo?.roomName ?? '';
  String get major => _studyInfo?.major ?? '';
  int get maximumNum => _studyInfo?.maximumNum ?? 0;
  int get num => _studyInfo?.num ?? 0;
  String get leaderNickName => _studyInfo?.leaderNickName ?? '';
  String get startDate => _studyInfo?.startDate ?? '';
  bool get isOpen => _studyInfo?.isOpen ?? false;
  String get studyIntroduction => _studyInfo?.studyIntroduction ?? '';

  // Setters
  void updateRoomName(String newRoomName) {
    if (_studyInfo != null) {
      _studyInfo = StudyInfo(
        roomNum: _studyInfo!.roomNum,
        roomName: newRoomName,
        major: _studyInfo!.major,
        maximumNum: _studyInfo!.maximumNum,
        num: _studyInfo!.num,
        leaderNickName: _studyInfo!.leaderNickName,
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
