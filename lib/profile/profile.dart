import 'package:flutter/material.dart';
//import 'package:circle_avatar/circle_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'friend.dart';
import 'package:unis_project/profile/profile_settings.dart';
import 'package:unis_project/css/css.dart';
import 'dart:math';

void main() {
  runApp(const Profile());
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: MyProfilePage(),
      theme: ThemeData(
        fontFamily: 'Round',
      ),
    );
  }
}

class MyProfilePage extends StatelessWidget {
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
            StatsSection(),
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
                  Text(
                    "닉네임 : 물만두",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10.0), // <-- Add vertical spacing
                  Text(
                    "학과(학부) : 소프트웨어학부",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10.0), // <-- Add vertical spacing
                  Row(  // <-- Wrap with Row
                    children: [
                      Text(
                        "보유 포인트 : 2000",
                        style: TextStyle(
                          fontFamily: 'Bold',
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 7), // Horizontal spacing
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.yellow[600],
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
            decoration: InputDecoration(
              labelText: '나를 소개하세요',
            ),
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
          _buildStatColumn("질문", "0", width, context),
          _buildStatColumn("답변", "0", width, context),
          _buildStatColumn("가입 스터디", "0", width, context),
        ],
      ),
    );
  }

  Column _buildStatColumn(String title, String number, double width, BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'ExtraBold',
            fontSize: width * 0.05,
          ),
        ),
        SizedBox(height: 10.0),  // <-- Add vertical spacing
        GestureDetector(
          onTap: () {
            // Your onTap code here...
          },
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
  final List<String> ongoingCourses = ['과목 1', '과목 2'];
  final List<String> completedCourses = ['과목 A', '과목 B'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,  // Limits the height of ListView to its children's heights
        children: [
          ExpansionTile(
            title: Text('수강 중인 과목'),
            children: ongoingCourses.map((course) => ListTile(title: Text(course))).toList(),
          ),
          ExpansionTile(
            title: Text('수강한 과목'),
            children: completedCourses.map((course) => ListTile(title: Text(course))).toList(),
          ),
        ],
      ),
    );
  }
}

