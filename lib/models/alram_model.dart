// Importing necessary packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Replace with your own url.dart file path
import '../models/url.dart';

// Model class to hold API response data
class QaAlarmDto {
  final String nickname;
  final int qaKey;
  final String course;

  QaAlarmDto({required this.nickname, required this.qaKey, required this.course});

  // Factory constructor to create a QaAlarmDto from JSON
  factory QaAlarmDto.fromJson(Map<String, dynamic> json) {
    return QaAlarmDto(
      nickname: json['nickname'],
      qaKey: json['qaKey'],
      course: json['course'],
    );
  }
}

Future<int> main() async {
  await getQaAlarm("별뚜기");
  return 0;
}
// Function to fetch alarm data from server
Future<List<QaAlarmDto>> getQaAlarm(String nickname) async {

  // Constructing the URL with query parameter
  final url = Uri.parse('$BASE_URL/qa/alarm?nickname=$nickname');

  // Sending GET request to the server with the nickname parameter
  final response = await http.get(url);

  // Printing the response body for debugging purposes
  print(response.body);
  // Decoding response body into JSON format
  if (response.statusCode == 200) {
    if(response.body.isEmpty){
      return [];
    }
    List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
    return jsonList.map((json) => QaAlarmDto.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw HttpException(
      'Failed to load alarm data with status code: ${response.statusCode}',
    );
  }
}

