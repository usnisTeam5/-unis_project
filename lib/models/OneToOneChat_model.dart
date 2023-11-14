import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'url.dart';

import 'dart:io';
import 'dart:ui';




class MsgDto {
  final String nickname;
  final String profileImage;
  final String type;
  final String msg;
  final String image;
  final String time;

  MsgDto.defaultValues() :
        nickname = '',
        profileImage = 'image/unis.png',
        type = '',
        msg = '',
        image = '',
        time = '';

  MsgDto({
    required this.nickname,
    required this.profileImage,
    required this.type,
    required this.msg,
    required this.image,
    required this.time,
  });

  factory MsgDto.fromJson(Map<String, dynamic> json) {
    return MsgDto(
      nickname: json['nickname'],
      profileImage: json['profileImage'],
      type: json['type'],
      msg: json['msg'],
      image: json['image'],
      time: _formatTime(json['time']),
    );
  }

  static String _formatTime(String timeStr) {
    DateTime time = DateTime.parse(timeStr);
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}






class SendMsgDto {
  final String sender;
  final String receiver;
  final String type;
  final String msg;
  final String img;
  final String time;

  SendMsgDto.defaultValues() :
        sender = '',
        receiver = '',
        type = '',
        msg = '',
        img = '',
        time = '';

  SendMsgDto({
    required this.sender,
    required this.receiver,
    required this.type,
    required this.msg,
    required this.img,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'type': type,
      'msg': msg,
      'img': img,
      'time': time,
    };
  }
}




class ChatMemberDto {
  final String nickname1;
  final String nickname2;

  ChatMemberDto.defaultValues() :
        nickname1 = '',
        nickname2 = '';

  ChatMemberDto({
    required this.nickname1,
    required this.nickname2,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname1': nickname1,
      'nickname2': nickname2,
    };
  }
}





class OneToOneChatModel {




  static Future<List<MsgDto>> getAllMsg(String myNickname, String friendNickname) async {
    final response = await http.get(
      Uri.parse('/chat?nickname1=$myNickname&nickname2=$friendNickname'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<MsgDto> messages = data.map((item) {
        return MsgDto.fromJson(item);
      }).toList();
      return messages; // 메시지 목록 반환
    } else {
      throw Exception('Failed to load messages');
    }
  }






  static Future<void> sendMsg(String sender, String receiver, String sendtype, String sendmsg, String img, String sendtime) async { // 메세지 보내기
    final SendMsgDto sendMsg = SendMsgDto(
      sender: sender,
      receiver: receiver,
      type: sendtype,
      msg: sendmsg,
      img: img,
      time: sendtime,
    );

    final url = Uri.parse('/chat/sendMsg');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json',},
      body: json.encode(sendMsg.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }




  static Future<List<MsgDto>> getMsg(String myNickname, String friendNickname) async { // 메세지 받아오기, MsgDto
    final response = await http.get(
      Uri.parse('/chat/getMsg?nickname1=$myNickname&nickname2=$friendNickname'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<MsgDto> messages = data.map((item) {
        return MsgDto.fromJson(item);
      }).toList();

      return messages;
    } else {
      throw Exception('Failed to load chat messages');
    }
  }




  static Future<void> outChat(String myNickname, String friendNickname) async { // 채팅방 나가기, ChatMemberDto
    final ChatMemberDto chatMember = ChatMemberDto(
      nickname1: myNickname,
      nickname2: friendNickname,
    );

    final url = Uri.parse('/chat/outChat');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json',},
      body: json.encode(chatMember.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to leave chat');
    }
  }


}