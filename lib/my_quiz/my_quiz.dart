import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import '../view_model/quiz_view_model.dart';
import 'quiz_folder.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Bold', // ExtraBold 글꼴을 사용하려면 앱에 폰트 파일을 추가해야 합니다.
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final  width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;
    int count = 0;
    return ChangeNotifierProvider(
        create: (_) => QuizViewModel(),
        builder: (context, child) {

          final quizViewModel = Provider.of<QuizViewModel>(context, listen: true);
          final user =  Provider.of<UserProfileViewModel>(context, listen: false);
          WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
            // context를 사용하여 UserProfileViewModel에 접근
            //print("sdfsdfsdfsadfasdfsadfasdf");
            if(count == 0) {
              count ++;
              print("count: ${count}");
              await quizViewModel.fetchUserCourses(user.nickName); // **
            }
          });

        return Scaffold(
          appBar: AppBar(
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
          body: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10.0),
            itemCount: quizViewModel.courses.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // 화면 전환 로직
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizFolderScreen(quizViewModel.courses[index])),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10.0),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    quizViewModel.courses[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Bold',
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.grey[200],  // 아주 밝은 회색 배경
        );
      }
    );
  }
}
