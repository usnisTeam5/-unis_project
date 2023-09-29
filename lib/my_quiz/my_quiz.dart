/**
 * 내 문답
 */

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ExtraBold', // ExtraBold 글꼴을 사용하려면 앱에 폰트 파일을 추가해야 합니다.
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: Text('Quiz'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // 화면 전환 로직
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(subject: subjects[index]),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                subjects[index],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[200],  // 아주 밝은 회색 배경
    );
  }
}

// 과목 목록
final List<String> subjects = [
  'Mathematics',
  'Science',
  'History',
  'Geography',
  'English',
];

// 각 과목의 세부 정보를 표시하는 화면
class DetailScreen extends StatelessWidget {
  final String subject;

  DetailScreen({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Center(
        child: Text(
          'Details for $subject',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
