class Quiz {
  final int quizNum;
  final String quiz;
  final String answer;

  Quiz({required this.quizNum, required this.quiz, required this.answer});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizNum: json['quizNum'],
      quiz: json['quiz'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizNum': quizNum,
      'quiz': quiz,
      'answer': answer,
    };
  }

  static List<Quiz> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Quiz.fromJson(json)).toList();
  }
}
