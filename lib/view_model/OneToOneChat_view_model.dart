import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data'; // Uint8List에 대한 임포트
import 'dart:ui'; // Image에 대한 임포트
import 'package:flutter/material.dart';
import 'package:unis_project/models/OneToOneChat_model.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unis_project/models/OneToOneChat_model.dart';

class OneToOneChatViewModel extends ChangeNotifier {
  final OneToOneChatModel model;
  List<MsgDto> messages = [];

  OneToOneChatViewModel({required this.model});

  Future<void> fetchMessages(String nickname1, String nickname2) async {
    try {
      messages = await model.getAllMessages(nickname1, nickname2);
      notifyListeners(); // UI 업데이트를 위해 호출
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> sendMessage(String sender, String receiver, String type, String msg, String img, String time) async {
    try {
      await model.sendMessage(sender, receiver, type, msg, img, time);
      await fetchMessages(sender, receiver); // 메시지 목록 업데이트
      notifyListeners(); // UI 업데이트를 위해 호출
    } catch (e) {
      print('Error sending message: $e');
    }
  }




  Future<void> fetchAndSyncMessages(String nickname1, String nickname2) async {
    messages = await model.getChatMessages(nickname1, nickname2);
    notifyListeners();
  }

  Future<void> leaveChat(String nickname1, String nickname2) async {
    await model.leaveChat(nickname1, nickname2);
  }
}

