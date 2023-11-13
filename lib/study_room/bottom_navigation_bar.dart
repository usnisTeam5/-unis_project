import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';
import 'package:unis_project/study_room/quiz.dart';
import '../chat/chat.dart';
import '../chat/studychat.dart';
import '../menu/menu.dart';
import '../notifier/notifier.dart';
import 'home.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

// MyApp 클래스: 앱의 진입점
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // 앱 전체 테마 설정
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeController _controller = HomeController(); // HomeController 인스턴스 생성
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width,500.0);
    final double height = MediaQuery.of(context).size.height;
    double iconSize = width * 0.10; // 아이콘 크기 설정
    double fontSize = width * 0.03;// 텍스트 크기 설정

    return Scaffold(
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
                  return Home();  // question.dart 파일의 MyApp 클래스를 여기서 호출
                case 1:
                  return StudyChatScreen();
                case 2:
                  return QuizFolderScreen();
                default:
                  return Center(child: Text('퀴즈!!'));
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
                    ? GradientIcon(iconData: Icons.home)
                    : Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1
                    ? GradientIcon(iconData: Icons.chat_bubble_outline)
                    : Icon(Icons.chat_bubble_outline_outlined),
                label: '채팅',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? GradientIcon(iconData: Icons.quiz_outlined)
                    : Icon(Icons.quiz_outlined),
                label: '퀴즈 생성',
              ),
            ],
          );
        },
      ),
    );
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
      child: ValueListenableBuilder<int>(
        valueListenable: controller.currentIndexNotifier,
        builder: (context, currentIndex, _) {
          return Visibility(
            visible: currentIndex == 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer(); // 여기서 drawer를 열어줍니다
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    // 원 사이의 간격을 조정
                    width: width * 0.13,
                    height: width * 0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined, size: width * 0.06,
                      color: Colors.grey,),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState
                        ?.openEndDrawer(); // 여기서 drawer를 열어줍니다
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
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.menu_outlined, size: width * 0.06,
                      color: Colors.grey,),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
