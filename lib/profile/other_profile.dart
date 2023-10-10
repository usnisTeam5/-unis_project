import 'package:flutter/material.dart';
import '../chat/chat.dart';
import 'friend.dart';
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
        title: GradientText(width: width, text: '프로필', tSize: 0.06, tStyle: 'Bold'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsList()));
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
  @override
  _OthersProfileInfoSectionState createState() => _OthersProfileInfoSectionState();
}

class _OthersProfileInfoSectionState extends State<OthersProfileInfoSection> {
  bool _isFavoriteSelected = false;
  bool _isPersonAddSelected = false;
  bool _isPersonOffSelected = false;

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
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/unis.png'),
              ),
              SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임 : 물만두",
                    style: TextStyle(
                      fontFamily: 'Bold',
                      color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: 13.0),
                  Text(
                    "학과(학부): 소프트웨어학부",
                    style: TextStyle(
                        fontFamily: 'Bold',
                        color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavoriteSelected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: _isFavoriteSelected ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          if (!_isPersonOffSelected) { // 차단 상태가 아니라면
                            setState(() {
                              _isFavoriteSelected = !_isFavoriteSelected;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 15.0),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_rounded, color: Colors.grey,),
                        onPressed: _isPersonOffSelected // 차단 상태라면 null, 아니라면 함수 실행
                            ? null
                            : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()
                              )
                          );
                        },
                      ),
                      SizedBox(width: 15.0),
                      IconButton(
                        icon: Icon(
                          Icons.person_add_rounded,
                          color: _isPersonAddSelected ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _isPersonOffSelected // 차단 상태라면 null, 아니라면 함수 실행
                            ? null
                            : () {
                          setState(() {
                            _isPersonAddSelected = !_isPersonAddSelected;
                          });
                        },
                      ),
                      SizedBox(width: 15.0),
                      IconButton(
                        icon: Icon(
                          Icons.person_off_rounded,
                          color: _isPersonOffSelected ? Colors.red : Colors.grey,
                        ),
                        onPressed: (_isFavoriteSelected || _isPersonAddSelected) // 찜하거나 친추 상태라면 null, 아니라면 함수 실행
                            ? null
                            : () {
                          setState(() {
                            _isPersonOffSelected = !_isPersonOffSelected;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            '안녕하세요!                                                                     ',
            style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600], fontSize: 15),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
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
        setState(() {
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
              Text("    만족도 : ", style: TextStyle(color: Colors.grey[600], fontFamily: 'Bold', fontSize: width * 0.04),),
              Text("5.0", style: TextStyle(color: Color(0xFF678DBE), fontFamily: 'Bold', fontSize: width * 0.04),),
            ],
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
            style: ElevatedButton.styleFrom(
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



class StatsSection extends StatelessWidget {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildColumn("질문", "0", width),
          ),
          Expanded(
            child: _buildColumn("답변", "0", width),
          ),
          Expanded(
            child: _buildColumn("스터디", "0", width),
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

