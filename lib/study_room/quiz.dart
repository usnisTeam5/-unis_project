import 'package:flutter/material.dart';
import '../css/css.dart';
import '../file_selector/file_selector.dart';
import '../study_room/quiz_creator.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bold',
      ),
      home: QuizFolderScreen(),
    );
  }
}

class QuizFolderScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizFolderScreen> {
  // 과목 목록
  final FileSelector fileSelector = FileSelector();
  final List<String> subjects = [
    '1강',
    '2강',
    '3강',
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [  // `actions` 속성을 사용하여 IconButton을 추가합니다.
          IconButton(
            icon: Icon(Icons.add, size: 30,),
            color: Colors.grey,
            onPressed: () {
              //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
            },
          ),
        ],
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
      body: SingleChildScrollView(
        child: Column(
                    children: subjects.map((subject) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizFolderScreen()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 27),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,  // 아이템을 세로축 왼쪽으로 정렬
                            children: [
                              Row(
                                children: [
                                  Text(
                                    subject,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'Bold',
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text('    5'),
                                  Spacer(flex: 1),
                                  IconButton(
                                    icon: Icon(
                                      Icons.settings,
                                      color: Color(0xFF3D6094),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      // onPressed 로직
                                      // 예를 들어, 다음 화면으로 이동하거나 다이얼로그를 표시
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼이 양쪽 끝으로 가게 함
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      fileSelector.pickDocument(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.white),  // 테두리색을 배경색과 동일하게 함
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),  // 둥근 모서리를 만듦
                                      ),
                                    ),
                                    child: Text(
                                      '문서등록',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // '문서생성' 버튼 클릭 시의 동작
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => QuizCreator()),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.white),  // 테두리색을 배경색과 동일하게 함
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),  // 둥근 모서리를 만듦
                                      ),
                                    ),
                                    child: Text(
                                      '문제생성',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ),
            );
  }
}
