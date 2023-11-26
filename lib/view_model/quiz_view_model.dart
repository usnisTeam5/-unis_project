import 'package:flutter/foundation.dart';
import '../models/quiz_model.dart'; // QuizInfoDto, QuizDto, QuizMakeDto가 정의된 파일

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  bool _isLoading = false;

  // 외부에서 로딩 상태를 읽을 수 있도록 getter 제공
  bool get isLoading => _isLoading;

  // 로딩 상태 업데이트 메서드
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<QuizInfoDto> folderList = []; // // QuizInfoDto 모델(퀴즈 탭에서 과목을 선택했을 때 폴더 리스트)
  List<QuizDto> quizQuestions = []; // QuizDto 모델(퀴즈를 선택했을 때, 문제수, 문제,정답 리스트 반환)
  List<String> courses = [];
  // 유저의 수강 과목 리스트 가져오기
  Future<void> fetchUserCourses(String nickname) async {
    setLoading(true);
    try {
      // UserService의 메서드를 사용하여 데이터 가져오기
      courses = await _quizService.getUserCourses(nickname);
      // 데이터 처리 로직 (예: quizList 업데이트)
      // quizList = courses; // 예시
    } catch (e) {
      // 에러 처리
      print('Error loading courses: $e');
    } finally {
      setLoading(false);
    }
  }

  // 특정 과목에 대한 퀴즈 리스트 가져오기
  Future<void> fetchMyQuiz(String nickname, String course) async {
    setLoading(true);
    try {
      folderList = await _quizService.getMyQuiz(nickname, course);
    } catch (e) {
      // 에러 처리
      print('Error loading quizzes: $e');
    } finally {
      setLoading(false);
    }
  }

  // 퀴즈 문제들 가져오기
  Future<void> fetchQuiz(int quizKey) async {
    setLoading(true);
    try {
      quizQuestions = await _quizService.getQuiz(quizKey);
    } catch (e) {
      // 에러 처리
      print('Error loading quiz questions: $e');
    } finally {
      setLoading(false);
    }
  }

  // 새로운 퀴즈 폴더 만들기
  Future<void> createQuizFolder(QuizMakeDto quiz) async {
    setLoading(true);
    try {
      await _quizService.makeQuizFolder(quiz);
      folderList = await _quizService.getMyQuiz(quiz.nickname, quiz.course);
      // 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // 에러 처리
      print('Error creating quiz folder: $e');
    } finally {
      setLoading(false);
    }
  }

  // 문제 생성 또는 수정
  Future<void> updateQuiz(int quizKey, List<QuizDto> quiz) async {
    setLoading(true);
    try {
      await _quizService.makeQuiz(quizKey, quiz);
      // 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // 에러 처리
      print('Error updating quiz: $e');
    } finally {
      setLoading(false);
    }
  }

  // 퀴즈 종료
  Future<void> finishQuiz(int quizKey, int curNum) async {
    setLoading(true);
    try {
      await _quizService.finishQuiz(quizKey, curNum);
      // 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // 에러 처리
      print('Error finishing quiz: $e');
    } finally {
      setLoading(false);
    }
  }
}
