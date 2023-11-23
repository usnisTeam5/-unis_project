import 'package:flutter/foundation.dart';
import '../models/find_study.dart';



class StudyViewModel with ChangeNotifier {
  StudyMakeDto? _studyMakeDto;
  StudyInfoDto? _studyInfoDto;

  // 생성자
  StudyViewModel({StudyMakeDto? studyMakeDto, StudyInfoDto? studyInfoDto})
      : _studyMakeDto = studyMakeDto ?? StudyMakeDto.defaultValues(),
        _studyInfoDto = studyInfoDto ?? StudyInfoDto.defaultValues();

  // StudyMakeDto에 대한 게터 메소드, 스터디 생성
  StudyMakeDto? get studyMakeDto => _studyMakeDto;

  String get roomName => _studyMakeDto?.roomName ?? '';
  String get code => _studyMakeDto?.code ?? '';
  String get course => _studyMakeDto?.course ?? '';
  int get maxNum => _studyMakeDto?.maxNum ?? 0;
  String get studyIntroduction => _studyMakeDto?.studyIntroduction ?? '';
  String get leader => _studyMakeDto?.leader ?? '';
  String get startDate => _studyMakeDto?.startDate ?? '';
  bool get isOpen => _studyMakeDto?.isOpen ?? false;


  // StudyInfoDto에 대한 게터 메소드, 스터디 찾기
  StudyInfoDto? get studyInfoDto => _studyInfoDto;

  int get infoRoomKey => _studyInfoDto?.roomKey ?? 0;
  String get infoRoomName => _studyInfoDto?.roomName ?? '';
  String get infoCourse => _studyInfoDto?.course ?? '';
  int get infoMaxNum => _studyInfoDto?.maxNum ?? 0;
  int get infoCurNum => _studyInfoDto?.curNum ?? 0;
  String get infoLeader => _studyInfoDto?.leader ?? '';
  String get infoStartDate => _studyInfoDto?.startDate ?? '';
  bool get infoIsOpen => _studyInfoDto?.isOpen ?? false;
  String get infoStudyIntroduction => _studyInfoDto?.studyIntroduction ?? '';


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _resultMessage = '';
  String get resultMessage => _resultMessage;
  List<StudyInfoDto> _studyRoomlist = [];
  List<StudyInfoDto> get studyRoomlist => _studyRoomlist;

  final StudyService _studyService = StudyService();



  Future<void> makeStudyRoom(StudyMakeDto info) async { // 스터디 생성
    try {
      _isLoading = true;
      notifyListeners();

      final bool success = await StudyService.makeStudyRoom(info);

      if (success) {
        _resultMessage = '스터디 생성 성공.';
      } else {
        _resultMessage = '스터디 생성 실패, 스터디 이름이 같음.';
      }

      _isLoading = false;
      notifyListeners();

    } catch (e) {
      print("makeStudyRoom viewmodel $e");
      _resultMessage = '스터디 생성 중 오류 발생.';
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> getStudyRoomList(String nickname, RoomStatusDto roomStatus) async { // 스터디 찾기
    try {
      _isLoading = true;
      notifyListeners();

      _studyRoomlist = await _studyService.getStudyRoomList(nickname, roomStatus);
      _resultMessage = '스터디룸 목록 로드 성공.';

      _isLoading = false;
      notifyListeners();

    } catch (e) {
      print("getStudyRoomList viewmodel $e");
      _resultMessage = '스터디룸 목록 로드 실패.';
      _studyRoomlist = [];
      _isLoading = false;
      notifyListeners();
    }
  }





}
