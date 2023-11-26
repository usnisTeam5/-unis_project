import 'package:flutter/foundation.dart';
import 'package:unis_project/notifier/notifier.dart'; // ChatService를 정의한 경로
import 'package:unis_project/models/chatRecord_model.dart'; // ChatListDto를 정의한 경로

// ChatListViewModel 클래스는 ChangeNotifier를 확장하여 
// Provider 패턴을 사용할 수 있게 함.
class ChatListViewModel with ChangeNotifier {
  // 로딩 상태를 추적하는 플래그
  bool _isLoading = false;
  // 채팅 목록을 저장하는 리스트
  List<ChatListDto> _chatList = [];

  // 외부에서 접근 가능한 로딩 상태 getter
  bool get isLoading => _isLoading;
  // 외부에서 접근 가능한 채팅 목록 getter
  List<ChatListDto> get chatList => _chatList;

  // 로딩 상태를 설정하고 UI를 업데이트하기 위해 리스너들에게 통지
  set isLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 사용자의 채팅 목록을 가져오는 메서드
  Future<void> fetchChatList(String nickname) async {
    isLoading = true; // 로딩 시작
    try {
      _chatList = await ChatService().fetchChatList(nickname);
    } catch (e) {
      // 에러 발생시 콘솔에 출력
      print('ViewModel에서 채팅 목록을 가져오는 중 오류 발생: $e');
      // 에러 처리 로직을 추가할 수 있음
    } finally {
      isLoading = false; // 로딩 완료
    }
  }

// ViewModel 내 다른 메서드들...
}
