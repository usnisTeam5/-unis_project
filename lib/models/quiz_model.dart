import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart'; // BASE_URL 정의 파일

// QuizInfoDto 모델(퀴즈 탭에서 과목을 선택했을 때 폴더 리스트)
class QuizInfoDto {
  int quizKey;
  String quizName;
  int quizNum;
  int curNum;

  QuizInfoDto({
    required this.quizKey,
    required this.quizName,
    required this.quizNum,
    required this.curNum,
  });

  factory QuizInfoDto.fromJson(Map<String, dynamic> json) {
    return QuizInfoDto(
      quizKey: json['quizKey'],
      quizName: json['quizName'],
      quizNum: json['quizNum'],
      curNum: json['curNum'],
    );
  }
}

// QuizDto 모델(퀴즈를 선택했을 때, 문제 번호, 문제,정답 리스트 반환)
class QuizDto {
  int quizNum; // 문제 번호
  String question; // 문제 내용
  String answer; // 정답
  bool isSolved; //현재 풀고 있는 중인지

  QuizDto({
    required this.quizNum, // 문제 번호
    required this.question,
    required this.answer,
    required this.isSolved,
  });

  factory QuizDto.fromJson(Map<String, dynamic> json) {
    return QuizDto(
      quizNum: json['quizNum'],
      question: json['question'],
      answer: json['answer'],
        isSolved: json['isSolved'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'quizNum': quizNum,
      'question': question,
      'answer': answer,
      'isSolved': isSolved
    };
  }
}

// QuizMakeDto 모델(새로운 폴더 생성)
class QuizMakeDto {
  String nickname;
  String quizName;
  String course;

  QuizMakeDto({
    required this.nickname,
    required this.quizName,
    required this.course,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'quizName': quizName,
      'course': course,
    };
  }
}


class QuizService {
  // 유저의 수강 과목 리스트 가져오기
  Future<List<String>> getUserCourses(String nickname) async {
    final url = Uri.parse('$BASE_URL/user/profile/course?nickname=$nickname');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load courses');
    }
  }

  // 특정 과목에 대한 퀴즈 리스트 가져오기
  Future<List<QuizInfoDto>> getMyQuiz(String nickname, String course) async {
    final url = Uri.parse('$BASE_URL/user/quiz?nickname=$nickname&course=$course');
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      Iterable l = json.decode(utf8.decode(response.bodyBytes));
      return List<QuizInfoDto>.from(l.map((model) => QuizInfoDto.fromJson(model)));
    } else {
      throw Exception('Failed to get quiz');
    }
  }

  // 퀴즈 문제들 가져오기
  Future<List<QuizDto>> getQuiz(int quizKey) async {
    final url = Uri.parse('$BASE_URL/user/quiz/solve?quizKey=$quizKey');
    final response = await http.get(url);
    //print("response : ${response.body}");
    if (response.statusCode == 200) {
      Iterable l = json.decode(utf8.decode(response.bodyBytes));
      List<QuizDto> temp = List<QuizDto>.from(l.map((model) => QuizDto.fromJson(model)));
      print(temp);
      return temp;
    } else {
      throw Exception('Failed to get quiz questions');
    }
  }

  // 새로운 퀴즈 폴더 만들기
  Future<void> makeQuizFolder(QuizMakeDto quiz) async {
    final url = Uri.parse('$BASE_URL/user/quiz/makeFolder');
    final response = await http.post(
        url,
        body: json.encode(quiz.toJson()),
        headers: {'Content-Type': 'application/json'}
    );
    print("makeQuizFolder : ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to make quiz folder');
    }
  }

  // 문제 생성 또는 수정
  Future<void> makeQuiz(int quizKey, List<QuizDto> quiz) async {
    for (int i = quiz.length - 1; i >= 0; i--) { // 역순으로 순회하며 삭제
      if (quiz[i].quizNum > 1000) {
        quiz.removeAt(i);
      }
    }
    final url = Uri.parse('$BASE_URL/user/makeQuiz/$quizKey');
    final response = await http.post(url,
        body: json.encode(List<dynamic>.from(quiz.map((x) => x.toJson()))),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to make or update quiz');
    }
  }


  // 퀴즈 종료
  Future<void> finishQuiz(int quizKey, int curNum) async {
    final url = Uri.parse('$BASE_URL/user/quiz/finish/$quizKey');
    final response = await http.post(url, body: json.encode({'curNum': curNum}), headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to finish quiz');
    }
  }

  // 퀴즈 폴더 삭제 메서드
  Future<void> deleteQuizFolder(int quizKey) async {
    // API 엔드포인트 구성
    final url = Uri.parse('$BASE_URL/user/quiz/delete/$quizKey');

    // HTTP POST 요청 실행
    final response = await http.post(url);

    // 응답 처리
    if (response.statusCode == 200) {
      print('Quiz folder deleted successfully.');
      print(response.body); // 응답 본문 출력
    } else {
      throw Exception('Failed to delete quiz folder.');
    }
  }
}
