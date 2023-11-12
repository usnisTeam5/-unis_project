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

  Future<List<MsgDto>> getAllMessages(String nickname1, String nickname2) async {
    final response = await http.get(
      Uri.parse('http://3.35.21.123:8080/chat?nickname1=$nickname1&nickname2=$nickname2'),
    ); //nickname1이 유저 닉네임, nickname2가 상대방 닉네임

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<MsgDto> messages = data.map((item) {
        return MsgDto.fromJson(item);
      }).toList();

      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String sender, String receiver, String type, String msg, String img, String time) async {
    final SendMsgDto sendMsg = SendMsgDto(
      sender: sender,
      receiver: receiver,
      type: type,
      msg: msg,
      img: img,
      time: time,
    );

    final response = await http.post(
      Uri.parse('http://3.35.21.123:8080/chat/sendMsg'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(sendMsg.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  Future<List<MsgDto>> getChatMessages(String nickname1, String nickname2) async {
    final response = await http.get(
      Uri.parse('http://3.35.21.123:8080/chat/getMsg?nickname1=$nickname1&nickname2=$nickname2'),
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

  Future<void> leaveChat(String nickname1, String nickname2) async {
    final ChatMemberDto chatMember = ChatMemberDto(
      nickname1: nickname1,
      nickname2: nickname2,
    );

    final response = await http.post(
      Uri.parse('http://3.35.21.123:8080/chat/outChat'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(chatMember.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to leave chat');
    }
  }
}