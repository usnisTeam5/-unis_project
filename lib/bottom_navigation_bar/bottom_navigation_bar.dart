import 'package:flutter/material.dart';
import 'package:unis_project/view_model/login_result_view_model.dart';
import '../css/css.dart';
import 'package:unis_project/find_study/find_study.dart';
import 'package:unis_project/my_quiz/my_quiz.dart';
import 'package:unis_project/my_study/my_study.dart';
import '../myQHistory/myQHistory.dart';
import '../question/question.dart';
import '../profile/profile.dart';
import '../menu/menu.dart';
import '../notifier/notifier.dart';
import 'dart:io';
import 'dart:math';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// MyApp 클래스: 앱의 진입점
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
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: MyHomePage(), // 홈 화면 설정
    );
  }
}
//func( int a, int b) // func( a : 1 , b : 2)
// HomeController 클래스: 하단바 상태 관리와 로직 처리
class HomeController {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  ValueNotifier<int> get currentIndexNotifier => _currentIndexNotifier;

  // 하단바 아이템 선택 시 호출되는 메서드
  void onItemTapped(int index) {
    _currentIndexNotifier.value = index;
  }
}

// MyHomePage 클래스: 홈 화면 구성
class MyHomePage extends StatelessWidget {
  final HomeController _controller = HomeController(); // HomeController 인스턴스 생성
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width,500.0);
    final double height = MediaQuery.of(context).size.height;
    double iconSize = width * 0.10; // 아이콘 크기 설정
    double fontSize = width * 0.03; // 텍스트 크기 설정

    final loginViewModel = context.watch<LoginViewModel>();
    final key = loginViewModel.userKey;
    final nickname = loginViewModel.userNickName;
    print(key);
    print(nickname);


    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          // Drawer가 열려있으면 닫습니다.
          Navigator.of(context).pop();
          return false;
        }
        if (scaffoldKey.currentState!.isEndDrawerOpen) {
          // Drawer가 열려있으면 닫습니다.
          Navigator.of(context).pop();
          return false;
        }
        return await _showExitConfirmationDialog(context);
        // 뒤로 가기 동작 방지
      },
      child: Scaffold(
        key: scaffoldKey, // key를 Scaffold에 할당합니다
        endDrawer: Menu(),
        drawer: Notifier(),
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _controller.currentIndexNotifier,
              builder: (context, currentIndex, _) {
                switch (currentIndex) {
                  case 0:
                    return const QuestionPage();  // question.dart 파일의 MyApp 클래스를 여기서 호출
                  case 1:
                    return const MyQHistory(selectedIndex: 0);
                  case 2:
                    return const Profile();
                  case 3:
                    return StudyScreen();
                  case 4:
                    return QuizScreen();
                  default:
                    return Center(child: Text('문답'));
                }
              },
            ),
            alram_and_menu(width: width, scaffoldKey: scaffoldKey ,controller: _controller),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _controller.currentIndexNotifier,
          builder: (context, currentIndex, _) {
            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: _controller.onItemTapped,
              selectedLabelStyle: TextStyle(fontFamily: 'Round'),
              unselectedLabelStyle: TextStyle(fontFamily: 'Round'),
              // 아이템 선택 시 컨트롤러의 메서드 호출
              selectedFontSize: fontSize,
              // 선택된 아이템의 텍스트 크기 설정
              unselectedFontSize: fontSize,
              // 선택되지 않은 아이템의 텍스트 크기 설정
              //selectedItemColor: Colors.blue,
              // 선택된 아이템의 색상
              unselectedItemColor: Colors.grey,
              // 선택되지 않은 아이템의 색상
              type: BottomNavigationBarType.fixed,
              // 모든 아이콘 아래에 항상 레이블 표시
              items: [
                BottomNavigationBarItem(
                  icon: currentIndex == 0
                      ? GradientIcon(iconData: Icons.question_answer_outlined)
                      : Icon(Icons.question_answer_outlined),
                  label: '문답',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 1
                      ? GradientIcon(iconData: Icons.folder_outlined)
                      : Icon(Icons.folder_outlined),
                  label: '내 문답',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 2
                      ? GradientIcon(iconData: Icons.account_circle_outlined)
                      : Icon(Icons.account_circle_outlined),
                  label: 'My 프로필',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 3
                      ? GradientIcon(iconData: Icons.supervisor_account_outlined)
                      : Icon(Icons.supervisor_account_outlined),
                  label: '스터디',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 4
                      ? GradientIcon(iconData: Icons.question_mark_outlined)
                      : Icon(Icons.question_mark_outlined),
                  label: '퀴즈',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('앱 종료'),
        content: Text('정말로 앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            child: Text('취소'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('확인'),
            onPressed: () => exit(0),
          ),
        ],
      ),
    ) ??
        false; // 사용자가 다이얼로그의 바깥 영역을 탭해서 다이얼로그를 닫은 경우 false를 반환합니다.
  }
}

class alram_and_menu extends StatelessWidget {
  const alram_and_menu({
    super.key,
    required this.width,
    required this.scaffoldKey, // 여기서 scaffoldKey를 추가합니다
    required this.controller,
  });

  final double width;
  final GlobalKey<ScaffoldState> scaffoldKey; // 여기서 scaffoldKey를 추가합니다
  final HomeController controller;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer(); // 여기서 drawer를 열어줍니다
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10), // 원 사이의 간격을 조정
              width: width * 0.13,
              height: width * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.notifications_outlined, size: width * 0.06,color: Colors.grey,),
            ),
          ),
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openEndDrawer(); // 여기서 drawer를 열어줍니다
            },
            child: Container( // 목록
              //margin: const EdgeInsets.only(bottom: 10), // 원 사이의 간격을 조정
              width: width * 0.13,
              height: width * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.menu_outlined, size: width * 0.06, color: Colors.grey,),
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: controller.currentIndexNotifier,
            builder: (context, currentIndex, _) {
              return Visibility(
                visible: currentIndex == 3,
                child: GestureDetector(
                  onTap: () {
                    // 스터디 찾기를 호출합니다.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindStudyScreen()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: width * 0.13,
                    height: width * 0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, size: width * 0.06,color: Colors.grey,),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
