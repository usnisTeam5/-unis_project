import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import 'dart:math';
import '../models/study_info.dart';
import '../study_room/bottom_navigation_bar.dart';
import '../view_model/study_info_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: StudyScreen(),
    );
  }
}

class StudyScreen extends StatelessWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final mystudy = Provider.of<MyStudyInfoViewModel>(context, listen: true);

    print("스터디 스크린");
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = MediaQuery.of(context).size.height;

    // List<MyStudyInfo> mystudylist = [
    //   // MyStudyInfo(roomKey: mystudy.roomKey, roomName: mystudy.roomName, course: mystudy.course, studyIntroduction: mystudy.studyIntroduction, curNum: mystudy.curNum, maxNum: mystudy.maxNum, startDate: mystudy.startDate),
    //   // MyStudyInfo(roomKey: mystudy.roomKey, roomName: mystudy.roomName, course: mystudy.course, studyIntroduction: mystudy.studyIntroduction, curNum: mystudy.curNum, maxNum: mystudy.maxNum, startDate: mystudy.startDate),
    //   // // ... more mystudylist
    // ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (count == 0) {
        count++; // 여기서 1로 만들면 아래에서 로딩이 활성화됨.
        final nickname =
            Provider.of<UserProfileViewModel>(context, listen: false).nickName;
        await mystudy.getMyStudyRoomList(nickname);
        //mystudylist = mystudy.MyStudyInfoList;
        //print(mystudylist[0].startDate);
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GradientText(
            width: width, tSize: 0.06, text: '내 스터디', tStyle: 'Bold'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: (mystudy.isLoading || count == 0)
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: 10.0),
              color: Colors.grey[200],
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: mystudy.MyStudyInfoList.length,
                itemBuilder: (context, index) {
                  final MyStudyInfo = mystudy.MyStudyInfoList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MyStudyInfo.roomName,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.05),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(height: 14),
                            Container(
                              width: width - 35,
                              child: Text(
                                MyStudyInfo.course,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xFF3D6094),
                                    fontFamily: 'Bold',
                                    fontSize: width * 0.03),
                                // textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              MyStudyInfo.studyIntroduction,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.025),
                            ),
                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                        "${MyStudyInfo.curNum}/${MyStudyInfo.maxNum}명",
                                        style: TextStyle(
                                            fontFamily: 'Round', fontSize: 13)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '시작일',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 13,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      MyStudyInfo.startDate,
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 13,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// class Study {
//   final String title;
//   final String subject;
//   final String description;
//   final String members;
//   final String startDate;
//
//   Study({
//     required this.title,
//     required this.subject,
//     required this.description,
//     required this.members,
//     required this.startDate,
//   });
// }
