import 'package:flutter/material.dart';
import '../css/css.dart';
void main() {
  runApp(const MenuApp());
}

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Scaffold(
            appBar: Header(),
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
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
                ListTile(
                  title: Text(
                    '포인트 충전 및 현금화',
                    style: TextStyle(color: Colors.blue, fontFamily: 'Bold'),
                  ),
                  trailing: Icon(Icons.navigate_next, color: Colors.blue),
                  onTap: () {
                    // Navigate to the app settings screen
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height, // PreferredSizeWidget에서 제공하는 높이 사용
        decoration: BoxDecoration(
          gradient: MainGradient(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: const EdgeInsets.only(left: 16.0),
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
            SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0); // 원하는 높이 제공
}
