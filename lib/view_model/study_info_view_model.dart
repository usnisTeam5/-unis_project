import 'package:flutter/foundation.dart';
import '../models/study_info.dart';

class MyStudyInfoViewModel with ChangeNotifier {
  MyStudyInfo? _MystudyInfo;
  // int _studyCount =0;
  MyStudyInfoViewModel({MyStudyInfo? MystudyInfo})
      : _MystudyInfo = MystudyInfo ?? MyStudyInfo.defaultValues();
  List<MyStudyInfo> _MyStudyInfoList = [];
  bool _isLoading = false;
  // Getters
  bool get isLoading => _isLoading;
  MyStudyInfo? get MystudyInfo => _MystudyInfo;


  int get roomKey => _MystudyInfo?.roomKey ?? 0;
  String get roomName => _MystudyInfo?.roomName ?? '';
  String get course => _MystudyInfo?.course ?? '';
  int get maxNum => _MystudyInfo?.maxNum ?? 0;
  int get curNum => _MystudyInfo?.curNum ?? 0;
  String get startDate => _MystudyInfo?.startDate ?? '';
  String get studyIntroduction => _MystudyInfo?.studyIntroduction ?? '';
  List<MyStudyInfo> get MyStudyInfoList => _MyStudyInfoList ?? [];



  //int get studyCount => _studyCount;
  // Setters
  // void updateRoomName(String newRoomName) {
  //   if (_MystudyInfo != null) {
  //     _MystudyInfo = MyStudyInfo(
  //       roomKey: _MystudyInfo!.roomKey,
  //       roomName: newRoomName,
  //       course: _MystudyInfo!.course,
  //       maxNum: _MystudyInfo!.maxNum,
  //       curNum: _MystudyInfo!.curNum,
  //       startDate: _MystudyInfo!.startDate,
  //       studyIntroduction: _MystudyInfo!.studyIntroduction,
  //     );
  //     notifyListeners();
  //   }
  // }

  // Add other setters as needed

  // void fromJson(Map<String, dynamic> json) {
  //   _MyStudyInfoList = MyStudyInfo.fromJson(json);
  //   notifyListeners();
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return _MyStudyInfoList?.toJson() ?? {};
  // }


  Future<void> getMyStudyRoomList(String nickname) async {
    try {
      _isLoading = true;
      notifyListeners();

      _MyStudyInfoList = await MyStudyInfoModel.getMyStudyRoomList(nickname);
      //_studyCount = MyStudyInfoList.length;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("getMyStudyRoomList viewmodel $e");
      _isLoading = false;
      notifyListeners();
    }
  }

}
