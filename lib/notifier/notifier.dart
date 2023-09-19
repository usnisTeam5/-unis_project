import 'package:flutter/material.dart';

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
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.blue.shade500],
        ),
      ),
      child: Row(
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

          _buildTab(0, '알림'),
          _buildTab(1, '대화'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () {
          onTabSelected(index);
        },
      ),
    );
  }
}

class _CustomDrawerState extends State<Notifier> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    ListView(
      children: [
        ListTile(
          title: Text('알림 1'),
          subtitle: Text('알림 내용 1'),
        ),
        ListTile(
          title: Text('알림 2'),
          subtitle: Text('알림 내용 2'),
        ),
        // 여기에 추가 알림을 넣으세요
      ],
    ),
    ListView(
      children: [
        ListTile(
          title: Text('1대1 대화 1'),
          subtitle: Text('대화 내용 1'),
        ),
        ListTile(
          title: Text('1대1 대화 2'),
          subtitle: Text('대화 내용 2'),
        ),
        // 여기에 추가 대화를 넣으세요
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
