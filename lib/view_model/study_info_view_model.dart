import 'package:flutter/foundation.dart';
import '../models/study_info.dart';

class MyStudyInfoViewModel with ChangeNotifier {
  MyStudyInfo? _MystudyInfo;
  // int _studyCount =0;

  MyStudyInfoViewModel({MyStudyInfo? MystudyInfo})
      : _MystudyInfo = MystudyInfo ?? MyStudyInfo.defaultValues(); // 디폴트 값 넣어놓음

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
