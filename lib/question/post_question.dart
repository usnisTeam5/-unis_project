import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/image_picker_popup.dart';
import 'package:unis_project/question/post_settings.dart';
import 'package:unis_project/question/question.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import '../image_viewer/image_viewer.dart';
import '../profile/friend.dart';
import '../models/enroll_question.dart';
import 'package:provider/provider.dart';
import '../view_model/user_profile_info_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  List<MsgDto> _messages = [];

  bool hasUserSentMessage = false; // 질문 올렸는지 확인함
  String nickname = '';

  void _sendImage(String base64Image) {
    //  이미지 보낼 때 사용
    setState(() {
      _messages.add(MsgDto(
        nickname: nickname,
        type: 'img',
        msg: "",
        image: base64Image,
        // base64로 인코드 해서 보내야함.
        time: (DateTime.now()).toString(),
      ));
    });
    hasUserSentMessage = true;
    _scrollToBottom();
  }

  void _sendMsg(String text) {
    //  이미지 보낼 때 사용
    setState(() {
      _messages.add(MsgDto(
        nickname: nickname,
        type: "text",
        msg: text,
        image: "",
        time: (DateTime.now()).toString(),
      ));
      _messageController.clear();
    });
    hasUserSentMessage = true;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // 스크롤을 아래로 내려줌
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
    final width = min(MediaQuery
        .of(context)
        .size
        .width, 500.0);
    final height = min(MediaQuery
        .of(context)
        .size
        .height, 700.0);

    nickname = Provider
        .of<UserProfileViewModel>(context, listen: false)
        .nickName;


    return Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left, size: 30, color: Colors.grey,),
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
                              Navigator.of(context).pop(); // Alert 창을 끔
                              Navigator.of(context).pop(); // 밖으로 나감
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
                TextButton(
                  onPressed: () {
                    if (!hasUserSentMessage) {
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PostSettings(
                              msg : _messages );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      gradient: MainGradient(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '금액 설정',
                      style: TextStyle(
                        fontFamily: 'ExtraBold',
                        color: Colors.white,
                        fontSize: width * 0.04,
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
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        MsgDto message = _messages[index]; // 내가 입력한거
                        DateTime _time = DateTime.parse(message.time); // 시간 data time으로 표기
                        final byteImage = base64Decode(message.image);
                        final time = "${_time.hour}:${_time.minute.toString() // 파싱
                            .padLeft(2, '0')}";

                        String next_time =""; // 다음 시간
                        if(_messages.length > index+1) { //  (다음 메시지) 가 있으면
                          DateTime _next_time = DateTime.parse(_messages[index+1].time); //다음시간 정함

                          next_time= "${_next_time.hour}:${_next_time.minute
                              .toString()
                              .padLeft(2, '0')}";
                        }

                        final bool shouldDisplayTime = (index == _messages.length - 1 || next_time != time); // 시간이 다르거나 마지막이면 표기

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, right: 3.0),
                                child: shouldDisplayTime ?
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Round',
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ) : null
                              ),
                              Container( // 메시지
                                width: message.type == 'img'
                                    ? width * 0.6
                                    : null,
                                height: message.type == 'img'
                                    ? height * 0.3
                                    : null,
                                constraints: BoxConstraints(
                                  maxWidth: width * 0.6,
                                  maxHeight: height * 0.5,
                                ),
                                decoration: BoxDecoration(
                                  color:(message.type == 'img')
                                     ? Colors.grey[200] :Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(15),
                                  // image:
                                  // message.type == 'text' ? null :
                                  // DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: MemoryImage(byteImage),
                                  // ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: message.type == 'text'
                                    ? Text(
                                  message.msg,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.white, fontFamily: 'Round'),
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                PhotoView(
                                                  photoData:
                                                  byteImage,
                                                ),
                                          ));
                                    },
                                    child: Image.memory(
                                      byteImage,
                                      width: width * 0.6,
                                      height: height * 0.3,
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                )
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
                          onPressed: null,
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
                                  onImagePicked: (pickedFile) async {
                                    Uint8List imageBytes = await pickedFile!.readAsBytes();
                                    final String base64Image = base64Encode(imageBytes);
                                    _sendImage(
                                        base64Image); // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
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
                                  child: Icon(Icons.send, color: Colors.grey,),
                                ),
                                onPressed: () {
                                  if(_messageController.text != "")
                                    _sendMsg(_messageController.text);
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
    );
  }
}
