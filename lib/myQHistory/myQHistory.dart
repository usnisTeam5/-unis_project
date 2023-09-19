import 'package:flutter/material.dart';

void main() {
  runApp(const MyQHistory());
}

class MyQHistory extends StatelessWidget {
  const MyQHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내 문답',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyQHistoryPage(),
    );
  }
}

class MyQHistoryPage extends StatefulWidget {
  @override
  _MyQHistoryPageState createState() => _MyQHistoryPageState();
}

class _MyQHistoryPageState extends State<MyQHistoryPage> {
  bool _isQuestionSelected = true;
  bool _showList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildToggleButtonRow(),
          buildQuestionListToggleButton(),
          Expanded(child: _showList ? QuestionList() : Container()),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        '내 문답',
        style: TextStyle(
          color: Colors.blue,
          fontFamily: 'Bold',
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
    );
  }

  Row buildToggleButtonRow() {
    return Row(
      children: [
        buildElevatedButton('질문 목록', _isQuestionSelected),
        buildElevatedButton('답변 목록', !_isQuestionSelected),
      ],
    );
  }

  Expanded buildElevatedButton(String text, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isQuestionSelected = !_isQuestionSelected;
          });
        },
        child: Text(text),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return isSelected ? Colors.white : Colors.blue;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return isSelected ? Colors.blue : Colors.white;
            },
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: 20.0),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildQuestionListToggleButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showList = !_showList;
        });
      },
      child: Text('문제 목록'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20.0)),
      ),
    );
  }
}

class QuestionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text('문제 #${index + 1}'),
        );
      },
    );
  }
}
