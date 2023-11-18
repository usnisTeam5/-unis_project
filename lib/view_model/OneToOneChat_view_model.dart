import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data'; // Uint8List에 대한 임포트
import 'dart:ui'; // Image에 대한 임포트
import 'package:flutter/material.dart';
import 'package:unis_project/models/OneToOneChat_model.dart';


class OneToOneChatViewModel extends ChangeNotifier {

  Uint8List _friendProfileImage = Uint8List(0);
  Uint8List get friendProfileImage => _friendProfileImage;
  String _myNickname = "";
  String _friendNickname = "";

  String get myNickname => _myNickname;
  set myNickname(String nickname) {
    _myNickname = nickname;
  }

  String get friendNickname => _friendNickname;

  set friendNickname(String nickname) {
    _friendNickname = nickname;
  }
  bool _isLoading = false;
  List<MsgDto> messages = [];


  bool get isLoading => _isLoading;

  Future<void> loadProfileImage(String nickname) async { // 상대방 이미지를 가져옴
    try {
      //_isLoading = true;
      //notifyListeners(); // Notify listeners to show a loading indicator
      // Fetch the profile image
      _friendProfileImage = await OneToOneChatModel.getProfileImage(nickname);
      // If successful, notify listeners to update the UI
      //notifyListeners();
    } catch (e) {
      // Handle any errors here
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners(); // Hide loading indicator
    }
  }

  Future<void> getAllMsg(String myNickname, String friendNickname) async { // 채팅창을 눌렀을 때 채팅창의 정보를 불러오는 기능
    try {
      //print("444");
      _isLoading = true;
      notifyListeners();

      messages = await OneToOneChatModel.getAllMsg(myNickname, friendNickname);

      _myNickname = myNickname;
      _friendNickname = friendNickname;
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      print("chatMsg viewmodel 에러");
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }


  Future<void> sendMsg(String sender, String receiver, String type, String msg, Uint8List img, String time) async {
    try {
      //print("sendMsgview $img");
      await OneToOneChatModel.sendMsg(sender, receiver, type, msg, img, time);
        //await getMsg(sender, receiver);
       // notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }


  Future<void> getMsg(String myNickname, String friendNickname) async {
    try {
        List<MsgDto> temp = await OneToOneChatModel.getMsg(
            myNickname, friendNickname);
        if(temp.isNotEmpty) {
          messages.addAll(temp); // message에  추가함.
          //print(messages);
          //print("Messages list hashCode: ${messages.hashCode}");
          notifyListeners();
        }
      //}
    } catch (e) { // 에러나도 상관 x
      print("GET MSG 에러");
      //_isLoading = false;
      notifyListeners();
      throw e;
    }
  }


  Future<void> outChat(String myNickname, String friendNickname) async {
    try {
      await OneToOneChatModel.outChat(myNickname, friendNickname);
      notifyListeners();
    } catch (e) {
      print("OUT CHAT 에러");
      throw e;
    }
  }
}


