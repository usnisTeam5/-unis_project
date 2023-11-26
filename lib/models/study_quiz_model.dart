import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'url.dart'; // BASE_URL이 정의된 파일

class StudyApiService {
  // 폴더 목록을 가져오는 메소드
  Future<List<StudyQuizListDto>> getFolderList(int roomKey) async {
    final response = await http.get(Uri.parse('$BASE_URL/study/folder/list?roomKey=$roomKey'));

    print(response.body); // 응답 로그

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => StudyQuizListDto.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load folder list');
    }
  }

  // 폴더 생성 메소드
  Future<void> makeFolder(int roomKey, String folderName) async {
    final response = await http.post(Uri.parse('$BASE_URL/study/folder/$roomKey/$folderName'));

    print(response.body); // 응답 로그

    if (response.statusCode != 200) {
      throw Exception('Failed to make folder');
    }
  }

  // 등록된 유저들을 가져오는 메소드
  Future<List<String>> getEnrollUserList(int roomKey, int folderKey) async {
    final response = await http.get(Uri.parse('$BASE_URL/study/$roomKey/$folderKey'));

    print(response.body); // 응답 로그

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load enroll user list');
    }
  }

// 폴더에서 사용자와 PDF 내용을 삭제하는 함수
  Future<void> deleteUserInFolder(int roomKey, int folderKey, String nickname) async {
    final url = Uri.parse('$BASE_URL/study/$roomKey/$folderKey?nickname=$nickname');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body); // 서버 응답 로그

    // 응답 처리
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user from folder');
    }
    // 성공적인 경우 특별한 처리가 필요 없을 수 있습니다.
  }
  // 파일 등록 메소드
  Future<String> enrollFile(int roomKey, int folderKey, String nickname, File file) async {
    var uri = Uri.parse('$BASE_URL/study/enroll/File/$roomKey/$folderKey/$nickname');
    var request = http.MultipartRequest('POST', uri);

    // 파일을 MultipartFile로 변환
    var multipartFile = await http.MultipartFile.fromPath(
      'file', // 'file'은 서버에서 기대하는 필드 이름입니다.
      file.path,
      contentType: MediaType('application', 'pdf'), // 파일 타입 설정 (PDF로 가정)
    );

    // 요청에 파일 추가
    request.files.add(multipartFile);

    // 요청 전송 및 응답 받기
    var response = await request.send();

    // 응답 처리
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to enroll file');
    }
  }

  // 퀴즈 생성 메소드
  Future<List<QuizDto>> getQuiz(StudyQuizInfoDto info) async {
    // StreamedRequest 객체를 생성하고, 메서드와 URI를 지정합니다.
    final request = http.StreamedRequest(
      'GET',
      Uri.parse('$BASE_URL/study/quiz'),
    );

    // 필요한 헤더를 추가합니다.
    request.headers['Content-Type'] = 'application/json';

    // 요청 본문에 데이터를 추가합니다.
    //request.sink.add(utf8.encode(jsonEncode(info.toJson())));
    request.sink.close();

    // 요청을 보냅니다.
    final streamedResponse = await request.send();

    // 스트림 응답을 Response 객체로 변환합니다.
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);

    // 응답 처리
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => QuizDto.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load quiz');
    }
  }
}


// StudyQuizListDto(폴더 목록을 가져올 때 사용 )
class StudyQuizListDto {
  final int folderKey;
  final String folderName;

  StudyQuizListDto({required this.folderKey, required this.folderName});

  factory StudyQuizListDto.fromJson(Map<String, dynamic> json) {
    return StudyQuizListDto(
      folderKey: json['folderKey'],
      folderName: json['folderName'],
    );
  }
}

// StudyQuizInfoDto ( //서버에 보내는 값) //퀴즈를 생성할 때 보냄
class StudyQuizInfoDto {
  final int roomKey;
  final int folderKey;
  final int quizNum;

  StudyQuizInfoDto({required this.roomKey, required this.folderKey, required this.quizNum});
}

// QuizDto 모델( 서버가 보내는 값) // 퀴즈를 생성해서 받아올 때
class QuizDto {
  final int quizNum;
  final String question;
  final String answer;

  QuizDto({required this.quizNum, required this.question, required this.answer});

  factory QuizDto.fromJson(Map<String, dynamic> json) {
    return QuizDto(
      quizNum: json['quizNum'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
