import 'package:flutter/material.dart';
//import 'package:circle_avatar/circle_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'friend.dart';
import 'package:unis_project/profile/profile_settings.dart';
import 'package:unis_project/css/css.dart';

void main() {
  runApp(const Profile());
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    double width = MediaQuery.of(context).size.width;
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
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {getImage(ImageSource.gallery);},
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : AssetImage('image/unis.png'),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임: 물만두",
                    style: TextStyle(
                      fontFamily: 'Bold',  // 해당 폰트를 프로젝트에 추가하고, 이름을 확인하세요
                    ),
                  ),
                  Text(
                    "학과(학부): 소프트웨어학부",
                    style: TextStyle(
                      fontFamily: 'Bold',  // 해당 폰트를 프로젝트에 추가하고, 이름을 확인하세요
                    ),
                  ),
                  Text(
                    "보유 포인트: 2000",
                    style: TextStyle(
                      fontFamily: 'Bold',  // 해당 폰트를 프로젝트에 추가하고, 이름을 확인하세요
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),  // 추가적인 공간을 제공하여 섹션 사이에 간격을 만듭니다.
          TextField(
            maxLength: 15,
            decoration: InputDecoration(
              labelText: '자기소개',
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
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "질문",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'ExtraBold',
                  fontSize: width * 0.05,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // "질문" 숫자를 클릭했을 때의 행동을 여기에 구현
                },
                child: Text(
                  "0", // 이 값을 실제 질문의 수로 대체하세요
                  style: TextStyle(
                    color: Colors.lightBlue[900],
                    fontFamily: 'ExtraBold',
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "답변",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'ExtraBold',
                  fontSize: width * 0.05,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // "답변" 숫자를 클릭했을 때의 행동을 여기에 구현
                },
                child: Text(
                  "0", // 이 값을 실제 답변의 수로 대체하세요
                  style: TextStyle(
                    color: Colors.lightBlue[900],
                    fontFamily: 'ExtraBold',
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "가입 스터디",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'ExtraBold',
                  fontSize: width * 0.05,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // "가입 스터디" 숫자를 클릭했을 때의 행동을 여기에 구현
                },
                child: Text(
                  "0", // 이 값을 실제 가입 스터디의 수로 대체하세요
                  style: TextStyle(
                    color: Colors.lightBlue[900],
                    fontFamily: 'ExtraBold',
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



enum CourseStatus { ongoing, completed }

class CoursesSection extends StatelessWidget {
  // 각각의 수강 중인 과목과 수강한 과목을 여기에 나열하세요.
  final List<String> ongoingCourses = ['과목 1', '과목 2'];
  final List<String> completedCourses = ['과목 A', '과목 B'];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        // 이 부분에서 상태를 업데이트하여 패널을 확장하거나 축소하세요
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('수강 중인 과목'),
            );
          },
          body: Column(
            children: ongoingCourses.map((course) => ListTile(title: Text(course))).toList(),
          ),
          isExpanded: false, // 이 값을 패널의 현재 상태에 따라 업데이트하세요
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('수강한 과목'),
            );
          },
          body: Column(
            children: completedCourses.map((course) => ListTile(title: Text(course))).toList(),
          ),
          isExpanded: false, // 이 값을 패널의 현재 상태에 따라 업데이트하세요
        ),
      ],
    );
  }
}
