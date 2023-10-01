import 'package:flutter/material.dart';
import '../chat/chat.dart';
void main() {
  runApp(const Question());
}

class Question extends StatelessWidget {
  const Question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionPage(),
    );
  }
}

class MainGradient extends LinearGradient {
  MainGradient()
      : super(
    colors: [Color(0xFF59D9D5), Color(0xFF2A7CC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.white,
        ),
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.8,  // 80% of AppBar width for title
                  child: Text(
                    '궁금한 게 생겼을 때 질문하세요!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'ExtraBold',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  width: 100,  // 20% of AppBar width for button
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionFormPage()),
                      );
                    },
                    child: Text(
                      '질문하기',
                      style: TextStyle(
                        fontFamily: 'ExtraBold',
                        color: Colors.blue,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(30),
                          right: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      body: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('질문  '),
                        Text('컴퓨터 그래픽스'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${(index + 1) * 2000}'),
                        Icon(Icons.monetization_on_outlined)  // 여기에 포인트 아이콘을 사용했습니다.
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuestionFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('질문하기'),
      ),
      // ... (여기에 폼과 관련된 코드 추가)
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;

  DetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Text('Item #$index'),
      ),
    );
  }
}
