import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unis_project/question/question.dart';
import '../subject_selector/subject_selector.dart';
import '../css/css.dart';
import '../profile/friend.dart';



























class PostSettings extends StatefulWidget {
  final bool hasUserSentMessage;
  PostSettings({required this.hasUserSentMessage});

  @override
  _PostSettingsState createState() => _PostSettingsState();
}

class _PostSettingsState extends State<PostSettings> {
  int? selectedPost;
  bool isQuestionType1Selected = false;
  bool isQuestionType2Selected = false;
  bool isAnonymousSelected = false;
  bool isWarningSelected = false;
  String? selectedSubject;
  String? selectedFriend;

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: GradientText(width: width, text: '금액 설정 및 옵션', tSize: 0.05, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('금액 설정', style: TextStyle(fontSize: 18, fontFamily: 'Bold', color: Colors.grey[600])),
                DropdownButton<int>(
                  hint: Text('금액을 선택하세요', style: TextStyle(fontSize: 14, fontFamily: 'Round', color: Colors.grey[400])),
                  value: selectedPost,
                  items: List.generate(201, (index) => index * 100).map((post) {
                    return DropdownMenuItem(
                      child: Row(
                        children: [
                          Text('$post '),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
                          ),
                        ],
                      ),
                      value: post,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPost = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('과목 선택', style: TextStyle(fontSize: 18, fontFamily: 'Bold', color: Colors.grey[600])),
                selectedSubject != null
                    ? Text(selectedSubject!, style: TextStyle(fontSize: 16))
                    : IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubjectSelector()),
                    );
                    if (result != null && result is String) {
                      setState(() {
                        selectedSubject = result;
                      });
                    }
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('찜 (선택)', style: TextStyle(fontSize: 18, fontFamily: 'Bold', color: Colors.grey[600])),
                selectedFriend != null
                    ? Text(selectedFriend!, style: TextStyle(fontSize: 16))
                    : IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyListScreen()),
                    );
                    if (result != null && result is String) {
                      setState(() {
                        selectedFriend = result;
                      });
                    }
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text('질문 유형 선택', style: TextStyle(fontSize: 18, fontFamily: 'Bold', color: Colors.grey[600])),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isQuestionType1Selected = true;
                  isQuestionType2Selected = false;
                });
              },
              child: Text("문제 질문하기", style: TextStyle(fontSize: 18, fontFamily: 'Bold')),
              style: ElevatedButton.styleFrom(
                primary: isQuestionType1Selected ? Color(0xFF2A7CC1) : Colors.grey[200],
                onPrimary: isQuestionType1Selected ? Colors.white : Colors.white,
                minimumSize: Size(width, 50),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isQuestionType2Selected = true;
                  isQuestionType1Selected = false;
                });
              },
              child: Text("과목 조언 구하기", style: TextStyle(fontSize: 18, fontFamily: 'Bold')),
              style: ElevatedButton.styleFrom(
                primary: isQuestionType2Selected ? Color(0xFF2A7CC1) : Colors.grey[200],
                onPrimary: isQuestionType2Selected ? Colors.white : Colors.white,
                minimumSize: Size(width, 50),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('익명으로 질문하기', style: TextStyle(fontSize: 18, fontFamily: 'Bold', color: Colors.grey[600])),
                Checkbox(
                  value: isAnonymousSelected,
                  onChanged: (value) {
                    setState(() {
                      isAnonymousSelected = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('족보 관련 질문시, 해당 글의 포인트 전액을 신고자에게 전달하는 것에 동의합니다.', style: TextStyle(fontSize: 12, fontFamily: 'Bold', color: Colors.grey[400])),
                Checkbox(
                  value: isWarningSelected,
                  onChanged: (value) {
                    setState(() {
                      isWarningSelected = value ?? false;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (selectedPost == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '금액을 설정해주세요',
                        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  );
                  return;
                }
                if (selectedSubject == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '과목을 선택해주세요',
                        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  );
                  return;
                }
                if (!isQuestionType1Selected && !isQuestionType2Selected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '질문 유형을 선택해주세요',
                        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  );
                  return;
                }
                if (isWarningSelected == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '족보 관련 주의사항에 동의해주세요.',
                        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[600],),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionPage()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: MainGradient(),
                ),
                child: Center(
                  child: Text(
                    '등록하기',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Bold'),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}