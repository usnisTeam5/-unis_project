import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';
class DepartmentSearch {
  //final String _baseUrl = "http://3.35.21.123:8080";

  Future<List<String>> findDepartment(String deptName) async {
    try {
      final response = await http.get(
        Uri.parse("$BASE_URL/find/department?dept_name=${deptName}"),
      );

      if (response.statusCode == 200) {
        // 서버로부터 받은 응답의 바디를 UTF-8로 디코드합니다.
        final decodedBody = utf8.decode(response.bodyBytes);
        // 디코드된 문자열을 JSON 형태로 파싱하고 List<String>으로 변환합니다.
        return List<String>.from(json.decode(decodedBody));
      } else {
        // 서버에서 200이 아닌 다른 HTTP 상태 코드를 반환한 경우
        print("Server returned status code: ${response.statusCode}");
        throw Exception("Failed to load department data with status code: ${response.statusCode}");
      }
    } catch (e) {
      // 네트워크 요청 중에 오류가 발생한 경우
      print("Error occurred: ${e.toString()}");
      throw Exception("Failed to load department data");
    }
  }
}
