import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart'; // BASE_URL 정의 파일

// QuizInfoDto 모델
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

// QuizDto 모델
class QuizDto {
  int quizNum;
  String question;
  String answer;

  QuizDto({
    required this.quizNum,
    required this.question,
    required this.answer,
  });

  factory QuizDto.fromJson(Map<String, dynamic> json) {
    return QuizDto(
      quizNum: json['quizNum'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}

// QuizMakeDto 모델
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
