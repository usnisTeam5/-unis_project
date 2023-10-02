import 'package:flutter/material.dart';
import '../chat/chat.dart';
import '../css/css.dart';

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

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientText(
                  width: constraints.maxWidth * 1.25,
                  text: '  궁금한 게 생겼을 때 질문하세요!',
                  tStyle: 'ExtraBold',
                  tSize: 0.04,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuestionFormPage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      gradient: MainGradient(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '질문하기',
                      style: TextStyle(
                        fontFamily: 'ExtraBold',
                        color: Colors.white,
                        fontSize: 18,
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
        color: Colors.grey[200],
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => QuestionItem(index),
        ),
      ),
    );
  }
}

class QuestionItem extends StatelessWidget {
  final int index;

  QuestionItem(this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only( // 리스트 마진
          top: index == 0 ? 20 : 10,
          bottom: 10,
          left: 30,
          right: 30,
        ),
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
                Text(
                  '  질문   ',
                  style: TextStyle(
                    color: Color(0xFF3D6094),
                    fontFamily: 'Bold',
                    fontSize: 17,
                  ),
                ),
                Text(
                  '컴퓨터 그래픽스',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Round',
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${(index + 1) * 2000}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Bold',
                  ),
                ),
                SizedBox(width: 5), // 2000과 아이콘 사이의 간격
                Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.yellow[600],
                )
              ],
            ),
          ],
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
