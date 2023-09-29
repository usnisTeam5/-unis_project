import 'package:flutter/material.dart';
import 'package:unis_project/chat/chat.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: MyQHistory(),
    );
  }
}

class MyQHistory extends StatefulWidget {
  const MyQHistory({super.key});

  @override
  _QuestionAnswerScreenState createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<MyQHistory> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('내 문답'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Material(
            color: Colors.white,  // TabBar의 배경색을 흰색으로 설정
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: '질문 목록 >'),
                Tab(text: '답변 목록 >'),
              ],
              indicatorColor: Colors.black,  // 선택된 탭의 표시자 색상을 변경합니다.
              labelColor: Colors.black,  // 선택된 탭의 레이블 색상을 변경합니다.
              unselectedLabelColor: Colors.grey,  // 선택되지 않은 탭의 레이블 색상을 변경합니다.
            ),
          ),
        ),
        ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildListView('문제', '컴퓨터그래픽스', '진행'),
          buildListView('문제', '컴퓨터그래픽스', '완료'),
        ],
      ),
    );
  }

  ListView buildListView(String title, String subject, String status) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$title ',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        TextSpan(
                          text: subject,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
