/*
1대1 대화
 */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unis_project/chat/report.dart';
import '../image_viewer/image_viewer.dart';
import '../profile/other_profile.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'chat.dart';
import 'image_picker_popup.dart';

import '../view_model/OneToOneChat_view_model.dart';
import '../models/OneToOneChat_model.dart';

class OneToOneChatScreen extends StatefulWidget {
  final String friendName;

  OneToOneChatScreen({required this.friendName});

  @override
  _OneToOneChatScreenState createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int count = 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isDisposed = false; // 화면을 나갈 때, getMsg를 종료시키도록 하기위해서 필요

  @override
  void dispose() {
    _isDisposed = true; // Set the flag to true when disposing the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OneToOneChatViewModel(),
      builder: (context, child) {

        final width = min(MediaQuery
            .of(context)
            .size
            .width, 500.0);
        final height = min(MediaQuery
            .of(context)
            .size
            .height, 700.0);

        final myprofile =
        Provider.of<UserProfileViewModel>(context, listen: false);
        final chatModel =
        Provider.of<OneToOneChatViewModel>(context, listen: true);


        final myNickname = myprofile.nickName;
        final friendNickname = widget.friendName;

        chatModel.myNickname = myNickname; // 쓸지는 모르겠음.
        chatModel.friendNickname = friendNickname;

        int showProfile = 1;

        void startGettingMessages() async {
          while (!_isDisposed) {
            await Future.delayed(const Duration(
                milliseconds: 500)); // Adjust the delay duration as needed
            await chatModel.getMsg(myNickname, friendNickname);
          }
        } //

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (count == 0) {
            setState(() {
              count++; // 여기서 1로 만들면 아래에서 로딩이 활성화됨.
            });
            // count --;
            //final chatModel = Provider.of<OneToOneChatViewModel>(context, listen: false);
            await chatModel.loadProfileImage(friendNickname);
            await chatModel.getAllMsg(
                myNickname, friendNickname); // 별뚜기는 상대방 닉네임. 아마 별뚜기 될거임.
            startGettingMessages(); // getmsg 무한루프 돌림.
          }
          _scrollToBottom();
          print("heoo.");
        });

