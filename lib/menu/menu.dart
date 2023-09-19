import 'package:flutter/material.dart';

void main() {
  runApp(const MenuApp());
}

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Header(),
              ListTile(
                title: Text(
                  '공지사항',
                  style: TextStyle(color: Colors.blue, fontFamily: 'Bold'),
                ),
                trailing: Icon(Icons.navigate_next, color: Colors.blue),
                onTap: () {
                  // Navigate to the notice screen
                },
              ),
              ListTile(
                title: Text(
                  '이용가이드',
                  style: TextStyle(color: Colors.blue, fontFamily: 'Bold'),
                ),
                trailing: Icon(Icons.navigate_next, color: Colors.blue),
                onTap: () {
                  // Navigate to the usage guide screen
                },
              ),
              ListTile(
                title: Text(
                  '고객센터',
                  style: TextStyle(color: Colors.blue, fontFamily: 'Bold'),
                ),
                trailing: Icon(Icons.navigate_next, color: Colors.blue),
                onTap: () {
                  // Navigate to the customer service screen
                },
              ),
              ListTile(
                title: Text(
                  '앱 설정',
                  style: TextStyle(color: Colors.blue, fontFamily: 'Bold'),
                ),
                trailing: Icon(Icons.navigate_next, color: Colors.blue),
                onTap: () {
                  // Navigate to the app settings screen
                },
              ),
            ],
          ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0, // 원하는 높이로 설정
      //padding: EdgeInsets.all(16.0), // 내부 패딩 추가
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.blue.shade500],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 16.0), // 왼쪽에 여백 추가
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
                Navigator.pop(context);
            },
          ),
          Icon(
            Icons.menu,
            color: Colors.white,
            size: 40.0,
          ),
          SizedBox(width: 48), // 이 부분은 IconButton과 동일한 공간을 차지하기 위해 추가되었습니다.
        ],
      ),
    );
// 이후 ListTile 항목들
  }
}

