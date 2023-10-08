import 'dart:io';
import 'package:flutter/material.dart';

import 'package:unis_project/css/css.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/countdown.dart';
import 'image_picker_popup.dart';

import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

//import 'package:intl/intl.dart';
//import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: ChatScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _isMine = false;
  DateTime _time = DateTime.now().add(Duration(minutes: 20));

  // Future<void> _sendMessage(String message) async {
  //   // final response = await http.post(
  //   //   Uri.parse('https://your-backend-url.com/send-message'),
  //   //   body: {'message': message},
  //   // );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //   }
  // }

  /* Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: message, sender: 'yourUserName', isMine: true));
        _messageController.clear();
      });
    }
    // 서버로 보낼 메시지 전송 로직 추가
  } */



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
      // _scrollToBottom(); // If you have a scroll-to-bottom function
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
            content: Text('답변을 입력해주세요'),
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

    // 스크롤을 바닥으로 이동
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
      // 스크롤을 바닥으로 이동
      _scrollToBottom();
    });

    // 메시지가 최초로 보내졌을 때 팝업 표시
    if (messageSendCount == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('답변이 제출되었습니다'),
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






  Future<void> _fetchMessages() async {
  //   // final response = await http.get(
  //   //   Uri.parse('https://your-backend-url.com/fetch-messages'),
  //   // );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       _messages = List<String>.from(data['messages']);
  //     });
  //   }
   }

  @override
  // void initState() {
  //   super.initState();
  //
  //   Future.doWhile(() async {
  //     await Future.delayed(Duration(seconds: 5));
  //     await _fetchMessages();
  //     return true;
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 55,
        leadingWidth: 105,
        leading: Container(
          margin: EdgeInsets.all(10),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '포기하기',
              style: TextStyle(
                fontFamily: 'ExtraBold',
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
              backgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
          title: Center(
            child: Text(
              '과목명',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Bold'
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: MainGradient(),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isMine = !_isMine;
                    _sendMessage(_messageController.text, "", true); // myname
                    _messageController.clear();
                  });
                },
                child: Text(
                  '답변하기',
                  style: TextStyle(
                    fontFamily: 'ExtraBold',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                ),
              ),
            ),
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
  final String? text; // 텍스트 메시지 (이미지일 때 null)
  final String? imagePath; // 이미지 경로 (텍스트일 때 null)
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