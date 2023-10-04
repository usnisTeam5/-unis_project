import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // 필요하다면 import하세요
// import 'dart:io'; // 필요하다면 import하세요
// import 'friend.dart'; // 필요하다면 import하세요
import '../css/css.dart';
import 'dart:math';
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

    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: GradientText(width: width, text: '프로필', tSize: 0.06, tStyle: 'Bold'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
          onPressed: () {
            Navigator.pop(context);
             // Navigator.push(context, MaterialPageRoute(builder: (context)> FriendsList())); // 필요하다면 이동
          },
        ),
        backgroundColor: Colors.white,
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

class OthersProfileInfoSection extends StatelessWidget {
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
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/unis.png'),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임: 물만두",
                    style: TextStyle(
                      fontFamily: 'Bold',
                    ),
                  ),
                  Text(
                    "학과(학부): 소프트웨어학부",
                    style: TextStyle(
                      fontFamily: 'Bold',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InteractionButton(label: "찜"),
              InteractionButton(label: "대화"),
              InteractionButton(label: "친추"),
              InteractionButton(label: "차단"),
            ],
          ),
          SizedBox(height: 16.0),
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
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: Container(
        width: 50,  // 원의 너비를 설정
        height: 50,  // 원의 높이를 설정
        decoration: BoxDecoration(
          color: _isTapped ? Colors.grey : Colors.grey[200],
          shape: BoxShape.circle,  // 원형으로 설정
          border: Border.all(color: Colors.black, width: 2),  // 테두리를 추가
        ),
        child: Center(  // 텍스트를 중앙에 배치
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
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child:
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "만족도: 5.0",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'ExtraBold',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("신고하기"),
                        content: Text("신고할 목록을 선택하세요."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("취소"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("신고하기"),
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

