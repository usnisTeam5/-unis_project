import 'package:flutter/foundation.dart';
import '../models/quiz_model.dart'; // QuizInfoDto, QuizDto, QuizMakeDto가 정의된 파일

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  bool isLoading = false;

  // 외부에서 로딩 상태를 읽을 수 있도록 getter 제공
  //bool get isLoading => _isLoading;

  // 로딩 상태 업데이트 메서드
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
  String course = ''; // 현재 수강하고있는 과목
  int quizKey = -1; // 현재 보고있는 퀴즈 키
  QuizDto? folder;

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

  // 특정 과목에 대한 퀴즈 폴더리스트 가져오기
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
      print("Hello: ${quizQuestions[0].answer}");
    } catch (e) {
      // 에러 처리
      print('Error loading quiz questions: $e');
    } finally {
      print("Hello");
      setLoading(false);
    }
  }

  // 새로운 퀴즈 폴더 만들기
  Future<void> createQuizFolder(QuizMakeDto quiz) async {
    //setLoading(true);
    try {
      await _quizService.makeQuizFolder(quiz);
      folderList = await _quizService.getMyQuiz(quiz.nickname, quiz.course); //리스트를 다시 가져옴
      // 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // 에러 처리
      print('Error creating quiz folder: $e');
    } finally {
      //setLoading(false);
      notifyListeners();
    }
  }

  // 문제 생성 또는 수정
  Future<void> updateQuiz(int quizKey, List<QuizDto> quiz,) async {
   // setLoading(true);
    try {
      await _quizService.makeQuiz(quizKey, quiz);
      // 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // 에러 처리
      print('Error updating quiz: $e');
    } finally {
     // setLoading(false);
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


  // 문제 생성 또는 수정 메서드
  Future<void> deleteFolder(int quizKey) async {
    //setLoading(true); // 로딩 시작
    try {
      await _quizService.deleteQuizFolder(quizKey); // 서비스를 이용하여 API 호출
      for(int i= folderList.length -1 ; i >= 0 ;i--) {
        if(folderList[i].quizKey == quizKey){
          folderList.removeAt(i);
        }
      }
    } catch (e) {
      print('Error updating quiz: $e');
    } finally {
      //setLoading(false); // 로딩 종료
      notifyListeners();
    }
  }

  // 새로운 메서드: 서버에 퀴즈를 추가하는 함수
  Future<void> addQuiz(int quizKey, List<QuizDto> quiz) async {
    setLoading(true); // 로딩 상태를 true로 설정
    try {
      // QuizService의 addQuiz 함수를 사용하여 서버에 퀴즈 추가 요청
      await _quizService.addQuiz(quizKey, quiz);

      // 성공적으로 추가되면 사용자에게 알림을 보냄
      // (예: 상태 업데이트, UI에 메시지 표시 등)
    } catch (e) {
      // 에러 발생 시 처리
      print('Error adding quiz: $e');
    } finally {
      setLoading(false); // 로딩 상태를 false로 설정
    }
  }
}
