// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class MsgDto { // 보낼 때 받을 때 사용함
//   final String nickname;
//   final String type; // img or str
//   final String msg;
//   final String image;
//   final String time;
//
//   MsgDto.defaultValues() :
//         nickname = '',
//         type = 'text',
//         msg = '',
//         image = '',
//         time = '2023-11-14 13:09:03.479785';
//
//   MsgDto({
//     required this.nickname,
//     required this.type,
//     required this.msg,
//     required this.image,
//     required this.time,
//   });
//
//   factory MsgDto.fromJson(Map<String, dynamic> json) {
//     return MsgDto(
//       nickname: json['nickname'],
//       type: json['type'],
//       msg: json['msg'],
//       image: json['image'],
//       time: _formatTime(json['time']),
//     );
//   }
//
//   static String _formatTime(String timeStr) {
//     if(timeStr.length < 8) return timeStr;
//     DateTime time = DateTime.parse(timeStr);
//     return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
//   }
// }
//
// class QaDto {
//   final String type; // Advice or problem
//   final String course;
//   final int point;
//   final String nickname; // Person who posted the question
//   final bool isAnonymity; // Whether the question is posted anonymously
//   final List<MsgDto> msg; // Messages containing question chat content
//
//   QaDto({
//     required this.type,
//     required this.course,
//     required this.point,
//     required this.nickname,
//     required this.isAnonymity,
//     required this.msg,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'course': course,
//       'point': point,
//       'nickname': nickname,
//       'isAnonymity': isAnonymity,
//       'msg': msg.map((message) => message.toJson()).toList(),
//     };
//   }
// }
//
// class QaService {
//   static const String BASE_URL = 'your_api_base_url_here'; // Replace with your API base URL
//
//   static Future<List<String>> getUserCourse(String nickname) async {
//     final response = await http.get(
//       Uri.parse('$BASE_URL/user/profile/course?nickname=$nickname'),
//     );
//     if (response.statusCode == 200) {
//       return List<String>.from(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load user course');
//     }
//   }
//
//   static Future<void> enrollQuestion(QaDto question) async {
//     final url = Uri.parse('$BASE_URL/qa');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(question.toJson()),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to enroll question');
//     }
//   }
//
//   static Future<String> deleteQa(int qaKey) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/user/qa/delete'),
//       body: {'qaKey': qaKey.toString()},
//     );
//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('Failed to delete QA');
//     }
//   }
// }
