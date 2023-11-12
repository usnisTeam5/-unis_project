import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/study_Notification.dart';
import 'image_picker_popup.dart';

import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return MaterialApp(

      home: StudyChatScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class StudyChatScreen extends StatefulWidget {
  @override
  _StudyChatScreenState createState() => _StudyChatScreenState();
}

class _StudyChatScreenState extends State<StudyChatScreen> {
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

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportPopup(),
    );
  }

  void _sendMessage(String text, String sender, bool isMine) {
    // Validate and send message logic here...

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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          '스터디명',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyNotificationSettings(),
                ),
              );
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
                  final bool shouldDisplayHeader =
                      showProfile == 1 && (index == 0 || _messages[index - 1].sender != message.sender);
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
                                    message.senderImageURL/*profileImage*/),
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
                                  Container(
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
                            onImagePicked: _onImagePicked,
                          );
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      height: 40,
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
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
                        color: _messageController.text.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text, "", true);
                      }
                    },
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
