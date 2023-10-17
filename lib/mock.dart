import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void startMockServer() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  server.listen((HttpRequest request) async {
    if (request.uri.path == '/api/data') {
      final response = {
        'name': 'John Doe',
        'age': 30,
      };

      request.response
        ..headers.contentType = ContentType.json
        ..write(json.encode(response))
        ..close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
    }
  });

  print('Mock server started on port: ${server.port}');
}

void main() async {
  startMockServer();

  // 예시로 클라이언트 요청
  final response = await http.get(Uri.parse('http://localhost:8080/api/data'));
  print('Client received: ${response.body}');
}