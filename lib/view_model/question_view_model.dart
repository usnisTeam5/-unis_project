import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../models/question_model.dart';

class QaViewModel extends ChangeNotifier {
  final QaService _qaService = QaService();
  bool _isLoading = false;
  List<QaBriefDto> qaList = []; // 리스트
  List<QaMsgDto> qaMessages = []; // 메시지 내용
  String questioner = ''; // 질문자 이름 ( 나일 수도 있고 상대방일 수도 있음)
  bool isQuestioner = true;
  Uint8List _friendProfileImage = Uint8List(0);
  Uint8List get friendProfileImage => _friendProfileImage;
  String _friendNickname = "";
  String get friendNickname => _friendNickname;
  bool get isLoading => _isLoading;
  late DateTime time;
  // 이 변수는 API로부터 리뷰 상태가 있는지 여부를 나타냅니다.
  bool _isReviewed = false;
  bool get isReviewed => _isReviewed;
  bool isAnonymity = false;
  // 이 변수는 API로부터 받아온 QA 상태를 저장합니다.
  String qaStatus = '진행';
  bool checker = false;
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
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

  // 특정 QA의 메시지를 가져오는 함수. 이건 처음 질문 들어갈 때 필요함. 나눈 대화 가져오는건 따로 있음.
  Future<void> fetchQaMessages(int qaKey, String nickname) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("Hello");
      qaMessages = await _qaService.getQuestion(qaKey, nickname);
      print("뷰모델 fetchQa M : ${qaMessages[0].nickname}");
      questioner = qaMessages[0].nickname;
      isAnonymity = qaMessages[0].isAnonymity;
      if(questioner == nickname){
        isQuestioner = true;
        for(int i=0; i <qaMessages.length ; i ++){
          if(qaMessages[i].nickname != nickname){
            _friendNickname = qaMessages[i].nickname; // 상대방 이름
            break;
          }
        }
      } else {
        isQuestioner = false;
        _friendNickname = questioner; // 상대방 이름
      }
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


  Future<void> fetchAllMsg(int qaKey, String nickname) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("Hello");
      qaMessages = await _qaService.getAllMsg(qaKey);
      time =  await _qaService.getRemainingTime(qaKey);
      print("뷰모델 fetchQa M : ${qaMessages[0].nickname}");
      questioner = qaMessages[0].nickname;
      isAnonymity = qaMessages[0].isAnonymity;

      if(questioner == nickname){
        isQuestioner = true;
        for(int i=0; i <qaMessages.length ; i ++){
          if(qaMessages[i].nickname != nickname){
            _friendNickname = qaMessages[i].nickname; // 상대방 이름
            break;
          }
        }
      } else {
        isQuestioner = false;
        _friendNickname = questioner; // 상대방 이름
      }
    } catch (e) {
      // 에러 처리
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // QA 채팅 메시지 전송 함수
  Future<void> sendQaMessage(int qaKey, String nickname, String type, String msg, Uint8List img, String time) async {

    try {
      await _qaService.sendQaMsg(qaKey, nickname, type, msg, img, time);
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }
 // 메시지 답변하기 전에 리스트로 보관하던거 한꺼번에 보냄
  Future<void> sendQaMessageList(int qaKey, List<QaMsgDto> messages) async {

    //int qaKey,   String nickname,   String type,   String msg,   Uint8List img,   String time,
    try {
      for(int i=0;i<messages.length;i++) {
        String nickname = messages[i].nickname;
        String type = messages[i].type;
        String msg = messages[i].msg;
        Uint8List img = base64Decode(messages[i].img);
        String time = messages[i].time;
        await _qaService.sendQaMsg(qaKey, nickname, type, msg, img,  time);
      }
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }
  // QA 채팅 내용 갱신 함수
  Future<void> refreshQaMessages(int qaKey, String nickname, int k, BuildContext context, ) async {
    try {

      List<QaMsgDto> temp= await _qaService.getQaMsgs(qaKey, nickname);
      if(qaStatus == '미답' && temp.isNotEmpty && isQuestioner){

        if(temp[0].nickname != questioner){
          checker = true;
          // _friendNickname = temp[0].nickname; // 상대방 이름
          // _friendProfileImage = await QaService.getProfileImage(_friendNickname);
        }
      }
      if(temp.isNotEmpty && k == 1) { // 비어있지 않은 경우
        qaMessages.addAll(temp); // message에  추가함.
        notifyListeners();
      }
    } catch (e) {
      print("GET MSG 에러");
      //_isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  // solver가 답변하기를 선택한 시간을 얻는 함수
  Future<void> getAnswerTime(int qaKey) async {
    try {
      time =  await _qaService.getRemainingTime(qaKey);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      rethrow;
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

  Future<void> loadProfileImage(String nickname) async { // 상대방 이미지를 가져옴
    try {
      _isLoading = true;
      notifyListeners(); // Hide loading indicator
      Uint8List? temp = await QaService.getProfileImage(nickname);
      _friendProfileImage = temp ??  File('image/unis.png').readAsBytesSync();

    } catch (e) {
      // Handle any errors here
      notifyListeners();
    } finally {
      _isLoading = false;
       notifyListeners(); // Hide loading indicator
    }
  }

  Future<String> deleteQa(int qaKey) async { // 삭제함
    setLoading(true);
    try {
      String ans = await QaService.deleteQa(qaKey);
      setLoading(false);
      return ans; // no or ok;
      // 추가적인 성공 처리 (예: 사용자에게 알림)
    } catch (e) {
      // Error handling
      print('Error deleting QA: $e');
      setLoading(false);
      return "no";
    }
  }

  // isReview 상태를 확인하는 함수
  Future<void> checkIsReview(int qaKey) async {
    try {
      final bool reviewStatus = await _qaService.isReview(qaKey);
      _isReviewed = reviewStatus;
    } catch (e) {
      // 에러 처리
      print('Error checking review status: $e');
    }
  }

  // QA 상태를 가져오는 함수
  Future<void> fetchQaStatus(int qaKey) async {
    try {
      final String status = await _qaService.getQaStatus(qaKey);
      final temp = qaStatus;
      qaStatus = status;
      if(temp != status) notifyListeners();
    } catch (e) {
      // 에러 처리
      print('Error fetching QA status: $e');
    } finally {
    }
  }

  // 해당 QA가 관찰되고 있는지 확인하는 메서드
  Future<bool> isQaWatching(int qaKey) async {
    //setLoading(true);
    try {
      bool isWatching = await _qaService.isQaWatching(qaKey);
      //setLoading(false);
      return isWatching;
    } catch (e) {
      //setLoading(false);
      print('Error while checking QA watching status: $e');
      return false; // 오류 발생 시 기본적으로 '관찰되지 않음' 상태 반환
    }
  }



  void addMsg(QaMsgDto temp) async {

    temp.time = _formatTime(temp.time);
    qaMessages.add(temp); // message에  추가함.
    notifyListeners();
  }
  static String _formatTime(String timeStr) {
    if(timeStr.length < 8) return timeStr;
    DateTime time = DateTime.parse(timeStr);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