        void _showReportDialog() {
          // 신고하기 창
          showDialog(
            context: context,
            builder: (context) => ReportPopup(),
          );
        }

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
                icon: Icon(Icons.keyboard_arrow_left,
                    size: 30, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Text(
              "${chatModel.friendNickname}",
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Bold',
              ),
            ),
          ),
          body: (chatModel.isLoading == true || count == 0)
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chatModel.messages.length,
                    itemBuilder: (context, index) {

                        final MsgDto message = chatModel.messages[index];

                        final byteImage = base64Decode(message.image);

                        bool shouldDisplayHeader= ( // 메세지가 상대방 메세지이면 프로필 보여줌
                            showProfile == 1 &&
                                (index == 0 ||
                                    chatModel.messages[index - 1].nickname !=
                                        message.nickname));

                        bool shouldDisplayTime = ((index == chatModel.messages.length - 1 ||
                            chatModel.messages[index + 1].nickname !=
                                message.nickname ||
                            chatModel.messages[index + 1].time !=
                                message.time));


                      return Padding(
                        // 메시지 보내는곳.
                        padding: const EdgeInsets.all(8.0),
                        key: ValueKey(index),
                        child: Row(
                          // 메시지 가로로 길게 쭉 있음.
                          mainAxisAlignment: message.nickname ==
                              myNickname
                              ? MainAxisAlignment.end // 내 닉네임이면 오른쪽 정렬
                              : MainAxisAlignment.start,
                          // 상대방 닉네임이면 왼쪽 정렬
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // 세로 방향에서 위젯을 시작 부분에 정렬 (모르겠음)
                          children: [
                            if (message.nickname != myNickname &&
                                shouldDisplayHeader) // 내 메시지가 아닌 상대방 메시지 인데, header를 보여줄 때
                              Column( // 상대방 프로필 표시
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => OthersProfilePage(message.nickname)),
                                      );
                                    },
                                    child: ClipOval(
                                      child: Image.memory(
                                        chatModel.friendProfileImage,
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                      ),
                                    ),
                                  ),
                                  // CircleAvatar(
                                  //   backgroundImage: MemoryImage(chatModel
                                  //       .friendProfileImage), // ** 추가
                                  //   radius: 15,
                                  // ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Column( //  이름 답 시간
                                crossAxisAlignment:
                                message.nickname == myNickname
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (message.nickname != myNickname &&
                                      shouldDisplayHeader) // 상대방의 경우
                                    Padding( // 닉네임을 표기함
                                      padding: const EdgeInsets.only(
                                          left: 12, bottom: 7),
                                      child: Text(
                                        // 닉네임 표기 *******************************************
                                        message.nickname,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  Row( // 메시지 내용과 시간 표기
                                    mainAxisAlignment:
                                    message.nickname == myNickname
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      if (message.nickname ==
                                          myNickname) // 나일 경우 **추가, 내 메세지의 시간 표시
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, top: 20.0),
                                          child: shouldDisplayTime // 시간 표기
                                              ? Text(
                                            message.time,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Round',
                                              color: Colors.black
                                                  .withOpacity(0.5),
                                            ),
                                          )
                                              : Container(),
                                        ),
                                      Container( // 이미지일 경우 높이랑 길이 지정
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
                                        margin: EdgeInsets.only(
                                          left: (message.nickname == myNickname) // 나일 경우
                                              ? 0 // 0
                                              : (shouldDisplayHeader // 내가 아닐 경우
                                              ? (showProfile == 1
                                              ? 8.0
                                              : 4.0) // 익명 아닐 때 프로필 위치
                                              : (showProfile == 0
                                              ? 0
                                              : 39.0)),
                                          // 익명 일 때 프로필 위치
                                          // top: (message.nickname == myNickname) // 나일 경우
                                          //     ? 0
                                          //     : 0,
                                        ),
                                        padding: message.type == "text" ? const EdgeInsets.all(8.0) : null,
                                        decoration:
                                        BoxDecoration(
                                          color: (message.type == 'img')
                                              ? Colors.grey[200]
                                              : (message.nickname == myNickname) // 나일 경우
                                                  ? Colors.lightBlue // 내 메세지는 파란색
                                                :  Colors.white, // 상대방 메세지는 흰 색
                                          borderRadius: BorderRadius.circular(15),
                                          // image: message.type == 'text'
                                          //     ? null
                                          //     : DecorationImage(
                                          //   fit: BoxFit.cover,
                                          //   image: MemoryImage(
                                          //     a, //byteImage[index]
                                          //   ),
                                          // ),
                                        ),
                                        child: message.type ==
                                            "text" // 메세지가 텍스트일 때
                                            ? Text(
                                          message.msg,
                                          style: TextStyle(
                                            color:
                                            (message.nickname ==
                                                myNickname)
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: 'Round',
                                          ),
                                        )
                                            : message.type == "img" // 메세지가 이미지일 때
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                              child: GestureDetector(
                                                                                        onTap: () {
                                              Navigator.of(
                                                  context)
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
                                              height: height *0.3,
                                              fit: BoxFit.cover,
                                              gaplessPlayback: true,
                                                                                        ),
                                                                                      ),
                                            )
                                            : SizedBox(),
                                      ),
                                      if (message.nickname !=
                                          myNickname) // 내 닉네임이 아닌 경우
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // 상대방 메세지의 시간 표시
                                              left: 8.0,
                                              top: 20.0),
                                          child: shouldDisplayTime
                                              ? Text(
                                            // 메세지 시간 표시 스타일
                                            message.time, // 시간을 보여줌
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Round',
                                              color: Colors.black
                                                  .withOpacity(0.5),
                                            ),
                                          )
                                              : Container(), // 대화 내용
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ); // 메시지 주고받는것들
                    },
                  ),
                ),
                Container(
                  // 하단에  있는것들.
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
                                onImagePicked: (pickedFile) async {
                                  Uint8List imageBytes = await pickedFile!.readAsBytes();
                                  DateTime time = DateTime.now();
                                  //String strTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
                                  chatModel.sendMsg(
                                      myNickname,
                                      friendNickname,
                                      'img',
                                      '',
                                      imageBytes,
                                      time
                                          .toString()); // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                                },
                              ); //
                            },
                          );
                        }, // //
                      ),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: width * 0.7,
                            maxHeight: height * 0.7,
                          ),
                          height: 40,
                          child: TextField(
                            maxLength: 200,
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
                              counterText:
                              '', // This will hide the character count
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Transform.rotate(
                          angle: -30 * (3.141592653589793 / 180),
                          child: Icon(
                            Icons.send,
                            color: _messageController.text.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            //_sendMessage(_messageController.text);
                            DateTime time = DateTime.now();
                            String strTime =
                                "${time.hour}:${time.minute.toString().padLeft(
                                2, '0')}";
                            chatModel.sendMsg(
                                myNickname,
                                friendNickname,
                                'text',
                                _messageController.text,
                                Uint8List(0),
                                time.toString());
                            _messageController.text = '';
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
      },
    );
  }
}
