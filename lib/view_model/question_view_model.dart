import 'package:flutter/foundation.dart';
import '../models/question_model.dart';

class QaViewModel extends ChangeNotifier {
  final QaService _qaService = QaService();
  bool _isLoading = false;
  List<QaBriefDto> qaList = []; // 리스트
  List<QaMsgDto> qaMessages = []; // 메시지 내용

  bool get isLoading => _isLoading;

  // 문답 리스트를 가져오는 함수
  Future<void> fetchQaList(String nickname) async {
    _isLoading = true;
    notifyListeners();
    try {
      qaList = await _qaService.getQaList(nickname);
    } catch (e) {
      // 에러 처리
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 QA의 메시지를 가져오는 함수
  Future<void> fetchQaMessages(int qaKey, String nickname) async {
    _isLoading = true;
    notifyListeners();
    try {
      qaMessages = await _qaService.getQuestion(qaKey, nickname);
    } catch (e) {
      // 에러 처리
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // QA 포기 함수
  Future<void> giveUpQa(int qaKey, String nickname) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _qaService.qaGiveUp(qaKey, nickname);
    } catch (e) {
      // 에러 처리
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // QA 답변 선택 함수
  Future<void> solveQa(int qaKey) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _qaService.qaSolve(qaKey);
    } catch (e) {
      // 에러 처리
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // QA 채팅 메시지 전송 함수
  Future<void> sendQaMessage(int qaKey, QaSendMsgDto message) async {
    try {
      await _qaService.sendQaMsg(qaKey, message);
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }

  // QA 채팅 내용 갱신 함수
  Future<void> refreshQaMessages(int qaKey, String nickname) async {
    try {
      qaMessages = await _qaService.getQaMsgs(qaKey, nickname);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }

  // solver가 답변하기를 선택한 시간을 얻는 함수
  Future<Duration> getAnswerTime(int qaKey) async {
    try {
      return await _qaService.getRemainingTime(qaKey);
    } catch (e) {
      // 에러 처리
      print(e);
      return const Duration();
    }
  }

  // QA 종료 처리 함수
  Future<void> finishQa(int qaKey, int review) async {
    try {
      await _qaService.qaFinish(qaKey, review);
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }
}
