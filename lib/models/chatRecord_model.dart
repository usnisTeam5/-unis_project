import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url.dart';


class ChatListDto {
  final String nickname; // 상대방 닉네임
  String time; // 메세지 날짜
  final String? msg; // 가장 마지막에 나눴던 대화, 이미지일 경우 null
  final bool alarm; // 상대방한테서 온 메세지가 있는지 여부

  ChatListDto({
    required this.nickname,
    required this.time,
    this.msg,
    required this.alarm,
  });

  factory ChatListDto.fromJson(Map<String, dynamic> json) {
    return ChatListDto(
      nickname: json['nickname'],
      time: json['time'],
      msg: json['msg'] ?? "이미지",
      alarm: json['alarm'],
    );
  }
}




class ChatService {
  // 사용자 닉네임을 기반으로 채팅 목록을 가져오는 메서드
  Future<List<ChatListDto>> fetchChatList(String nickname) async {
    final url = Uri.parse('$BASE_URL/chat/list?nickname=$nickname');
    List<ChatListDto> chatList = [];

    try {
      final response = await http.get(
          url,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        // UTF-8로 디코드한 후 JSON으로 파싱합니다.
        Iterable l = json.decode(utf8.decode(response.bodyBytes));
        // ChatListDto 리스트로 변환합니다.
        chatList = List<ChatListDto>.from(l.map((model) => ChatListDto.fromJson(model)));

        print(response.body); // 응답 본문을 출력합니다.
      } else {
        // 서버에서 비정상적인 응답이 올 경우 에러를 던집니다.
        throw Exception('Failed to load chat list');
      }
    } catch (e) {
      // 네트워크 요청 중 에러가 발생한 경우 에러를 던집니다.
      throw Exception('Error fetching chat list: $e');
    }

    return chatList;
  }
}


