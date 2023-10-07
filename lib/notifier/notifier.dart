import 'package:flutter/material.dart';
import 'package:unis_project/chat/chat.dart';
import '../css/css.dart';
import 'dart:math';
void main() {
  runApp(NotifierApp());
}

class NotifierApp extends StatelessWidget {
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
        title: Text('Home Screen'),
      ),
      drawer: Notifier(),
    );
  }
}

class Notifier extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class Header extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const Header({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
          color: Colors.white,
        ),
      child: Row(
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 16.0),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[400],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          _buildTab(0, '알림',width),
          _buildTab(1, '대화',width),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title , double width) {

    final isSelected = selectedIndex == index;
    return GestureDetector(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child:
          isSelected ? GradientText(width: width, text: title, tStyle: 'Bold', tSize: 0.06)
                    :  Text( title, style: TextStyle(
                              color:  Colors.grey[300],
                              fontSize: width*0.06,
                              fontFamily: 'Bold'
                              ),
                      ),
        ),
      ),
      onTap: () {
        onTabSelected(index);
      },
    );
  }
}

class _CustomDrawerState extends State<Notifier> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            AlarmDetailPopup(
                title: "알림 제목",
                date: "알림 일자",
                content: "알림 내용"
            ).show(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '스터디방1',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontFamily: 'Bold'
                      ),
                    ),
                    Spacer(),
                    Text(
                      '07/12 15:38  ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        fontFamily: 'Round'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  '새로운 스터디원이 들어왔어요',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[700],
                      fontFamily: 'Round',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '친구${index}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Bold'
                      ),
                    ),
                    Spacer(),
                    Text(
                      '07/12 15:38  ',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                          fontFamily: 'Round'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  '안녕하세요',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[700],
                    fontFamily: 'Round',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Drawer(
          child: Column(
            children: [
              Header(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
                child: Container(
                  decoration: BoxDecoration(
                    gradient: MainGradient(),
                  ),
                  height: 2.0,  // Set the thickness of the undedsrline
                ),
              ),
              Expanded(
                child: _screens[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlarmDetailPopup {
  final String title;
  final String date;
  final String content;

  AlarmDetailPopup({required this.title, required this.date, required this.content});


  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text(this.title, style: TextStyle(fontFamily: 'Bold', fontSize: 18))),
              SizedBox(width: 8.0),  // 간격을 조정할 수 있습니다.
              Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 10, fontFamily: 'Bold')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(content, style: TextStyle(fontSize: 10, fontFamily: 'Bold')),
            ],
          ),
          actions: [
            TextButton(
              child: Text("닫기", style: TextStyle(fontFamily: 'Bold')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

