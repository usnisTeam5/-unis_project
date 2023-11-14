import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unis_project/chat/report.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'image_picker_popup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../view_model/OneToOneChat_view_model.dart';
import '../models/OneToOneChat_model.dart';


class OneToOneChatScreen extends StatelessWidget {
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

    return MaterialApp(
      home: OneToOneChatScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class _OneToOneChatScreenState extends StatelessWidget {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //final viewModel = Provider.of<OneToOneChatViewModel>(context, listen: true);

    return ChangeNotifierProvider(
      create: (_) => OneToOneChatViewModel(),
      builder: (context, child) {

        final viewModel = Provider.of<OneToOneChatViewModel>(context, listen: true);


        WidgetsBinding.instance.addPostFrameCallback((_) {

          final viewModel = Provider.of<OneToOneChatViewModel>(context, listen: true);
          final nickName = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
          viewModel.getAllMsg(nickName, "abc");
        });

        void _showReportDialog() {
          showDialog(
            context: context,
            builder: (context) => ReportPopup(),
          );
        }

        void _scrollToBottom() {
          ((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }


        List<String> _image = []; // 이미지
        //List<Message> _messages = []; // 메시지 저장.


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
                icon: Icon(
                    Icons.keyboard_arrow_left, size: 30, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Text(
              "${viewModel.friendNickname}",
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
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final MsgDto message = viewModel.messages[index];
                      final bool shouldDisplayHeader =
                          showProfile == 1 && (index == 0 || viewModel
                              .messages[index - 1].nickname !=
                              message.nickname);
                      final bool shouldDisplayTime = (index == viewModel
                          .messages.length - 1 ||
                          viewModel.messages[index + 1].nickname !=
                              message.nickname);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: message.nickname ==
                              viewModel.nickname1
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.nickname != viewModel.nickname1 &&
                                shouldDisplayHeader)
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        message.nickname == viewModel.nickname2
                                            ? viewModel.profileImage : message.profileImage),
                                    radius: 15,
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: message.nickname ==
                                    viewModel.nickname1
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (message.nickname != viewModel.nickname1 &&
                                      shouldDisplayHeader)
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
                                    mainAxisAlignment: viewModel.nickname1 ==
                                        viewModel.nickname1
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      if (viewModel.nickname1 == viewModel.nickname1)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, top: 20.0),
                                          child: shouldDisplayTime
                                              ? Text(
                                            message.time,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Round',
                                              color: Colors.black.withOpacity(
                                                  0.5),
                                            ),
                                          )
                                              : Container(),
                                        ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.6,
                                        ),
                                        margin: EdgeInsets.only(
                                          left: viewModel.nickname1 ==
                                              viewModel.nickname1
                                              ? 0
                                              : (shouldDisplayHeader
                                              ? (showProfile == 1 ? 8.0 : 4.0)
                                              : (showProfile == 0 ? 0 : 39.0)),
                                          top: viewModel.nickname1 ==
                                              viewModel.nickname1 ? 0 : 0,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: viewModel.nickname1 ==
                                              viewModel.nickname1
                                              ? Colors.lightBlue
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              15),
                                        ),
                                        child: message.type == "text"
                                            ? Text(message.msg,
                                          style: TextStyle(
                                            color: viewModel.nickname1 ==
                                                viewModel.nickname1
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
                                      if (message.nickname != viewModel.nickname1)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 20.0),
                                          child: shouldDisplayTime
                                              ? Text(
                                            message.time,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Round',
                                              color: Colors.black.withOpacity(
                                                  0.5),
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
                                onImagePicked: (imagePath) {_image.add(imagePath);
                                  viewModel.sendMsg(viewModel.myNickname, viewModel.friendNickname,
                                  viewModel.type, viewModel.msg, viewModel.image, viewModel.time);
                                },
                              );
                            },
                          );
                        },
                      ),
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
                                .height * 0.7,
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
                            color: _messageController.text.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            //_sendMessage(_messageController.text);
                            viewModel.chatSendMsg!;
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

