import 'package:flutter/foundation.dart';
import '../models/find_study.dart';

class StudyViewModel with ChangeNotifier {
  StudyMakeDto? _studyMakeDto; // 스터디 만들 때 사용
  //region StudyMakeDto에 대한 게터 메소드, 스터디 생성
  StudyMakeDto? get studyMakeDto => _studyMakeDto;
  String get roomName => _studyMakeDto?.roomName ?? '';
  String get code => _studyMakeDto?.code ?? '';
  String get course => _studyMakeDto?.course ?? '';
  int get maxNum => _studyMakeDto?.maxNum ?? 0;
  String get studyIntroduction => _studyMakeDto?.studyIntroduction ?? '';
  String get leader => _studyMakeDto?.leader ?? '';
  String get startDate => _studyMakeDto?.startDate ?? '';
  bool get isOpen => _studyMakeDto?.isOpen ?? false;
  //endregion

  StudyInfoDto? _studyInfoDto; // 스터디  찾기 들어갔을 때 필요
  //region StudyInfoDto에 대한 게터 메소드, 스터디 찾기
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
  //endregion

  UserInfoMinimumDto? _userInfoMinimumDto;
  //region UserInfoMinimumDto에 대한 게터 메소드, 가입한 스터디 입장할 때
  UserInfoMinimumDto? get userInfoMinimumDto => _userInfoMinimumDto;
  String get nickname => _userInfoMinimumDto?.nickname ?? '';
  String get image => _userInfoMinimumDto?.image ?? '';
  //endregion

  StudyJoinDto? _studyJoinDto;
  //region StudyJoinDto 스터디 가입할 때
  StudyJoinDto? get studyJoinDto => _studyJoinDto;
  int get roomKey => _studyJoinDto?.roomKey ?? 15;
  String get joinCode => _studyJoinDto?.code ?? '';
  //endregion

  RoomStatusDto roomStatus = RoomStatusDto(isAll: true, isSeatLeft: false, isOpen: false);


  final StudyService _studyService = StudyService();

  String _resultMessage = '';

  String get resultMessage => _resultMessage;

  List<StudyInfoDto> _studyRoomlist = [];
  List<StudyInfoDto> get studyRoomlist => _studyRoomlist;

  List<UserInfoMinimumDto> _studyFriendList = []; // 유저 정보 가져옴
  List<UserInfoMinimumDto> get studyFriendList => _studyFriendList;

  String _joinResult = '';
  String get joinReslt => _joinResult;




  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StudyViewModel(
      {StudyMakeDto? studyMakeDto,
        StudyInfoDto? studyInfoDto,
        UserInfoMinimumDto? userInfoMinimumDto}) {
    _studyMakeDto = studyMakeDto ?? StudyMakeDto.defaultValues();
    _studyInfoDto = studyInfoDto ?? StudyInfoDto.defaultValues();
    _userInfoMinimumDto =
        userInfoMinimumDto ?? UserInfoMinimumDto.defaultValues();
  }


  List<MsgDto> messages = [];

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> makeStudyRoom(StudyMakeDto info) async {
    // 스터디 생성
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

  Future<void> getStudyRoomList(
      String nickname, RoomStatusDto roomStatus) async {
    // 스터디 찾기
    try {
      _isLoading = true;
      this.roomStatus = roomStatus;
      notifyListeners();

      _studyRoomlist =
          await _studyService.getStudyRoomList(nickname, roomStatus);
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

// 가입 스터디 입장
  Future<void> enterStudy(int roomKey, String nickname) async {
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

  Future<void> joinStudy(String nickname, int roomKey, String code) async {
    // 스터디 가입
    _isLoading = true;
    _resultMessage = '';
    notifyListeners();

    StudyJoinDto joinInfo = StudyJoinDto(roomKey: roomKey, code: code);

    try {
      String response = await _studyService.joinStudy(nickname, joinInfo);
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

  // 스터디 설정 변경
  Future<String> changeStudyInfo(int roomKey, StudyChangeDto info) async {
    isLoading = true;
    try {
      final result = await _studyService.changeStudyInfo(roomKey, info);
      isLoading = false;
      return result; // 'ok' 또는 'no'
    } catch (e) {
      isLoading = false;
      throw Exception('Failed to change study info: $e');
    }
  }

  // 그룹장 위임
  Future<void> commitLeader(int roomKey, String newLeader) async {
    isLoading = true;
    try {
      await _studyService.commitLeader(roomKey, newLeader);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      throw Exception('Failed to commit leader: $e');
    }
  }

  // 그룹 탈퇴
  Future<void> leaveStudy(int roomKey, String nickname) async {
    isLoading = true;
    try {
      await _studyService.leaveStudy(roomKey, nickname);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      throw Exception('Failed to leave study: $e');
    }
  }

  // 스터디방의 모든 메시지 가져오기
  Future<void> getAllMessages(int roomKey, String nickname) async {
    isLoading = true;
    try {
      messages = await _studyService.getAllMessages(roomKey, nickname);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      throw Exception('Failed to get messages: $e');
    }
  }

  // 스터디방에서 메시지 보내기
  Future<void> sendMessage(StudySendMsgDto sendMessage) async {
    try {
      await _studyService.sendMessage(sendMessage);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // 메시지 동기화
  Future<void> syncMessages(int roomKey, String nickname) async {
    try {
      List<MsgDto> newMessages =
          await _studyService.syncMessages(roomKey, nickname);
      if (newMessages.isNotEmpty) {
        messages.addAll(newMessages);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to sync messages: $e');
    }
  }

  // 스터디방 채팅에서 나가기
  Future<void> exitChat(int roomKey, String nickname) async {
    try {
      await _studyService.exitChat(roomKey, nickname);
    } catch (e) {
      throw Exception('Failed to exit chat: $e');
    }
  }
}
