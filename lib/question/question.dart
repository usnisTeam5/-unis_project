import 'package:flutter/material.dart';

void main() {
  runApp(const Question());
}

class Question extends StatelessWidget {
  const Question({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '궁금한 게 생겼을 때 질문하세요!',
          style: TextStyle(
            fontFamily: 'ExtraBold',
          ),
        ),
        actions: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: 300.0),
            child: TextButton(
              onPressed: () {},
              // TODO: 버튼이 눌렸을 때 실행할 로직을 여기에 작성
              child: Text(
                '질문하기',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Bold',
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
      ),
      body: Container(
        color: Colors.grey,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('조언/문제: 조언 #${index + 1}'),
                  Text('과목: 과목명 #${index + 1}'),
                  Text('금액: \$${(index + 1) * 10}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
