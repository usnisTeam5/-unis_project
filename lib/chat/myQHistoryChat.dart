/*
내 문답(질답완료 상태)
 */
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:unis_project/chat/ChatShare.dart';
import 'package:unis_project/login/login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    return MaterialApp(
      home: MyQHistoryChatScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class MyQHistoryChatScreen extends StatefulWidget {
  @override
  _MyQHistoryChatScreenState createState() => _MyQHistoryChatScreenState();
}

class _MyQHistoryChatScreenState extends State<MyQHistoryChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  List<Message> _messages = [];
  bool _isMine = false;
  DateTime _time = DateTime.now().add(Duration(minutes: 20));

  int messageSendCount = 0;
  int showProfile = 1;

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
      // _scrollToBottom();
    });
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
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 55,
        leadingWidth: 105,
        leading: Padding(
          padding: EdgeInsets.only(right: 50.0),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          '과목명',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.grey,
              size: 24,
            ),
            onPressed: () {
              // ChatShare 화면 열기
              _showShareDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool shouldDisplayHeader = showProfile == 1 &&
                      (index == 0 ||
                          _messages[index - 1].sender != message.sender);
                  final bool shouldDisplayTime = (index ==
                      _messages.length - 1 ||
                      _messages[index + 1].sender != message.sender);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: message.isMine
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!message.isMine && shouldDisplayHeader)
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    message.senderImageURL),
                                radius: 15,
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: message.isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!message.isMine && shouldDisplayHeader)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, bottom: 7),
                                  child: Text(
                                    message.senderName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: message.isMine
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (message.isMine)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 20.0),
                                      child: shouldDisplayTime
                                          ? Text(
                                        "${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Round',
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      )
                                          : Container(),
                                    ),
                                  Container( // 메시지 여백
                                    constraints: BoxConstraints(
                                        maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                    margin: EdgeInsets.only(
                                      left: message.isMine
                                          ? 0
                                          : (shouldDisplayHeader
                                          ? (showProfile == 1 ? 8.0 : 4.0)
                                          : (showProfile == 0 ? 0 : 39.0)),
                                      top: message.isMine ? 0 : 0,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: message.isMine
                                          ? Colors.lightBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: message.text != null
                                        ? Text(
                                      message.text!,
                                      style: TextStyle(
                                        color: message.isMine
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Round',
                                      ),
                                    )
                                        : message.imagePath != null
                                        ? Image.file(
                                      File(message.imagePath!),
                                      width: 150,
                                      fit: BoxFit.cover,
                                    )
                                        : SizedBox(),
                                  ),
                                  if (!message.isMine)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 20.0),
                                      child: shouldDisplayTime
                                          ? Text(
                                        "${message.sentAt.hour}:${message.sentAt.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Round',
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      )
                                          : Container(),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showShareDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ChatShare();
    },
  );
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
