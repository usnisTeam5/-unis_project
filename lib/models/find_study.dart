import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';

class StudyInfoDto { // 스터디 찾기 들어갔을 때 필요
  int roomKey; // 스터디 고유키
  String roomName; // 스터디 제목
  String course; // 스터디 과목
  int maxNum; // 최대 인원수
  int curNum; // 현재 인원수
  String leader; // 스터디장 닉네임
  String startDate; // 시작일
  bool isOpen; // 공개 여부
  String studyIntroduction; // 스터디 소개글

  StudyInfoDto({
    required this.roomKey,
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.curNum,
    required this.leader,
    required this.startDate,
    required this.isOpen,
    required this.studyIntroduction,
  });

  StudyInfoDto.defaultValues()
      : roomKey = -5,
        roomName = '다트 프로그래밍 스터디',
        course = '모바일 앱 개발',
        maxNum = 5,
        curNum = 1,
        leader = 'abc',
        startDate = '2023-11-20',
        isOpen = true,
        studyIntroduction = '다트 언어 스터디 모집';

  factory StudyInfoDto.fromJson(Map<String, dynamic> json) {
    return StudyInfoDto(
      roomKey: json['roomKey'],
      roomName: json['roomName'],
      course: json['course'],
      maxNum: json['maxNum'],
      curNum: json['curNum'],
      leader: json['leader'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
      studyIntroduction: json['studyIntroduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomKey': roomKey,
      'roomName': roomName,
      'course': course,
      'maxNum': maxNum,
      'curNum': curNum,
      'leader': leader,
      'startDate': startDate,
      'isOpen': isOpen,
      'studyIntroduction': studyIntroduction,
    };
  }
} //스터디 찾기 들어갔을 때 필요 리스트 표현할 때 원소들

class RoomStatusDto { // 스터디 상태
  bool isAll;
  bool isSeatLeft;
  bool isOpen;

  RoomStatusDto({
    required this.isAll,
    required this.isSeatLeft,
    required this.isOpen,
  });

  factory RoomStatusDto.fromJson(Map<String, dynamic> json) {
    return RoomStatusDto(
      isAll: json['isAll'],
      isSeatLeft: json['isSeatLeft'],
      isOpen: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAll': isAll,
      'isSeatLeft': isSeatLeft,
      'isOpen': isOpen,
    };
  }
} // 스터디 상태. 이것도 마찬가지로 스터디 찾기 들어갔을 때 필요


class StudyJoinDto { // 스터디 가입
  int roomKey;
  String code;

  StudyJoinDto({
    required this.roomKey,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomKey': roomKey,
      'code': code,
    };
  }
} // 스터디 가입시 필요 보낼 때 사용


class StudyMakeDto { //  스터디 생성에서 넘기는 정보.
  String roomName; // 스터디 이름
  String? code; // 비밀번호(공개방이면 null 값)
  String course; // 과목
  int maxNum; // 최대인원
  String studyIntroduction; // 소개
  String leader; // 그룹장
  String startDate; // 시작일
  bool isOpen; // 공개 여부

  StudyMakeDto({
    required this.roomName,
    this.code,
    required this.course,
    required this.maxNum,
    required this.studyIntroduction,
    required this.leader,
    required this.startDate,
    required this.isOpen,
  });

  StudyMakeDto.defaultValues()
      : roomName = '다트 프로그래밍 스터디',
        code = '1234',
        course = '모바일 앱 개발',
        maxNum = 5,
        studyIntroduction = '다트 언어 스터디 모집',
        leader = 'abc',
        startDate = '2023-11-15',
        isOpen = true;

  factory StudyMakeDto.fromJson(Map<String, dynamic> json) {
    return StudyMakeDto(
      roomName: json['roomName'],
      code: json['code'],
      course: json['course'],
      maxNum: json['maxNum'],
      studyIntroduction: json['studyIntroduction'],
      leader: json['leader'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'code': code,
      'course': course,
      'maxNum': maxNum,
      'studyIntroduction': studyIntroduction,
      'leader': leader,
      'startDate': startDate,
      'isOpen': isOpen,
    };
  }
} // 스터디 생성할 때 백으로 넘기는 정보


class UserInfoMinimumDto { // 가입 스터디 입장 했을 때
  String nickname;
  String image;

  UserInfoMinimumDto({
    required this.nickname,
    required this.image,
  });

  UserInfoMinimumDto.defaultValues()
      : nickname = 'kakak',
        image = 'image/unis.png';

  factory UserInfoMinimumDto.fromJson(Map<String, dynamic> json) {
    return UserInfoMinimumDto(
      nickname: json['nickname'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'image': image,
    };
  }
} // 내 스터디 입장했을 때, 그룹원 리스트 불러옴.


class StudyChangeDto {
  String roomName;
  String course;
  int maxNum;
  bool isOpen;
  String code;
  String studyIntroduction;

  StudyChangeDto({
    required this.roomName,
    required this.course,
    required this.maxNum,
    required this.isOpen,
    required this.code,
    required this.studyIntroduction,
  });

  factory StudyChangeDto.fromJson(Map<String, dynamic> json) {
    return StudyChangeDto(
      roomName: json['roomName'],
      course: json['course'],
      maxNum: json['maxNum'],
      isOpen: json['isOpen'],
      code: json['code'],
      studyIntroduction: json['studyIntroduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'course': course,
      'maxNum': maxNum,
      'isOpen': isOpen,
      'code': code,
      'studyIntroduction': studyIntroduction,
    };
  }
} // 스터디 설정하기에서 쓸 DTO

class MsgDto {
  String nickname;
  String type; // 메세지 유형이 이미지인지 문자인지
  String msg;
  String image; // 이미지 파일을 base64로 인코딩한 문자열
  String time;

  MsgDto({
    required this.nickname,
    required this.type,
    required this.msg,
    required this.image,
    required this.time,
  });

  factory MsgDto.fromJson(Map<String, dynamic> json) {
    return MsgDto(
      nickname: json['nickname'],
      type: json['type'],
      msg: json['msg'],
      image: json['image'],
      time: _formatTime(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'type': type,
      'msg': msg,
      'image': image,
      'time': time,
    };
  }
  static String _formatTime(String timeStr) {
    if(timeStr.length < 8) return timeStr;
    DateTime time = DateTime.parse(timeStr);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
} // 스터디 메시지 받아올 때 쓸 DTO

class StudySendMsgDto {
  String sender;
  int roomKey;
  String type;
  String msg;
  String img;
  String time;

  StudySendMsgDto({
    required this.sender,
    required this.roomKey,
    required this.type,
    required this.msg,
    required this.img,
    required this.time,
  });

  factory StudySendMsgDto.fromJson(Map<String, dynamic> json) {
    return StudySendMsgDto(
      sender: json['sender'],
      roomKey: json['roomKey'],
      type: json['type'],
      msg: json['msg'],
      img: json['img'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'roomKey': roomKey,
      'type': type,
      'msg': msg,
      'img': img,
      'time': time,
    };
  }
} // 스터디 메시지 보낼 때 쓸 DTO

// API 요청 및 응답 처리 메서드


class StudyService {

  Future<List<StudyInfoDto>> getStudyRoomList(String nickname,
      RoomStatusDto roomStatus) async {
    // 스터디 찾기 // StreamedRequest 객체를 생성하고, 메서드와 URI를 지정합니다.
    final request = http.StreamedRequest(
      'GET',
      Uri.parse('$BASE_URL/study/$nickname'),
    );

    // 필요한 헤더를 추가합니다.
    request.headers['Content-Type'] = 'application/json';

    // 요청 본문에 데이터를 추가합니다.
    request.sink.add(utf8.encode(jsonEncode(roomStatus.toJson())));
    request.sink.close();

    // 요청을 보냅니다.
    final streamedResponse = await request.send();

    // 스트림 응답을 Response 객체로 변환합니다.
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    // *********************************
    if (response.statusCode == 200) {
      final List<dynamic> studyInfoJsonList = jsonDecode(
          utf8.decode(response.bodyBytes));
      print("스터디 찾기 모델 $studyInfoJsonList");
      return studyInfoJsonList.map((json) => StudyInfoDto.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load study rooms');
    }
  }


  Future<String> joinStudy(String nickname, StudyJoinDto joinInfo) async {
    // 스터디 가입
    final response = await http.post(
      Uri.parse('$BASE_URL/study/join/$nickname'),
      body: json.encode(joinInfo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);
    if (response.statusCode == 200) {
      print("스터디 가입 시도. 모델");
      return response.body; // 'noSheet', 'codeError', 'ok' 중 하나 반환

    } else {
      throw Exception('Failed to join study: ${response.body}');
    }
  }


  static Future<bool> makeStudyRoom(StudyMakeDto info) async {
    // 스터디 생성
    try {
      final response = await http.post(Uri.parse('$BASE_URL/study/make'),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(info.toJson()),
      );

      if (response.statusCode == 200) {
        final String result = response.body;
        return result == 'ok'; // API에서 'ok'을 리턴하면 스터디 생성 성공
      } else if (response.statusCode == 400) {
        final String result = response.body;
        return result == 'false'; // API에서 'false'를 리턴하면 중복된 방 이름이 있는 경우
      } else {
        throw Exception('Failed to make study: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to make study: $e');
    }
  }

  // 스터디 입장시
  Future<List<UserInfoMinimumDto>> enterStudy(int roomKey,
      String nickname) async {
    // 가입한 스터디 입장 했을 때
    final response = await http.get(
      Uri.parse('$BASE_URL/study/enter?roomKey=$roomKey&nickname=$nickname'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> enterStudyList = jsonDecode(
          utf8.decode(response.bodyBytes));
      print("가입 스터디 입장. 모델 $enterStudyList");
      return enterStudyList.map((json) => UserInfoMinimumDto.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load study friend list: ${response.body}');
    }
  }

  // 스터디 설정 변경
  Future<String> changeStudyInfo(int roomKey, StudyChangeDto info) async {
    final url = Uri.parse('$BASE_URL/study/change/$roomKey');
    final response = await http.post(
        url, body: json.encode(info.toJson()), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return response.body; // 'ok' 또는 'no'
    } else {
      throw Exception('Failed to change study info');
    }
  }

  // 그룹장 위임
  Future<void> commitLeader(int roomKey, String newLeader) async {
    final url = Uri.parse(
        '$BASE_URL/study/commitLeader/$roomKey?newLeader=$newLeader');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to commit leader');
    }
  }

  // 그룹 탈퇴
  Future<void> leaveStudy(int roomKey, String nickname) async {
    final url = Uri.parse('$BASE_URL/study/out/$nickname?roomKey=$roomKey');

    // 여기서는 별도의 헤더 설정이 필요하지 않습니다.
    final response = await http.post(url);

    print("모델: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to leave study');
    }
  }

  // 스터디방의 모든 메시지 가져오기
  Future<List<MsgDto>> getAllMessages(int roomKey, String nickname) async {
    final url = Uri.parse(
        '$BASE_URL/study/chat?roomKey=$roomKey&nickname=$nickname');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable l = json.decode(utf8.decode(response.bodyBytes));
      return List<MsgDto>.from(l.map((model) => MsgDto.fromJson(model)));
    } else {
      throw Exception('Failed to get messages');
    }
  }

  // 스터디방에서 메시지 보내기
  Future<void> sendMessage(StudySendMsgDto sendMessage) async {
    final url = Uri.parse('$BASE_URL/study/chat/sendMsg');
    final response = await http.post(
        url, body: json.encode(sendMessage.toJson()), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  // 메시지 동기화
  Future<List<MsgDto>> syncMessages(int roomKey, String nickname) async {
    final url = Uri.parse(
        '$BASE_URL/study/chat/getMsg?roomKey=$roomKey&nickname=$nickname');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable l = json.decode(utf8.decode(response.bodyBytes));
      return List<MsgDto>.from(l.map((model) => MsgDto.fromJson(model)));
    } else {
      throw Exception('No new messages');
    }
  }

  // 스터디방 채팅에서 나가기
  Future<void> exitChat(int roomKey, String nickname) async {
    final url = Uri.parse(
        '$BASE_URL/study/chat/outChat?roomKey=$roomKey&nickname=$nickname');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to exit chat');
    }
  }

// 스터디 방 코드를 가져오는 함수
  Future<String> getStudyCode(int roomKey) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/study/code?roomKey=$roomKey'),
    );
    // 요청이 성공했는지 확인
    if (response.statusCode == 200) {
      print(response.body); // 응답 바디를 출력
      // utf8로 디코드하고, json으로 디코드합니다

      //print(a);
      return response.body;
    } else {
      // 서버에서 오류 응답을 받았을 때 처리
      throw Exception('Failed to load study code');
    }
  }

  Future<String> getLeader(int roomKey) async {
    // GET 요청을 보냅니다.
    final response = await http.get(
      Uri.parse('$BASE_URL/study/leader?roomKey=$roomKey'),
    );

    // 요청이 성공했는지 확인합니다.
    if (response.statusCode == 200) {
      print(response.body); // 응답 바디를 출력합니다.

      // utf8로 디코드하고, json으로 디코드합니다.
      // 여기서는 응답이 단순 문자열로 가정합니다.
      return response.body;
    } else {
      // 서버에서 오류 응답을 받았을 때 처리합니다.
      throw Exception('Failed to load study leader');
    }
  }

}














