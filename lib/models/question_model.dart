import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'url.dart'; // BASE_URL이 정의된 파일

// DTO 클래스 정의
//서버에서 보내는 값 리스트를 보냄
class QaBriefDto {
  final int qaKey;
  final String type;
  final String course;
  final int point;

  QaBriefDto(
      {required this.qaKey, required this.type, required this.course, required this.point});

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
  String time;
  final bool isAnonymity;

  QaMsgDto(
      {required this.nickname, required this.type, required this.msg, required this.img, required this.time, required this.isAnonymity});

  factory QaMsgDto.fromJson(Map<String, dynamic> json) {
    return QaMsgDto(
      nickname: json['nickname'],
      type: json['type'],
      msg: json['msg'],
      img: json['img'],
      time: _formatTime(json['time']),
      isAnonymity: json['isAnonymity'],
    );
  }

  static String _formatTime(String timeStr) {
    if(timeStr.length < 8) return timeStr;
    DateTime time = DateTime.parse(timeStr);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
// 메시지 보낼 때 씀
class QaSendMsgDto {
  final String nickname;
  final String type;
  final String msg;
  final String img;
  final String time;

  QaSendMsgDto(
      {required this.nickname, required this.type, required this.msg, required this.img, required this.time});

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
    final response = await http.get(
        Uri.parse('$BASE_URL/qa?nickname=$nickname'));
    print(response.body); // 응답 내용 출력
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaBriefDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load QA list');
    }
  }

  // 특정 QA를 답변하려고 선택했을 때,질문자가 올린 질문의 메시지를 가져오는 함수
  Future<List<QaMsgDto>> getQuestion(int qaKey, String nickname) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/qa/pick?qaKey=$qaKey&nickname=$nickname'));

    print("getQuestion모델: ${response.body}"); // 응답 내용 출력

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load question');
    }
  }

  // QA를 포기하는 함수
  Future<void> qaGiveUp(int qaKey, String nickname) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/giveup'),
        body: {'qaKey': qaKey.toString(), 'nickname': nickname});
    print(response.body); // 응답 내용 출력
  }

  // QA에 대한 답변을 선택하는 함수
  Future<void> qaSolve(int qaKey) async {
    final response = await http.post(Uri.parse('$BASE_URL/qa/answer/$qaKey'));
    print(response.body); // 응답 내용 출력
  }


  // 처음에 모두 가져오는 함수
  Future<List<QaMsgDto>> getAllMsg(int qaKey) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/user/qa?qaKey=$qaKey'));

    print("getAllQuestion모델: ${response.body}"); // 응답 내용 출력

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load question');
    }
  }
  // QA 채팅 메시지를 보내는 함수
  Future<void> sendQaMsg(int qaKey, String nickname, String type, String msg,
      Uint8List img, String time) async {
    final String base64Image = base64Encode(img);

    final QaSendMsgDto sendMsg = QaSendMsgDto(nickname: nickname,
        type: type,
        msg: msg,
        img: base64Image,
        time: time);

    final response = await http.post(
        Uri.parse('$BASE_URL/qa/chat/$qaKey'),
        body: json.encode(sendMsg.toJson()),
        headers: {'Content-Type': 'application/json'});
    print(response.body); // 응답 내용 출력

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  // QA 채팅 내용을 갱신하는 함수
  Future<List<QaMsgDto>> getQaMsgs(int qaKey, String nickname) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/qa/chat?qaKey=$qaKey&nickname=$nickname'));
    print(response.body); // 응답 내용 출력
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => QaMsgDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load QA messages');
    }
  }

  // solver가 답변하기를 선택한 시간을 얻는 함수
  Future<DateTime> getRemainingTime(int qaKey) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/qa/time?qaKey=$qaKey'));
    if (response.statusCode == 200) {
      int epochTimeInSeconds = json.decode(utf8.decode(response.bodyBytes));
      DateTime solverTime = DateTime.fromMillisecondsSinceEpoch(
          epochTimeInSeconds * 1000);
      DateTime endTime = solverTime.add(const Duration(hours: 24));

      return endTime; // 끝나는 시간 반환
    } else {
      throw Exception('Failed to get remaining time');
    }
  }

  // 시간 제한이 다 되어서 QA가 끝날 때 처리하는 함수
  Future<void> qaFinish(int qaKey, int review) async {
    final response = await http.post(
        Uri.parse('$BASE_URL/qa/finish?qaKey=$qaKey&review=$review'));
    print(response.body); // 응답 내용 출력
  }

  static Future<Uint8List> getProfileImage(String nickname) async {
    // 이미지를 가져옴.
    final response = await http.get(
        Uri.parse('$BASE_URL/user/profile/image?nickname=$nickname'));

    if (response.statusCode == 200) {
      if(response.body == null){
        return File('image/unis.png').readAsBytesSync();
      }
      return base64Decode(response.body);
    } else {
      throw Exception('Failed to load profile image');
    }
  }

  static Future<String> deleteQa(int qaKey) async {
    // Qa 삭제
    final response = await http.post(
      Uri.parse('$BASE_URL/user/qa/delete?qaKey=$qaKey'),
    );

    print('deleteQa Response: ${response.body}'); // Response body 출력

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete QA');
    }
  }

  Future<bool> isReview(int qaKey) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/qa/isReview?qaKey=$qaKey'),
    );
    print("isReview Model : ${response.body}");
    bool isReviewed = json.decode(response.body);
    if (response.statusCode == 200) {
      // 서버가 OK 응답을 반환하면, 응답에서 boolean 값을 파싱합니다.
      return isReviewed;
    } else {
      // 요청이 실패한 경우 예외를 발생시킵니다.
      throw Exception('Failed to load review status');
    }
  }

  Future<String> getQaStatus(int qaKey) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/qa/status?qaKey=$qaKey'),
    );
    print("getQaStatus Model : ${response.body}");
    if (response.statusCode == 200) {
      String status = response.body;
      // 서버가 OK 응답을 반환하면, 응답에서 문자열 값을 반환합니다.
      return status;
    } else {
      // 요청이 실패한 경우 예외를 발생시킵니다.
      throw Exception('Failed to load QA status');
    }
  }

  // QA가 현재 관찰되고 있는지 확인하는 메소드
  Future<bool> isQaWatching(int qaKey) async {
    // API 엔드포인트 URL을 구성합니다.
    final url = Uri.parse('$BASE_URL/qa/isWatching?qaKey=$qaKey');

    // HTTP GET 요청을 보냅니다.
    final response = await http.get(url);

    // 응답을 출력합니다.
    print(response.body);

    // 응답이 성공적인지 확인합니다.
    if (response.statusCode == 200) {
      // 응답 본문을 디코드하여 결과를 반환합니다.
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      // 에러가 발생하면 예외를 발생시킵니다.
      throw Exception('Failed to load isWatching');
    }
  }
}
