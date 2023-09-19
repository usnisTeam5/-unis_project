import 'package:flutter/material.dart';
import '../myQHistory/myQHistory.dart';
import '../question/question.dart';
import '../profile/profile.dart';
import '../menu/menu.dart';
import '../notifier/notifier.dart';
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

// MyHomePage 클래스: 홈 화면 구성
class MyHomePage extends StatelessWidget {
  final HomeController _controller = HomeController(); // HomeController 인스턴스 생성
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double iconSize = width * 0.10; // 아이콘 크기 설정
    double fontSize = height * 0.02; // 텍스트 크기 설정

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
                  return const Question();  // question.dart 파일의 MyApp 클래스를 여기서 호출
                case 1:
                  return const MyQHistory();
                case 2:
                  return const Profile();
                case 3:
                  return Center(child: Text('스터디'));
                default:
                  return Center(child: Text('문답'));
              }
            },
          ),
          alram_and_menu(width: width, scaffoldKey: scaffoldKey ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _controller.currentIndexNotifier,
        builder: (context, currentIndex, _) {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: _controller.onItemTapped,
            // 아이템 선택 시 컨트롤러의 메서드 호출
            selectedFontSize: fontSize,
            // 선택된 아이템의 텍스트 크기 설정
            unselectedFontSize: fontSize,
            // 선택되지 않은 아이템의 텍스트 크기 설정
            selectedItemColor: Colors.blue,
            // 선택된 아이템의 색상
            unselectedItemColor: Colors.grey,
            // 선택되지 않은 아이템의 색상
            type: BottomNavigationBarType.fixed,
            // 모든 아이콘 아래에 항상 레이블 표시
            items: const [
              // 하단바 아이템 목록
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                //Icon(currentIndex == 0 ? Icons.question_answer_outlined : Icons.question_answer_outlined, color: currentIndex == 0 ? Colors.blue : Colors.grey, size: iconSize),
                label: '문답', // 아이콘 아래에 표시할 텍스트
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_outlined),
                //Icon(currentIndex == 1 ? Icons.folder_outlined : Icons.folder_outlined, color: currentIndex == 1 ? Colors.blue : Colors.grey, size: iconSize),
                label: '내 문답', // 아이콘 아래에 표시할 텍스트
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                //Icon(currentIndex == 2 ? Icons.account_circle_outlined : Icons.account_circle_outlined, color: currentIndex == 2 ? Colors.blue : Colors.grey, size: iconSize),
                label: 'My 프로필', // 아이콘 아래에 표시할 텍스트
              ), //haha
              BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account_outlined),
                //Icon(currentIndex == 3 ? Icons.supervisor_account_outlined : Icons.supervisor_account_outlined, color: currentIndex == 3 ? Colors.blue : Colors.grey, size: iconSize),
                label: '스터디', // 아이콘 아래에 표시할 텍스트
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
  });

  final double width;
  final GlobalKey<ScaffoldState> scaffoldKey; // 여기서 scaffoldKey를 추가합니다

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
              margin: const EdgeInsets.only(bottom: 20), // 원 사이의 간격을 조정
              width: width * 0.10,
              height: width * 0.10,
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
              child: Icon(Icons.notifications_outlined, size: width * 0.06,color: Colors.grey,),
            ),
          ),
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openEndDrawer(); // 여기서 drawer를 열어줍니다
            },
            child: Container( // 목록
              width: width * 0.10,
              height: width * 0.10,
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
              child: Icon(Icons.menu_outlined, size: width * 0.06, color: Colors.grey,),
            ),
          ),
        ],
      ),
    );
  }
}
