import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:unis_project/chat/report.dart';
import 'image_picker_popup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../view_model/OneToOneChat_view_model.dart';
import '../models/OneToOneChat_model.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    return MaterialApp(
      home: OneToOneChatScreen(
        nickname1: 'sender',
        nickname2: 'receiver',
        profileImage2: 'receiverProfile',
      ),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class OneToOneChatScreen extends StatefulWidget {
  //final String sender;
  final String nickname1;
  final String nickname2;
  final String profileImage2;

  OneToOneChatScreen({required this.nickname1, required this.nickname2, required this.profileImage2,});

  @override
  _OneToOneChatScreenState createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  final OneToOneChatViewModel _viewModel = OneToOneChatViewModel(model: OneToOneChatModel());

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 메시지를 불러오는 함수 호출
    _viewModel.fetchMessages(widget.nickname1, widget.nickname2);
  }

  void _sendMessage(String text) async {
    String currentTime = DateTime.now().toString();
    await _viewModel.sendMessage(widget.nickname1, widget.nickname2, "text", text, "", currentTime);
    _messageController.clear(); // 텍스트 필드 초기화

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scrollToBottom(); // 최신 메시지로 스크롤 이동
        });
      }
    });
  }




  void _onImagePicked(String imagePath) async {
    String currentTime = DateTime.now().toString();
    await _viewModel.sendMessage(widget.nickname1, widget.nickname2, "image", "", imagePath, currentTime);
    setState(() {
      _scrollToBottom();
    });
  }



  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportPopup(),
    );
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
    int showProfile = 1;
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
          widget.nickname2,
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _viewModel.messages.length,
                itemBuilder: (context, index) {
                  final MsgDto message = _viewModel.messages[index];
                  final bool shouldDisplayHeader =
                      showProfile == 1 && (index == 0 || _viewModel.messages[index - 1].nickname != message.nickname);
                  final bool shouldDisplayTime = (index == _viewModel.messages.length - 1 ||
                      _viewModel.messages[index + 1].nickname != message.nickname);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: message.nickname == widget.nickname1
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.nickname != widget.nickname1 && shouldDisplayHeader)
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    message.nickname == widget.nickname2
                                        ? widget.profileImage2 : message.profileImage),
                                radius: 15,
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: message.nickname == widget.nickname1
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (message.nickname != widget.nickname1 && shouldDisplayHeader)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, bottom: 7),
                                  child: Text(
                                    message.nickname,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: widget.nickname1 == widget.nickname1
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (widget.nickname1 == widget.nickname1)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 20.0),
                                      child: shouldDisplayTime
                                          ? Text(
                                        message.time,
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
                                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                                    ),
                                    margin: EdgeInsets.only(
                                      left: widget.nickname1 == widget.nickname1
                                          ? 0
                                          : (shouldDisplayHeader
                                          ? (showProfile == 1 ? 8.0 : 4.0)
                                          : (showProfile == 0 ? 0 : 39.0)),
                                      top: widget.nickname1 == widget.nickname1 ? 0 : 0,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: widget.nickname1 == widget.nickname1
                                          ? Colors.lightBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: message.type == "text"
                                        ? Text(message.msg,
                                      style: TextStyle(
                                        color: widget.nickname1 == widget.nickname1
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Round',),)
                                        : message.type == "image"
                                        ? Image.network(
                                      message.image,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    )
                                        : SizedBox(),
                                  ),
                                  if (message.nickname != widget.nickname1)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 20.0),
                                      child: shouldDisplayTime
                                          ? Text(
                                        message.time,
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
                        _sendMessage(_messageController.text);
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


/* // 모델로 옮길 예정
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
*/