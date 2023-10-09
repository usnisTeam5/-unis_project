import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:unis_project/css/css.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/countdown.dart';
import 'package:unis_project/chat/image_picker_popup.dart';
import 'package:unis_project/question/post_settings.dart';
import 'package:unis_project/question/question.dart';

import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../profile/friend.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
    return MaterialApp(
      home: PostQuestionPage(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}







class PostQuestionPage extends StatefulWidget {
  @override
  _PostQuestionPageState createState() => _PostQuestionPageState();
}


class _PostQuestionPageState extends State<PostQuestionPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _isMine = false;
  DateTime _time = DateTime.now().add(Duration(minutes: 20));


  void _onImagePicked(String imagePath) {
    setState(() {
      _messages.add(Message(
        imagePath: imagePath,
        sender: 'YourName',
        isMine: true,
        senderImageURL: "your_image_url",
        senderName: 'YourName',
        sentAt: DateTime.now(),
      ));
    });
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportPopup(),
    );
  }


  int messageSendCount = 0;

  void _sendMessage(String text, String sender, bool isMine) {
    if (text.isEmpty) { // 메시지 입력 안 하면 팝업
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('질문을 입력해주세요'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      messageSendCount++;
      _messages.add(Message(
        text: text,
        sender: sender,
        isMine: isMine,
        senderImageURL: "your_image_url",
        senderName: sender,
        sentAt: DateTime.now(),
      ));
      _messageController.clear();
    });
    _scrollToBottom();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add(Message(
          text: '자동 응답: $text',
          sender: '봇',
          isMine: false,
          senderImageURL: "bot_image_url",
          senderName: '봇',
          sentAt: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });

    if (messageSendCount == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('질문이 제출되었습니다'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, size: 35, color: Colors.grey,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('알림'),
                    content: Text('질문하기를 포기하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('아니오'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('예'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/favoritesList',
                arguments: MyListScreenArguments(1), // 1은 '찜' 탭의 인덱스
              );
            },
            icon: Icon(Icons.favorite, color: Colors.red), // 찜 목록
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PostSettings(hasUserSentMessage: true);
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
              decoration: BoxDecoration(
                gradient: MainGradient(),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '금액 설정',
                style: TextStyle(
                  fontFamily: 'ExtraBold',
                  color: Colors.white,
                  fontSize: width *0.04,
                ),
              ),
            ),
          )
        ],
      ),


      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Countdown(
                    endTime: _time,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (message.isMine) // 내 메시지
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, right: 3.0),
                            child: Text(
                              "${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Round',
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7),
                          decoration: BoxDecoration(
                            color: message.isMine ? Colors.lightBlue : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: message.text != null
                              ? Text(
                            message.text!,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: message.isMine ? Colors.white : Colors.grey[700], fontFamily: 'Round'),
                          )
                              : message.imagePath != null
                              ? Image.file(
                            File(message.imagePath!),
                            width: 150,
                            fit: BoxFit.cover,
                          )
                              : SizedBox(),
                        ),
                        if (!message.isMine) // 상대방 메시지
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 3.0),
                            child: Text(
                              "${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Round',
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.warning_amber_rounded),
                    color: Colors.grey,
                    iconSize: 30,
                    onPressed: _showReportDialog,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded),
                    color: Colors.grey,
                    iconSize: 30,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ImagePickerPopup(onImagePicked: _onImagePicked);
                        },
                      );
                    },
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                                maxHeight: MediaQuery.of(context).size.height * 0.7),
                            height: 40,
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: '메시지를 입력하세요',
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              _isMine = !_isMine;
                              _sendMessage(_messageController.text, "", true); // "MyName" 비워둠
                              _messageController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String? text;
  final String? imagePath;
  final String sender;
  final bool isMine;
  final String senderImageURL;
  final String senderName;
  final DateTime sentAt;

  Message({
    this.text,
    this.imagePath,
    required this.sender,
    required this.isMine,
    required this.senderImageURL,
    required this.senderName,
    required this.sentAt,
  });
}
