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
            fontFamily: 'NanumSquareRoundEB',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Question',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),
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
                  Text('Advice/Problem: Advice #${index + 1}'),
                  Text('Subject: Subject #${index + 1}'),
                  Text('Amount: \$${(index + 1) * 10}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
