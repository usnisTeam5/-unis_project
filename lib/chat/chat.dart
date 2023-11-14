import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:unis_project/css/css.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/countdown.dart';
import 'package:unis_project/chat/popupReview.dart';
import 'package:unis_project/chat/chatShare.dart';
import 'image_picker_popup.dart';

import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import 'myQHistoryChat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

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

  DateTime _time = DateTime.now().add(Duration(minutes: 20));

  void _showAlertDialog(BuildContext context) {
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

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportPopup(),
    );
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => PopupReview(),
    );
  }


  void _sendMessage(String text, String sender, bool isMine) {
    // 만약 메시지가 비어 있고, 메시지를 한 번도 보내지 않았다면 팝업 표시
    if (text.isEmpty && messageSendCount == 0) {
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
      isClickedEnter = 0;
      return;
    }

    messageSendCount += 1;

    setState(() {
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


  void complete() {
    setState(() {
      _isChatInputVisible = false;
      isCompleteButton = false;
    });
  }


  bool _isMine = false;
  int showProfile = 1; // 0: 익명, 1: 익명x
  int myQHistoryChat = 0;
  int isClickedEnter = 0; // 답변하기 버튼 클릭 여부
  int messageSendCount = 0; // 메시지 보냈는지
  bool _isQuestioner = true; // true: 질문자, false: 답변자
  bool _isChatInputVisible = true; // 채팅 입력창
  bool isCompleteButton = true; // 완료 버튼


  List<String> savedMessages = [];


  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery
        .of(context)
        .size
        .width, 500.0);
    final height = min(MediaQuery
        .of(context)
        .size
        .height, 700.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 55,
        leadingWidth: 105,
        leading: isClickedEnter != 0
            ? Padding(
          padding: EdgeInsets.only(right: 50.0),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_left,
                size: 30, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        )
            : Container(
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
        title: Text(
          '과목명',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
        actions: [
          if (_isQuestioner) ...[
            if (isClickedEnter == 0) // '질문자'의 경우 '답변하기' 버튼
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: MainGradient(),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    if (messageSendCount == 0) {
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
                    } else {
                      setState(() {
                        _isMine = !_isMine;
                        _sendMessage(_messageController.text, "", true);
                        _messageController.clear();
                        isClickedEnter = 1;
                        _showAlertDialog(context);
                      });
                    }
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
            if (isClickedEnter == 1) // '질문자'의 경우 '완료' 버튼
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: MainGradient(),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    if (isCompleteButton) {
                      // '완료' 버튼을 눌렀을 때 실행할 작업을 여기에 추가
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PopupReview();
                        },
                      );
                    } else {
                      // '공유' 버튼을 눌렀을 때 chatShare.dart 파일로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatShare()),
                      );
                    }
                  },
                  child: Text(
                    isCompleteButton ? '완료' : '공유',
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
                )
              ),
          ] else if (isClickedEnter == 0) ...[ // '답변자'의 경우 '답변하기' 버튼
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: MainGradient(),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  if (messageSendCount == 0) {
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
                  } else {
                    setState(() {
                      _isMine = !_isMine;
                      _sendMessage(_messageController.text, "", true);
                      _messageController.clear();
                      isClickedEnter = 1;
                      _showAlertDialog(context);
                    });
                  }
                },
                child: Text('답변하기', style: TextStyle(fontFamily: 'ExtraBold',
                  color: Colors.white,
                  fontSize: 15,),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                ),
              ),
            ),
          ],
        ],
      ),
      body: _isChatInputVisible ? Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.transparent,
              child: Center(
                child: isClickedEnter != 0
                    ? SizedBox()
                    : Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Countdown(endTime: _time,),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool shouldDisplayHeader = showProfile == 1 &&
                      (index == 0 ||
                          _messages[index - 1].sender != message.sender);
                  final bool shouldDisplayTime =
                  (index == _messages.length - 1 ||
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
                              CircleAvatar(backgroundImage: NetworkImage(
                                  message.senderImageURL), radius: 15,),
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
                                      left: 12, bottom: 7), // 상대방 닉네임 위치
                                  child: Text(message.senderName,
                                    style: TextStyle(
                                      fontSize: 12, color: Colors.black,
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
                                        "${message.sentAt.hour}:${message.sentAt
                                            .minute.toString().padLeft(
                                            2, '0')}",
                                        style: TextStyle(fontSize: 10,
                                          fontFamily: 'Round',
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      )
                                          : Container(),
                                    ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                    ),
                                    margin: EdgeInsets.only(
                                      left: message.isMine
                                          ? 0
                                          : (shouldDisplayHeader
                                          ? (showProfile == 1 ? 8.0 : 4.0)
                                          : (showProfile == 0 ? 0 : 39.0)),
                                      top: 0,
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
                                            : Colors.black, fontFamily: 'Round',
                                      ),
                                    )
                                        : message.imagePath != null
                                        ? Image.file(
                                      File(message.imagePath!), width: 150,
                                      fit: BoxFit.cover,)
                                        : SizedBox
                                        .shrink(),
                                  ),
                                  if (!message.isMine)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 20.0),
                                      child: shouldDisplayTime
                                          ? Text(
                                        "${message.sentAt.hour}:${message.sentAt
                                            .minute.toString().padLeft(
                                            2, '0')}",
                                        style: TextStyle(fontSize: 10,
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
                          return ImagePickerPopup(
                            onImagePicked: (imagePath) {
                              // 이미지를 선택한 경우, savedMessages에 이미지 경로를 저장
                              savedMessages.add(imagePath!.path);
                              _sendMessage(imagePath.path, "", true); // 메시지 전송 함수 호출
                            },
                          );
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
                                maxWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.7,
                                maxHeight: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.7),
                            height: 40,
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: '메시지를 입력하세요',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Transform.rotate(
                            angle: -30 * (3.141592653589793 / 180),
                            child: Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            String message = _messageController.text;
                            savedMessages.add(message); // 메시지를 저장
                            _sendMessage(message, "", true); // 메시지 전송 함수 호출
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
      ) : null,
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
