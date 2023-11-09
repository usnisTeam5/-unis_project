import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';
class SubjectSearch {
  //final String _baseUrl = "http://3.35.21.123:8080"; // API의 기본 URL

  // 키워드를 사용하여 학과를 검색하는 메소드
  Future<List<String>> findSubject(String keyword) async {
    try {
      // 쿼리 파라미터를 올바르게 인코딩합니다.
      final response = await http.get(
        Uri.parse("$BASE_URL/find/course?course=${keyword}"),
        // 요청 헤더에 UTF-8 인코딩을 명시합니다.
      );

      if (response.statusCode == 200) { // HTTP 상태 코드가 200(정상)일 경우
        // 응답 본문을 JSON으로 디코딩하고, Dart의 List<String>로 변환합니다.
        //print('Body: ${json.decode(utf8.decode(response.bodyBytes))}');
        return List<String>.from(json.decode(utf8.decode(response.bodyBytes)));


      } else { // 서버에서 정상적인 상태 코드가 아닌 것을 반환한 경우
        print("Server returned status code: ${response.statusCode}");
        return []; // 빈 리스트를 반환합니다.
      }
    } catch (e) { // 요청 중 에러가 발생하면 예외를 처리합니다.
      print("Error occurred: ${e.toString()}");
      return []; // 에러 발생 시 빈 리스트를 반환합니다.
    }
  }
}
