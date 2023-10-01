import 'package:flutter/material.dart';
import '../css/css.dart';
import '../my_quiz/quiz_folder.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bold', // ExtraBold 글꼴을 사용하려면 앱에 폰트 파일을 추가해야 합니다.
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,  // Title을 중앙에 배치
        title: GradientText(width: width, text: 'Quiz', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,  // Set the thickness of the undedsrline
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
                  builder: (context) => QuizFolderScreen()),
              );
            },
            child: Container(
              alignment: Alignment.center,
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
                  fontFamily: 'Bold',
                  color: Colors.grey,
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
  '컴퓨터 그래픽스',
  '수치해석',
  '위험사회의 웰빙사이언스',
  '오토마타',
  '리눅스 운영체제',//
];//
