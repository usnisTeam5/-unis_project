import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:unis_project/models/quiz_model.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';

import '../css/css.dart';
import '../view_model/quiz_view_model.dart';
class EditQuizScreen extends StatefulWidget {

  QuizInfoDto folder;
  bool isSolved;
  EditQuizScreen(this.folder, this.isSolved);

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  int count =0;
  late List<TextEditingController> _controllers; // 각 문제의 텍스트 필드를 관리하기 위한 컨트롤러 목록

  @override
  void initState() {
    super.initState();
    _controllers = []; // 컨트롤러 초기화
  }

  _saveQuiz() async {
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    // 각 텍스트 필드의 내용을 QuizDto 객체에 반영
    // quizViewModel.quizQuestions = _controllers;
    // 수정된 문제들을 백엔드로 전송

    await quizViewModel.updateQuiz(
        widget.folder.quizKey,
        quizViewModel.quizQuestions,
    );

    // 저장 완료 알림
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('저장이 완료되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );

  }

  void _addNewQuestion() {
    setState(() {
      //_controllers.add(TextEditingController());
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      quizViewModel.quizQuestions.add(
        QuizDto(quizNum: quizViewModel.quizQuestions.length, question: '', answer: '', isSolved: widget.isSolved),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    //final user =  Provider.of<UserProfileViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
      if(count == 0) {
       // print("count");
        count ++;
        print("count: ${count}");
        quizViewModel.fetchQuiz(widget.folder.quizKey);
        // 문제 목록을 위한 텍스트 필드 생성
        //_controllers = quizViewModel.quizQuestions;
      }
    });

   // print("count :$count, quizViewModel.isLoading: ${quizViewModel.isLoading}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);  // 로그인 화면으로 되돌아가기
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30.0,
            ),
            color: Color(0xFF3D6094),
            onPressed: _addNewQuestion,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,  // Title을 중앙에 배치
        title:  GradientText(width: width, text: '문제 수정 - ${widget.folder.quizName}', tSize: 0.06, tStyle: 'Bold'),
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
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (var i = 0; i < quizViewModel.quizQuestions.length; i++)
                quizViewModel.quizQuestions[i].isSolved == widget.isSolved
                    ?  _buildQuestionField(i, quizViewModel.quizQuestions[i])
                    : Container(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: MainGradient(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: _saveQuiz,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '저장',
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

  Widget _buildQuestionField(int index, QuizDto quiz) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: quiz.question,
              onChanged: (value) => quiz.question = value,
              decoration: InputDecoration(
                labelText: '문제 ${index + 1}',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              initialValue: quiz.answer,
              onChanged: (value) => quiz.answer = value,
              decoration: InputDecoration(
                labelText: '정답',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝에 요소를 배치
              children: [
                Text(
                  "",
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeQuestion(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _removeQuestion(int index) {
    setState(() {
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      quizViewModel.quizQuestions.removeAt(index);
    });
  }
}

