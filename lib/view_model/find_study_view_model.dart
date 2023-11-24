import 'package:flutter/foundation.dart';
import '../models/find_study.dart';



class StudyViewModel with ChangeNotifier {

  StudyMakeDto? _studyMakeDto;
  StudyInfoDto? _studyInfoDto;
  RoomStatusDto roomStatus = RoomStatusDto(isAll: true, isSeatLeft: false, isOpen: false);
  UserInfoMinimumDto? _userInfoMinimumDto;
  StudyJoinDto? _studyJoinDto;

  StudyViewModel({StudyMakeDto? studyMakeDto, StudyInfoDto? studyInfoDto, UserInfoMinimumDto? userInfoMinimumDto}) {
    _studyMakeDto = studyMakeDto ?? StudyMakeDto.defaultValues();
    _studyInfoDto = studyInfoDto ?? StudyInfoDto.defaultValues();
    _userInfoMinimumDto = userInfoMinimumDto ?? UserInfoMinimumDto.defaultValues();
  }


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


  // UserInfoMinimumDto에 대한 게터 메소드, 가입한 스터디 입장할 때
  UserInfoMinimumDto? get userInfoMinimumDto => _userInfoMinimumDto;

  String get nickname => _userInfoMinimumDto?.nickname ?? '';
  String get image => _userInfoMinimumDto?.image ?? '';


  // StudyJoinDto 스터디 가입할 때
  StudyJoinDto? get studyJoinDto => _studyJoinDto;

  int get roomKey => _studyJoinDto?.roomKey ?? 15;
  String get joinCode => _studyJoinDto?.code ?? '';






  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final StudyService _studyService = StudyService();

  String _resultMessage = '';
  String get resultMessage => _resultMessage;

  List<StudyInfoDto> _studyRoomlist = [];
  List<StudyInfoDto> get studyRoomlist => _studyRoomlist;

  List<UserInfoMinimumDto> _studyFriendList = [];
  List<UserInfoMinimumDto> get studyFriendList => _studyFriendList;

  String _joinResult = '';
  String get joinReslt => _joinResult;




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
      this.roomStatus = roomStatus;
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



  Future<void> enterStudy(int roomKey, String nickname) async { // 가입 스터디 입장
    _isLoading = true;
    notifyListeners();

    try {
      _studyFriendList = await _studyService.enterStudy(roomKey, nickname);
      _resultMessage = '스터디 친구 목록 로드 성공.';

      _isLoading = false;
      notifyListeners();

    } catch (e) {
      print('Error loading study friends: $e');
      _resultMessage = '스터디 친구 목록 로드 실패.';
      _studyFriendList = [];

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> joinStudy(String nickname, int roomKey, String code) async { // 스터디 가입
    _isLoading = true;
    _resultMessage = '';
    notifyListeners();

    StudyJoinDto joinInfo = StudyJoinDto(roomKey: roomKey, code: code);
    StudyService studyService = StudyService();

    try {
      String response = await studyService.joinStudy(nickname, joinInfo);
      if (response == 'ok') {
        _resultMessage = '스터디 가입 성공!';
      } else if (response == 'noSheet') {
        _resultMessage = '인원이 모두 찼습니다.';
      } else if (response == 'codeError') {
        _resultMessage = '비밀번호가 틀렸습니다.';
      } else {
        _resultMessage = '가입 실패: 알 수 없는 오류';
      }
    } catch (e) {
      _resultMessage = '네트워크 오류: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



}
