import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart'; // BASE_URL이 정의된 파일

// DTO 클래스 정의
//서버에서 보내는 값 리스트를 보냄
class QaBriefDto {
  final int qaKey;
  final String type;
  final String course;
  final int point;

  QaBriefDto({required this.qaKey, required this.type, required this.course, required this.point});

  factory QaBriefDto.fromJson(Map<String, dynamic> json) {
    return QaBriefDto(
      qaKey: json['qaKey'],
      type: json['type'],
      course: json['course'],
      point: json['point'],
    );
  }
}
// 메시지 받아올 때 씀
class QaMsgDto {
  final String nickname;
  final String type;
  final String msg;
  final String img;
  final String time;
  final bool isAnonymity;

  QaMsgDto({required this.nickname, required this.type, required this.msg, required this.img, required this.time, required this.isAnonymity});

  factory QaMsgDto.fromJson(Map<String, dynamic> json) {
    return QaMsgDto(
      nickname: json['nickname'],
      type: json['type'],
      msg: json['msg'],
      img: json['img'],
      time: json['time'],
      isAnonymity: json['isAnonymity'],
    );
  }
}
// 메시지 보낼 때 씀
class QaSendMsgDto {
  final String nickname;
  final String type;
  final String msg;
  final String img;
  final String time;

  QaSendMsgDto({required this.nickname, required this.type, required this.msg, required this.img, required this.time});

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'type': type,
      'msg': msg,
      'img': img,
      'time': time,
    };
  }
}

// 서비스 클래스 정의
class QaService {
  // 문답 리스트를 가져오는 함수
  Future<List<QaBriefDto>> getQaList(String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/qa?nickname=$nickname'));
    print(response.body); // 응답 내용 출력
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaBriefDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load QA list');
    }
  }

  // 특정 QA를 선택했을 때 해당 QA의 메시지를 가져오는 함수
  Future<List<QaMsgDto>> getQuestion(int qaKey, String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/qa/pick?qaKey=$qaKey&nickname=$nickname'));
    print(response.body); // 응답 내용 출력
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load question');
    }
  }

  // QA를 포기하는 함수
  Future<void> qaGiveUp(int qaKey, String nickname) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/giveup'), body: {'qaKey': qaKey.toString(), 'nickname': nickname});
    print(response.body); // 응답 내용 출력
  }

  // QA에 대한 답변을 선택하는 함수
  Future<void> qaSolve(int qaKey) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/answer/$qaKey'));
    print(response.body); // 응답 내용 출력
  }

  // QA 채팅 메시지를 보내는 함수
  Future<void> sendQaMsg(int qaKey, QaSendMsgDto msg) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/chat/$qaKey'), body: json.encode(msg.toJson()), headers: {'Content-Type': 'application/json'});
    print(response.body); // 응답 내용 출력
  }

  // QA 채팅 내용을 갱신하는 함수
  Future<List<QaMsgDto>> getQaMsgs(int qaKey, String nickname) async {
    final response = await http.get(Uri.parse('$BASE_URL/qa/chat?qaKey=$qaKey&nickname=$nickname'));
    print(response.body); // 응답 내용 출력
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load QA messages');
    }
  }

  // solver가 답변하기를 선택한 시간을 얻는 함수
  Future<Duration> getRemainingTime(int qaKey) async {
    final response = await http.get(Uri.parse('$BASE_URL/qa/time?qaKey=$qaKey'));
    if (response.statusCode == 200) {
      int epochTimeInSeconds = json.decode(utf8.decode(response.bodyBytes));
      DateTime solverTime = DateTime.fromMillisecondsSinceEpoch(epochTimeInSeconds * 1000);
      DateTime endTime = solverTime.add(const Duration(hours: 24));
      DateTime currentTime = DateTime.now();

      if (currentTime.isBefore(endTime)) {
        return endTime.difference(currentTime); // 남은 시간 반환
      } else {
        return Duration.zero; // 시간이 지났으면 0 반환
      }
    } else {
      throw Exception('Failed to get remaining time');
    }
  }

  // 시간 제한이 다 되어서 QA가 끝날 때 처리하는 함수
  Future<void> qaFinish(int qaKey, int review) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/finish?qaKey=$qaKey&review=$review'));
    print(response.body); // 응답 내용 출력
  }
}
