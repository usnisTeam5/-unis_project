import 'package:http/http.dart' as http;
import 'dart:convert';
class SubjectSearch {
  final String _baseUrl = "http://3.35.21.123:8080"; // API의 기본 URL

  // 키워드를 사용하여 학과를 검색하는 메소드
  Future<List<String>> findSubject(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/find/course?keyword=$keyword"),
      );

      if (response.statusCode == 200) { // HTTP 상태 코드가 200(정상)일 경우, JSON 데이터를 Dart의 List<String>로 디코딩합니다.
        return List<String>.from(json.decode(response.body));
      } else { // 서버에서 정상적인 상태 코드가 아닌 것을 반환한 경우, 예외를 발생시킵니다.
        print("Server returned status code: ${response.statusCode}");
        return [
          '컴퓨터와 휴먼1',
          '인공지능과 윤리2',
          '빅데이터 분석3',
          '휴먼인터페이스미디어와 마법의 돌과 죄수4',
          '컴퓨터와 휴먼5',
          '인공지능과 윤리6',
          '빅데이터 분석7',
          '휴먼인터페이스미디어와 마법의 돌과 죄수8',
          '컴퓨터와 휴먼9',
          '인공지능과 윤리10',
          '빅데이터 분석11',
          '휴먼인터페이스미디어12',
        ];
        //throw Exception("Failed to load department data with status code: ${response.statusCode}");
      }
    } catch (e) { // 요청 중 에러가 발생하면 이곳에서 예외를 처리합니다.
      //print(e.toString()); // 콘솔에 에러 메시지를 출력합니다. 실제 앱에서는 이 부분을 적절히 처리해야 합니다.
      print("Error occurred: ${e.toString()}");
      return [
        '컴퓨터와 휴먼1',
        '인공지능과 윤리2',
        '빅데이터 분석3',
        '휴먼인터페이스미디어와 마법의 돌과 죄수4',
        '컴퓨터와 휴먼5',
        '인공지능과 윤리6',
        '빅데이터 분석7',
        '휴먼인터페이스미디어와 마법의 돌과 죄수8',
        '컴퓨터와 휴먼9',
        '인공지능과 윤리10',
        '빅데이터 분석11',
        '휴먼인터페이스미디어12',
      ];
      //throw Exception("Failed to load department data");
    }
  }
}
