import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade500, Colors.blue.shade500],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade800],
                ),
              ),
              child: Text(
                '목록',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NanumSquareRoundB',
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                '공지사항',
                style: TextStyle(color: Colors.blue, fontFamily: 'NanumSquareRoundB'),
              ),
              trailing: Icon(Icons.navigate_next, color: Colors.blue),
              onTap: () {
                // Navigate to the notice screen
              },
            ),
            ListTile(
              title: Text(
                '이용가이드',
                style: TextStyle(color: Colors.blue, fontFamily: 'NanumSquareRoundB'),
              ),
              trailing: Icon(Icons.navigate_next, color: Colors.blue),
              onTap: () {
                // Navigate to the usage guide screen
              },
            ),
            ListTile(
              title: Text(
                '고객센터',
                style: TextStyle(color: Colors.blue, fontFamily: 'NanumSquareRoundB'),
              ),
              trailing: Icon(Icons.navigate_next, color: Colors.blue),
              onTap: () {
                // Navigate to the customer service screen
              },
            ),
            ListTile(
              title: Text(
                '앱 설정',
                style: TextStyle(color: Colors.blue, fontFamily: 'NanumSquareRoundB'),
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
