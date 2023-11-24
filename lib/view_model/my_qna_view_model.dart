import 'package:flutter/foundation.dart';
import '../models/my_qna_model.dart';

class MyQnAViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  // 로딩 상태를 나타내는 변수
  bool _isLoading = false;
  // 외부에서 로딩 상태를 읽을 수 있도록 getter 제공
  bool get isLoading => _isLoading;
  // 로딩 상태 업데이트 메서드
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<QaListDto> askList = [];
  List<QaListDto> answerList = [];
  List<QaMsgDto> qaMessages = [];
  double userReview = 0;

  // 아래의 메서드들은 예시로 제공됩니다.
  // 각 메서드에서 로딩 상태를 업데이트하는 로직을 추가합니다.

  Future<void> fetchAskList(String nickname) async {
    setLoading(true);
    try {
      askList = await _userService.getAskList(nickname);
      print("viewModel : ${askList[0].status}");
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAnswerList(String nickname) async {
    setLoading(true);
    try {
      answerList = await _userService.getAnswerList(nickname);
      //print("viewModel ANswer : ${answerList[0].course}");
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchQaMessages(int qaKey) async {
    setLoading(true);
    try {
      qaMessages = await _userService.getQaMessages(qaKey);
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchUserReview(String nickname) async {
    setLoading(true);
    try {
      userReview = await _userService.getUserReview(nickname);
    } finally {
      setLoading(false);
    }
  }
}
