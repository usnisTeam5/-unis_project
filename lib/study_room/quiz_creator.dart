//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/models/study_info.dart';
import 'package:unis_project/my_quiz/solve.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import 'dart:math';

import '../models/quiz_model.dart';
import '../view_model/quiz_view_model.dart';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       theme: ThemeData(
//         fontFamily: 'Bold',
//       ),
//       home: QuizCreator(),
//     );
//   }
// }

class QuizCreator extends StatefulWidget {
  MyStudyInfo myStudyInfo;
  String folderName;
  QuizCreator(this.myStudyInfo,  this.folderName);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizCreator> {
  // 과목 목록
  final ValueNotifier<int> selectedQuestionCount = ValueNotifier<int>(1);
  final ValueNotifier<String> selectedQuestionType = ValueNotifier<String>('개념');
  final ValueNotifier<String> selectedSubject = ValueNotifier<String>('');
  int count = 0;

  @override
  void dispose() {
    selectedSubject.dispose();
    selectedQuestionType.dispose();
    selectedQuestionCount.dispose();
    super.dispose();
  }
  //final List<String> subjects = [];
  final List<String> kindOfProbs = [
    //'다지선다',
    '개념',
  ];
  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width ,500.0);
    final height = MediaQuery.of(context).size.height;
    final user = Provider.of<UserProfileViewModel>(context,listen:false);
    final quizViewModel = Provider.of<QuizViewModel>(context,listen: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
      // context를 사용하여 UserProfileViewModel에 접근
      //print("sdfsdfsdfsadfasdfsadfasdf");
      if(count == 0) {
        count ++;
        print("count: ${count}");
        await quizViewModel.fetchMyQuiz(user.nickName, widget.myStudyInfo.course);
      }
    });


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
      body:
      (quizViewModel.isLoading || count == 0)
          ?  Center(child: CircularProgressIndicator())
          :SingleChildScrollView(
        child: Column(
          children: [
            QuestionCountSelection(),
            QuestionTypeSelection(kindOfProbs: kindOfProbs),
            SubjectSelection(subjects: quizViewModel.folderList, folderName: widget.folderName),
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
              //quizViewModel.
              if(quizViewModel.folderList == 0)
              print('선택된 주제: ${selectedSubject.value}');
              print('선택된 문제 유형: ${selectedQuestionType.value}');
              print('선택된 문제 수: ${selectedQuestionCount.value}');
            }, // 생성 로직 넣기
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
  List<QuizInfoDto> subjects;
  final String folderName;
  SubjectSelection({
    required this.subjects,
    required this.folderName,
  });

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  int _selectedSubjectIndex = 0;  // 기본적으로 첫 번째 주제가 선택됩니다.

  @override
  Widget build(BuildContext context) {
    if(widget.subjects.length == 0 ){ // 여기부터 하면 됨.
      List<QuizInfoDto> temp = [QuizInfoDto(quizKey: 0, quizName: widget.folderName, quizNum: 0, curNum: 0)];
      widget.subjects = temp;
    }
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
                    "      ${widget.subjects[index].quizName}",
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
