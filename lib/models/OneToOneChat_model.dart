import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'url.dart';

import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';


class MsgDto { // 보낼 때 받을 때 사용함
  final String nickname;
  //final String profileImage;
  final String type; // img or str
  final String msg;
  final String image;
  final String time;

  MsgDto.defaultValues() :
        nickname = '',
        //profileImage = 'image/unis.png',
        type = 'text',
        msg = '',
        image = '',
        time = '2023-11-14 13:09:03.479785';

  MsgDto({
    required this.nickname,
   // required this.profileImage,
    required this.type,
    required this.msg,
    required this.image,
    required this.time,
  });

  factory MsgDto.fromJson(Map<String, dynamic> json) {
    return MsgDto(
      nickname: json['nickname'],
      //profileImage: json['profileImage'],
      type: json['type'],
      msg: json['msg'],
      image: json['image'],
      time: _formatTime(json['time']),
    );
  }

  static String _formatTime(String timeStr) {
    if(timeStr.length < 8) return timeStr;
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
        type = 'text',
        msg = '',
        img = '',
        time = '2023-11-14 13:09:03.479785';

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

  static Future<Uint8List> getProfileImage(String nickname) async { // 이미지를 가져옴.
    final response = await http.get(Uri.parse('$BASE_URL/user/profile/image?nickname=$nickname'));

    if (response.statusCode == 200) {
      return  base64Decode(response.body);
    } else {
      throw Exception('Failed to load profile image');
    }
  }


  static Future<List<MsgDto>> getAllMsg(String myNickname, String friendNickname) async { // 이전에 있었던 모든 메시지를 받아옴.
    //print("111");
    final response = await http.get(
      Uri.parse('$BASE_URL/chat?nickname1=$myNickname&nickname2=$friendNickname'),
    );
    if (response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      //print("getAllMsg $data");
      final List<MsgDto> messages = data.map((item) {
        return MsgDto.fromJson(item);
      }).toList();

      return messages; // 메시지 목록 반환

    } else {
      throw Exception('Failed to load messages');
    }
  }






  static Future<void> sendMsg(String sender, String receiver, String sendtype, String sendmsg, Uint8List imgbytes, String sendtime) async { // 메세지 보내기
    final String base64Image = base64Encode(imgbytes);

    final SendMsgDto sendMsg = SendMsgDto(
      sender: sender,
      receiver: receiver,
      type: sendtype,
      msg: sendmsg,
      img: base64Image,
      time: sendtime,
    );

    final url = Uri.parse('$BASE_URL/chat/sendMsg');

    final response = await http.post(url,
      headers: {'Content-Type': 'application/json',},
      body: json.encode(sendMsg.toJson()),
    );

    print(" asdasdas ${response.statusCode}");
    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }




  static Future<List<MsgDto>> getMsg(String myNickname, String friendNickname) async { // 메세지 받아오기, MsgDto
      final response = await http.get(
        Uri.parse(
            '$BASE_URL/chat/getMsg?nickname1=$myNickname&nickname2=$friendNickname'),
      );
      //print(response.body);
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(milliseconds: 300));
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print("getMsewrwerwerg ${data}");
        if (data.isEmpty) {
          return [];
        }
        print("getMsg ${data}");
        final List<MsgDto> messages = data.map((item) { //
          return MsgDto.fromJson(item);
        }).toList();
        return messages;
      }
      else {
        throw Exception('Failed to load chat messages');
      }
  }//



  static Future<void> outChat(String myNickname, String friendNickname) async { // 채팅방 나가기, ChatMemberDto
    final ChatMemberDto chatMember = ChatMemberDto(
      nickname1: myNickname,
      nickname2: friendNickname,
    );

    final url = Uri.parse('$BASE_URL/chat/outChat');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json',},
      body: json.encode(chatMember.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to leave chat');
    }
  }


}