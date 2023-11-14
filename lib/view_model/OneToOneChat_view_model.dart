import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data'; // Uint8List에 대한 임포트
import 'dart:ui'; // Image에 대한 임포트
import 'package:flutter/material.dart';
import 'package:unis_project/models/OneToOneChat_model.dart';


class OneToOneChatViewModel extends ChangeNotifier {

  String _myNickname = "";
  String _friendNickname = "";
  String get myNickname => _myNickname;
  String get friendNickname => _friendNickname;

  MsgDto? _chatMsg = MsgDto.defaultValues();
  SendMsgDto? _chatSendMsg= SendMsgDto.defaultValues();
  ChatMemberDto? _chatMember = ChatMemberDto.defaultValues();

  bool _isLoading = false;
  List<MsgDto> messages = [];



  MsgDto? get chatMsg => _chatMsg ;
  SendMsgDto? get chatSendMsg => _chatSendMsg ;
  ChatMemberDto? get chatMember => _chatMember ;


  String get nickname => _chatMsg!.nickname ?? "";
  String get profileImage => _chatMsg!.profileImage ?? 'image/unis.png';
  String get type => _chatMsg!.type ?? "";
  String get msg => _chatMsg!.msg ?? "";
  String get image => _chatMsg!.image ?? "";
  String get time => _chatMsg!.time ?? "";

  String get sender => _chatSendMsg!.sender ?? "";
  String get receiver => _chatSendMsg!.receiver ?? '';
  String get sendtype => _chatSendMsg!.type ?? "";
  String get sendmsg => _chatSendMsg!.msg ?? "";
  String get img => _chatSendMsg!.img ?? "";
  String get sendtime => _chatSendMsg!.time ?? "";

  String get nickname1 => _chatMember!.nickname1 ?? "";
  String get nickname2 => _chatMember!.nickname2 ?? '';

  bool get isLoading => _isLoading;







  Future<void> getAllMsg(String myNickname, String friendNickname) async { // 채팅창을 눌렀을 때 채팅창의 정보를 불러오는 기능
    try {
      _isLoading = true;
      notifyListeners();

      _chatMsg = (await OneToOneChatModel.getAllMsg(myNickname, friendNickname)) as MsgDto?;

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




  Future<void> sendMsg(String sender, String receiver, String type, String msg, String img, String time) async {
    try {
      await OneToOneChatModel.sendMsg(sender, receiver, type, msg, img, time);
        await getAllMsg(sender, receiver);
        notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }



  Future<void> getMsg(String myNickname, String friendNickname) async {
    try {
      _isLoading = true;
      notifyListeners();

      messages = await OneToOneChatModel.getMsg(myNickname, friendNickname);

      _myNickname = myNickname;
      _friendNickname = friendNickname;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("GET MSG 에러");
      _isLoading = false;
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


