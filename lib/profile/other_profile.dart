import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../chat/OneToOneChat.dart';
import '../css/css.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import '../view_model/other_profile_view_model.dart';
import '../models/other_profile_model.dart';

void main() {
  runApp(const OthersProfile());
}

class OthersProfile extends StatelessWidget {
  const OthersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OthersProfilePage(),
      theme: ThemeData(
        fontFamily: 'Round',
      ),
    );
  }
}

class OthersProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProfileOtherViewModel(),
        builder: (context, child) {
          return OthersProfilePage1();
        });
  }
}

class OthersProfilePage1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context를 사용하여 UserProfileViewModel에 접근
      final nickName = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
      // 다른 비동기 작업 실행
      Provider.of<UserProfileOtherViewModel>(context, listen: false)
          .fetchUserProfile(nickName, "별뚜기");
    });

    final width = min(MediaQuery.of(context).size.width, 500.0);
    final viewModel = Provider.of<UserProfileOtherViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,
          ),
        ),
        title: GradientText(
            width: width, text: '프로필', tSize: 0.06, tStyle: 'Bold'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OthersProfileInfoSection(),
            StatsSection(),
            SatisfactionAndReportSection(),
          ],
        ),
      ),
    );
  }
}

class OthersProfileInfoSection extends StatefulWidget {
//  final String profileImage;

  const OthersProfileInfoSection({
    super.key,
  });

  @override
  _OthersProfileInfoSectionState createState() =>
      _OthersProfileInfoSectionState();
}

class _OthersProfileInfoSectionState extends State<OthersProfileInfoSection> {
  // bool _isFavoriteSelected = false;
  // bool _isPersonAddSelected = false;
  // bool _isPersonOffSelected = false;

  XFile? _image; //이미지를 담을 변수 선언

  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  @override
  Widget build(BuildContext context) {
    return _buildWithImage();
  }

  Widget _buildWithImage() {
    final viewModel =
        Provider.of<UserProfileOtherViewModel>(context, listen: true);
    _image = XFile(viewModel.profileImage);
    //Uint8List? decodedImage;

    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 30.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50.0,
                //backgroundImage:
                backgroundImage:
                    FileImage(File(_image?.path ?? 'image/unis.png')),
              ),
              SizedBox(width: width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임 : ${viewModel.nickname}",
                    style:
                        TextStyle(fontFamily: 'Bold', color: Colors.grey[600]),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    width: width * 0.5,
                    child: Text(
                      viewModel.departments.length == 1
                          ? "학과(학부) : ${viewModel.departments[0]}"
                          : "학과(학부) : ${viewModel.departments[0]} \n                    ${viewModel.departments[1]}",
                      style: TextStyle(
                          fontFamily: 'Bold', color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(bottom: 0),
                              constraints: BoxConstraints(),
                              icon: Icon(
                                viewModel.isPick
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: viewModel.isBlock
                                    ? Colors.grey
                                    : (viewModel.isPick
                                        ? Colors.red
                                        : Colors.grey),
                              ),
                              onPressed: viewModel.isBlock
                                  ? null
                                  : () async {
                                      await viewModel.setPick(
                                          viewModel.myNickname,
                                          viewModel.nickname);
                                    },
                            ),
                            Container(
                              child: Text(
                                '찜',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: viewModel.isBlock
                                        ? Colors.grey
                                        : (viewModel.isPick
                                            ? Colors.red
                                            : Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(bottom: 0),
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.chat_bubble_rounded,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OneToOneChatScreen(
                                        nickname1: viewModel.myNickname,
                                        // 1 나
                                        nickname2: viewModel.nickname,
                                        // 2 상대
                                        profileImage2: viewModel.profileImage),
                                  ),
                                );
                              },
                            ),
                            Container(
                              child: Text('대화',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(bottom: 0),
                              constraints: BoxConstraints(),
                              icon: Icon(
                                viewModel.isFriend
                                    ? Icons.person_add_rounded
                                    : Icons.person_add_rounded,
                                color: viewModel.isBlock
                                    ? Colors.grey
                                    : (viewModel.isFriend
                                        ? Colors.blue
                                        : Colors.grey),
                              ),
                              onPressed: viewModel.isBlock
                                  ? null
                                  : () async {
                                      await viewModel.setFriend(
                                          viewModel.myNickname,
                                          viewModel.nickname);
                                    },
                            ),
                            Container(
                              child: Text(
                                ' 친구',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: viewModel.isBlock
                                        ? Colors.grey
                                        : (viewModel.isFriend
                                            ? Colors.blue
                                            : Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(bottom: 0),
                              constraints: BoxConstraints(),
                              icon: Icon(
                                viewModel.isBlock
                                    ? Icons.person_off_rounded
                                    : Icons.person_off_rounded,
                                color: viewModel.isBlock
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () async {
                                await viewModel.setBlock(
                                    viewModel.myNickname, viewModel.nickname);
                                // 차단 상태가 변경되면 다른 상태들도 업데이트
                                if (viewModel.isBlock) {
                                  viewModel.resetOtherStates();
                                }
                              },
                            ),
                            Container(
                              child: Text(
                                '차단',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: viewModel.isBlock
                                        ? Colors.red
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${viewModel.introduction}',
              style: TextStyle(
                  fontFamily: 'Bold', color: Colors.grey[600], fontSize: 15),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4, right: width * 0.1),
            height: 1.3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class InteractionButton extends StatefulWidget {
  final String label;

  InteractionButton({required this.label});

  @override
  _InteractionButtonState createState() => _InteractionButtonState();
}

class _InteractionButtonState extends State<InteractionButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (() {
          _isTapped = !_isTapped;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _isTapped ? Colors.grey : Colors.grey[100],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class SatisfactionAndReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, 500.0);

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "    만족도 : ",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Bold',
                    fontSize: width * 0.04),
              ),
              Text(
                "5.0",
                style: TextStyle(
                    color: Color(0xFF678DBE),
                    fontFamily: 'Bold',
                    fontSize: width * 0.04),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _showReportPopup(context);
            },
            child: Text("신고하기"),
            style: ElevatedButton.styleFrom(
              elevation: 1,
              primary: Colors.white,
              onPrimary: Colors.red,
              textStyle: TextStyle(fontFamily: 'Bold'),
            ),
          ),
        ],
      ),
    );
  }
}

void _showReportPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ReportPopup();
    },
  );
}

class StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, 500.0);
    final viewModel = Provider.of<UserProfileOtherViewModel>(context, listen: false);
    print("dfdfdfd${viewModel.question}");
    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildColumn("질문", viewModel.question.toString(), width),
          ),
          Expanded(
            child: _buildColumn("답변", viewModel.answer.toString(), width),
          ),
          Expanded(
            child: _buildColumn("스터디", viewModel.studyCnt.toString(), width),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String value, double width) {
    return Container(
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'ExtraBold',
              fontSize: width * 0.05,
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              // 숫자를 클릭했을 때의 행동을 여기에 구현
            },
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF678DBE),
                fontFamily: 'ExtraBold',
                fontSize: width * 0.10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
