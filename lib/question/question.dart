import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../chat/chat.dart';
import '../css/css.dart';
import '../question/post_question.dart';
import 'dart:math';

void main() {
  runApp(const Question());
}

class Question extends StatelessWidget {
  const Question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);


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
                  width: width,
                  text: '  궁금한 게 생겼을 때 질문하세요!',
                  tStyle: 'ExtraBold',
                  tSize: 0.045,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostQuestionPage()),
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
                        fontSize: width *0.04,
                      ),
                      overflow: TextOverflow.ellipsis,
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
          itemCount: 15,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == 14 ? 16.0 : 8.0,
            ),
            child: QuestionItem(index, '컴퓨터 그래픽스와 휴먼인터페이스와 수치해석'),
          ),
        ),
      ),
    );
  }
}



class QuestionItem extends StatelessWidget {
  final int index;
  final String subjectName;

  QuestionItem(this.index, this.subjectName);

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only( // 리스트 마진
          top: index == 0 ? 20 : 7,
          bottom: index == 14 ? 30 : 1,
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
                Container(
                  width: width- 210,
                  child: Text(
                    subjectName,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Bold',
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                SizedBox(width: 1), // 2000과 아이콘 사이의 간격
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DetailPage extends StatelessWidget {
  final int index;

  DetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
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
