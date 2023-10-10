import 'package:flutter/material.dart';
//import 'package:circle_avatar/circle_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unis_project/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'dart:io';
import '../menu/point_charge.dart';
import 'friend.dart';
import 'package:unis_project/profile/profile_settings.dart';
import 'package:unis_project/css/css.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unis_project/myQHistory/myQHistory.dart';


class MyApp extends StatelessWidget {
  final HomeController controller;

  MyApp({required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
    return MaterialApp(
      home: MyProfilePage(controller: controller),
      theme: ThemeData(
        fontFamily: 'Round',
      ),
    );
  }
}

class MyProfilePage extends StatelessWidget {
  final HomeController controller;

  MyProfilePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width,500);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GradientText(width: width, text: 'My 프로필', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.people),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendsList()),
            );
          },
          color: Colors.grey[400],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettings()),
              );
            },
            color: Colors.grey[400],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ProfileInfoSection(),
            StatsSection(controller: controller),
            CoursesSection(),
          ],
        ),
      ),
    );
  }
}





class ProfileInfoSection extends StatefulWidget {
  @override
  _ProfileInfoSectionState createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection>{

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : AssetImage('image/unis.png'),
                ),
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 13.0),
                  Text(
                    "닉네임 : 물만두", style: TextStyle(fontFamily: 'Bold',color: Colors.grey[600],),
                  ),
                  SizedBox(height: 13.0),
                  Text(
                    "학과(학부) : 소프트웨어학부", style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PointChargeScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "보유 포인트 : 2000", style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                            ),
                            SizedBox(width: 3),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextField(
            maxLength: 15,
            cursorColor: Color(0xFF678DBE),
            decoration: InputDecoration(
              hintText: '나를 소개하세요',
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF678DBE)),
              ),
            ),
            style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600], fontSize: 15),
          ),
        ],
      ),
    );
  }
}

enum StatsCategory {
  question,
  answer,
  joinedStudy,
}

class StatsSection extends StatelessWidget {
  final HomeController controller;

  StatsSection({required this.controller});
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width,500.0);

    return Container(
      padding: EdgeInsets.all(30.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn("질문", "0", width, context, () {
            controller.onItemTapped(1);
          }),
          _buildStatColumn("답변", "0", width, context, () {
            controller.onItemTapped(1);
          }),
          _buildStatColumn("스터디", "0", width, context, () {
            controller.onItemTapped(3);
          }),
        ],
      ),
    );
  }

  Column _buildStatColumn(String title, String number, double width, BuildContext context, Null Function() param4) {
    return Column(
      children: [
        GestureDetector(
          onTap: param4,
          child:  Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'ExtraBold',
              fontSize: width * 0.05,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: param4,
          child: Text(
            number,
            style: TextStyle(
              color: Color(0xFF678DBE),
              fontFamily: 'ExtraBold',
              fontSize: width * 0.10,
            ),
          ),
        ),
      ],
    );
  }
}













class CoursesSection extends StatefulWidget {
  @override
  _CoursesSectionState createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  List<String> ongoingCourses = ['인공지능', '컴퓨터 그래픽스', '알고리즘'];
  List<String> completedCourses = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildCourseSection(
          '수강 중인 과목',
          ongoingCourses,
              (course) {
            setState(() {
              completedCourses.add(course);
              ongoingCourses.remove(course);
            });
          },
          isOngoing: true,
        ),
        SizedBox(height: 20),
        _buildCourseSection(
          '수강한 과목',
          completedCourses,
              (course) {
            setState(() {
              ongoingCourses.add(course);
              completedCourses.remove(course);
            });
          },
          isOngoing: false,
        ),
        Padding(padding: EdgeInsets.only(bottom: 200.0)) // 맨 아래
      ],
    );
  }

  Widget _buildCourseSection(String title, List<String> courses, Function(String) onCourseChecked, {required bool isOngoing}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20), // 너비
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: TextStyle(fontFamily: 'Bold', fontSize: 20, color: Color(0xFF678DBE))),
          ),
          ...courses.map(
                (course) => ListTile(
              title: Text(course, style: TextStyle(fontFamily:'Round', color: Colors.grey[800]),),
              trailing: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(isOngoing ? Color(0xFF678DBE) : Colors.grey[100]),
                side: BorderSide(color: Colors.grey),
                shape: CircleBorder(),
                value: isOngoing,
                onChanged: (_) => onCourseChecked(course),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
