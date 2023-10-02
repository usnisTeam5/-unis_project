import 'package:flutter/material.dart';
import '../css/css.dart';
import '../my_quiz/solve.dart';
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
  final List<String> subjects = [
    '중간고사',
    'ㄴㅇㄹㄴㅇㄹ',
    'ㄴㅁㅇㄹㅇㅀ',
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
            Navigator.pop(context);  // 로그인 화면으로 되돌아가기
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
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 2.0),  // Set the color and width of the bottom border
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text('   학습중', style: TextStyle(color: Colors.grey, fontFamily: 'Bold', fontSize: width * 0.06)),
                trailing: Icon(Icons.menu_outlined, size: width * 0.06, color: Colors.grey,),
                children: [
                  Divider(  // 여기에 Divider 추가
                    color: Colors.grey[300],
                    thickness: 3.0,
                  ),
                  Column(
                      children: subjects.map((subject) {
                        return GestureDetector(
                          onTap: () {
                            // 화면 전환 로직
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Solve()),
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
                                Text(
                                  subject,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontFamily: 'Bold',
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text(
                                      '12/32',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Spacer(flex: 1),  // 사용 가능한 공간을 차지합니다.
                                    GestureDetector(
                                      onTap: () {
                                        // onTap 로직
                                        // 예를 들어, 다음 화면으로 이동하거나 다이얼로그를 표시
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Color(0xFF3D6094),
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            // 여기에 회색 선 추가

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 2.0),  // Set the color and width of the bottom border
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text('   학습완료', style: TextStyle(color: Colors.grey, fontFamily: 'Bold', fontSize: width * 0.06)),
                trailing: Icon(Icons.menu_outlined, size: width * 0.06, color: Colors.grey,),
                children: [
                  Divider(  // 여기에 Divider 추가
                    color: Colors.grey[300],
                    thickness: 3.0,
                  ),
                  Column(
                    children: subjects.map((subject) {
                      return GestureDetector(
                        onTap: () {
                          // 화면 전환 로직
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Solve()),
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
                              Text(
                                subject,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'Bold',
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Text(
                                    '12/32',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(flex: 1),  // 사용 가능한 공간을 차지합니다.
                                  GestureDetector(
                                    onTap: () {
                                      // onTap 로직
                                      // 예를 들어, 다음 화면으로 이동하거나 다이얼로그를 표시
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF3D6094),
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
