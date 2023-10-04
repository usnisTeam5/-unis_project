import 'package:flutter/material.dart';
import 'package:unis_project/my_quiz/solve.dart';
import '../css/css.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'Bold',
      ),
      home: QuizCreator(),
    );
  }
}

class QuizCreator extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizCreator> {
  // 과목 목록
  final ValueNotifier<int> selectedQuestionCount = ValueNotifier<int>(1);
  final ValueNotifier<String> selectedQuestionType = ValueNotifier<String>('다지선다');
  final ValueNotifier<String> selectedSubject = ValueNotifier<String>('');

  @override
  void dispose() {
    selectedSubject.dispose();
    selectedQuestionType.dispose();
    selectedQuestionCount.dispose();
    super.dispose();
  }
  final List<String> subjects = [
    '1강',
    '2강',
    '3강',
    '4강',
  ];
  final List<String> kindOfProbs = [
    '다지선다',
    '개념',
  ];
  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width ,500.0);
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
            QuestionCountSelection(),
            QuestionTypeSelection(kindOfProbs: kindOfProbs),
            SubjectSelection(subjects: subjects),
          ],
        ),
      ),
      bottomNavigationBar:  Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: MainGradient(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Solve()),
              );
              print('선택된 주제: ${selectedSubject.value}');
              print('선택된 문제 유형: ${selectedQuestionType.value}');
              print('선택된 문제 수: ${selectedQuestionCount.value}');
            }
            , // 생성 로직 넣기
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '생성하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Bold',
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectSelection extends StatefulWidget {
  final List<String> subjects;

  SubjectSelection({
    required this.subjects,
  });

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  int _selectedSubjectIndex = 0;  // 기본적으로 첫 번째 주제가 선택됩니다.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 8,),
          Text(
            '   폴더 선택(개인)',
            style: TextStyle(color: Colors.grey, fontFamily: 'Bold', fontSize: 20),
          ),
          SizedBox(height: 23,),
          ...List.generate(
            widget.subjects.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 3.0),
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                //borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 체크박스를 오른쪽으로 이동시킵니다.
                children: [
                  Text(
                    "      ${widget.subjects[index]}",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Bold',fontSize: 20),
                  ),
                  Radio(
                    value: index,
                    groupValue: _selectedSubjectIndex,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedSubjectIndex = value!;
                      });
                    },
                    activeColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionTypeSelection extends StatefulWidget {

  final List<String> kindOfProbs;

  QuestionTypeSelection({required this.kindOfProbs});

  @override
  _QuestionTypeSelectionState createState() => _QuestionTypeSelectionState();
}

class _QuestionTypeSelectionState extends State<QuestionTypeSelection> {
  int _selectedSubjectIndex = 0;  // 기본적으로 첫 번째 주제가 선택됩니다.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Text(
            '   문제 유형',
            style: TextStyle(color: Colors.grey, fontFamily: 'Bold', fontSize: 20),
          ),
          SizedBox(height: 23,),
          ...List.generate(
            widget.kindOfProbs.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 3.0),
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                //borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 체크박스를 오른쪽으로 이동시킵니다.
                children: [
                  Text(
                    "      ${widget.kindOfProbs[index]}",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Bold',fontSize: 20),
                  ),
                  Radio(
                    value: index,
                    groupValue: _selectedSubjectIndex,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedSubjectIndex = value!;
                      });
                    },
                    activeColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCountSelection extends StatefulWidget {
  // final ValueNotifier<int> selectedQuestionCount;
  //
  // QuestionCountSelection({
  //   required this.selectedQuestionCount,
  // });

  @override
  _QuestionCountSelectionState createState() => _QuestionCountSelectionState();
}

class _QuestionCountSelectionState extends State<QuestionCountSelection> {
  int _selectedQuestionCount = 1;  // 기본적으로 1이 선택됩니다.

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!,width: 3.0)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 20.0,right: 30,bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '      문제 수',
            style: TextStyle(color: Colors.grey, fontFamily: 'Bold', fontSize: 20),
          ),
          Spacer(),

          Container(
            padding: EdgeInsets.only(left: 11.0),
            width: 50,
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 2.0),
            ),
            child: Center(
              child: DropdownButton<int>(
                underline: SizedBox.shrink(),
                iconSize: 0.0,
                value: _selectedQuestionCount,
                items: List.generate(
                  10,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Colors.grey, fontFamily: 'Bold',fontSize: 20),
                    ),
                  ),
                ),
                onChanged: (int? value) {
                  setState(() {
                    _selectedQuestionCount = value!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
