import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../css/css.dart';
import '../models/study_info.dart';
import '../profile/other_profile.dart';
import 'dart:math';
import '../view_model/find_study_view_model.dart';
import '../view_model/study_info_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'study_room_setting.dart';

// void main() => runApp(FriendsList());
//
// class FriendsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         fontFamily: 'Round',
//       ),
//       home: StudyHome(),
//     );
//   }
// }

class StudyHome extends StatelessWidget {
  MyStudyInfo myStudyInfo;

  StudyHome({required this.myStudyInfo});


  int count = 0;

  @override
  Widget build(BuildContext context) {

        double width = min(MediaQuery.of(context).size.width, 500.0);
        double tabBarHeight = MediaQuery.of(context).size.height * 0.08;

        print("가입 스터디 입장");
        final mystudylist = Provider.of<StudyViewModel>(context, listen: true);

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (count == 0) {
            count++;
            await mystudylist.enterStudy(myStudyInfo.roomKey, Provider.of<UserProfileViewModel>(context,listen: false).nickName);
          }
        });

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              ),
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 28,
                ),
                color: Colors.grey,
                onPressed: () async{
                  String code = await mystudylist.getStudyCode(myStudyInfo.roomKey);
                  String leader = await mystudylist.getLeader(myStudyInfo.roomKey);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoomSetting(myStudyInfo, code,leader,mystudylist.studyFriendList)),
                  );
                  await mystudylist.enterStudy(myStudyInfo.roomKey, Provider.of<UserProfileViewModel>(context,listen: false).nickName);
                  //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: GradientText(
                width: width,
                text: myStudyInfo.roomName,
                tSize: 0.06,
                tStyle: 'Bold'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              // Set the height of the underline
              child: Container(
                decoration: BoxDecoration(
                  gradient: MainGradient(),
                ),
                height: 2.0,
              ),
            ),
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('공지'),
                        content: Text('이것은 공지입니다!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('닫기'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Text(
                    '공지: 이것은 공지입니다!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Round',
                    ),
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: (mystudylist.isLoading || count == 0)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: mystudylist.studyFriendList.length,
                  itemBuilder: (context, index) {
                    final userInfo = mystudylist.studyFriendList[index];
                    return GestureDetector(
                      onTap: (userInfo.nickname != Provider.of<UserProfileViewModel>(context,listen: false).nickName) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OthersProfilePage(userInfo.nickname)),
                        );
                      } : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.0, // 이미지의 크기 조절
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(base64Decode(userInfo.image!)),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              userInfo.nickname, // 닉네임
                              style: TextStyle(fontSize: 16, color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }
}

