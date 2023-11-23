import 'package:http/http.dart' as http;
import 'dart:convert';

class MsgDto { // 보낼 때 받을 때 사용함
  final String nickname;
  final String type; // img or str
  final String msg;
  final String image;
  String time;

  MsgDto.defaultValues() :
        nickname = '',
        type = 'text',
        msg = '',
        image = '',
        time = '2023-11-14 13:09:03.479785';

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

  static String _formatTime(String timeStr) {
    if(timeStr.length < 8) return timeStr;
    DateTime time = DateTime.parse(timeStr);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}"; // 시간 형식
  }

  Map<String, dynamic> toJson() { // 저장할 때는, 실제 시간을 저장하고 보여줄 때만 시간 포맷에 맞게 변형한다.
    return {
      'nickname': nickname,
      'type': type,
      'msg': msg,
      'image': image,
      'time': time,
    };
  }
}

class QaDto { // 등록하기 누르면 서버에 보낼 정보
  final String type; // Advice or problem
  final String course;
  final int point;
  final String nickname; // Person who posted the question
  final bool isAnonymity; // Whether the question is posted anonymously
  final List<MsgDto> msg; // Messages containing question chat content

  QaDto({
    required this.type,
    required this.course,
    required this.point,
    required this.nickname,
    required this.isAnonymity,
    required this.msg,
  });

  Map<String, dynamic> toJson() {  // Qa 등록할 때 보낼 정보.
    return {
      'type': type,
      'course': course,
      'point': point,
      'nickname': nickname,
      'isAnonymity': isAnonymity,
      'msg': msg.map((message) => message.toJson()).toList(),
    };
  }
}

class QaService {
  static const String BASE_URL = 'your_api_base_url_here'; // Replace with your API base URL

  static Future<List<String>> getUserCourse(String nickname) async { // 유저 Course 받아옴
    final response = await http.get(
      Uri.parse('$BASE_URL/user/profile/course?nickname=$nickname'),
    );

    print('getUserCourse Response: ${response.body}'); // Response body 출력

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load user course');
    }
  }

  static Future<void> enrollQuestion(QaDto question) async { // 퀴즈 등록하기 버튼 누르면 하는행위 ( 후에 퀴즈 등록수 받아오는걸로 수정)
    final url = Uri.parse('$BASE_URL/qa');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(question.toJson()),
    );

    print('enrollQuestion Response: ${response.body}'); // Response body 출력

    if (response.statusCode != 200) {
      throw Exception('Failed to enroll question');
    }
  }

  static Future<String> deleteQa(int qaKey) async { // Qa 삭제
    final response = await http.post(
      Uri.parse('$BASE_URL/user/qa/delete'),
      body: {'qaKey': qaKey.toString()},
    );

    print('deleteQa Response: ${response.body}'); // Response body 출력

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete QA');
    }
  }
}

