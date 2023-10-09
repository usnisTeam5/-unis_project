import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unis_project/question/question.dart';
import '../subject_selector/subject_selector.dart';

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
  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('금액 설정 및 옵션'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('금액 설정', style: TextStyle(fontSize: 18)),
                DropdownButton<int>(
                  hint: Text('금액을 선택하세요'),
                  value: selectedPost,
                  items: List.generate(201, (index) => index * 100).map((post) {
                    return DropdownMenuItem(
                      child: Row(
                        children: [
                          Text('$post '),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: SvgPicture.asset('image/point.svg',
                                width: 32, height: 32),
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
                Text('과목 선택', style: TextStyle(fontSize: 18)),
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
            SizedBox(height: 24),
            Text('질문 유형 선택', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isQuestionType1Selected = true;
                  isQuestionType2Selected = false;
                });
              },
              child: Text("문제 질문하기"),
              style: ElevatedButton.styleFrom(
                primary: isQuestionType1Selected ? Colors.blue : Colors.grey[300],
                onPrimary: isQuestionType1Selected ? Colors.white : Colors.black,
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
              child: Text("과목 조언 구하기"),
              style: ElevatedButton.styleFrom(
                primary: isQuestionType2Selected ? Colors.blue : Colors.grey[300],
                onPrimary: isQuestionType2Selected ? Colors.white : Colors.black,
                minimumSize: Size(width, 50),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('익명으로 질문하기', style: TextStyle(fontSize: 18)),
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
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (!isQuestionType1Selected && !isQuestionType2Selected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('질문 유형을 선택해주세요')),
                  );
                  return;
                }
                if (selectedPost == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('금액을 설정해주세요')),
                  );
                  return;
                }
                if (selectedSubject == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('과목을 선택해주세요')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionPage()),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
