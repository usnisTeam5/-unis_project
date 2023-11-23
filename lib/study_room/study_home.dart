import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';
import 'dart:math';
import 'study_room_setting.dart';
void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: StudyHome(),
    );
  }
}

class StudyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width,500.0);
    double tabBarHeight = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 28,),
            color: Colors.grey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudyRoomSetting()),
              );
              //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: GradientText(
            width: width, text: '스터디 제목', tSize: 0.06, tStyle: 'Bold'),
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
              width: MediaQuery.of(context).size.width,
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
            child: buildListView(),
          ),
        ],
      ),
    );
  }
}

  ListView buildListView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OthersProfilePage()),
            );
          },
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
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                ),
                SizedBox(width: 20),
                Text(
                  '친구$index',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


