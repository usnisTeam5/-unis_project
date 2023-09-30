import 'package:flutter/material.dart';
import 'package:unis_project/chat/chat.dart';
import 'package:unis_project/css/css.dart';

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
  int _selectedIndex = 0;  // Add this line

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      setState(() {
        _selectedIndex = _tabController?.index ?? 0;  // Update the selected index when the tab selection changes
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,  // Title을 중앙에 배치
        title: GradientText(width: width, text: '내 문답', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,  // Set the thickness of the underline
          ),
        ),
      ),
      body : Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      //top: BorderSide(color: Colors.transparent),  // Or use MainGradient here
                      bottom: BorderSide(color: Colors.transparent,width: 2.0),  // Or use MainGradient here
                    ),
                    gradient: MainGradient(),
                  ),
                  child: Material(
                    color: Colors.white,  // TabBar의 배경색을 흰색으로 설정
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          icon: _selectedIndex == 1 ?
                                GradientText( width: width, text: '질문 목록 >', tSize: 0.05, tStyle: 'Bold',)  // Adjust the size as neededtStyle: 'Bold'  // Adjust the style as needed
                                : Text('질문 목록 >', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.05))
                        ),
                        Tab(
                          icon: _selectedIndex == 0 ?
                          GradientText(
                              width: width,
                              text: '답변 목록 >',
                              tSize: 0.05,  // Adjust the size as needed
                              tStyle: 'Bold'  // Adjust the style as needed
                          )
                          : Text('답변 목록 >', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.05))
                        ),
                      ],
                      indicator: BoxDecoration(
                        gradient: MainGradient(),
                      ),
                      labelColor: Colors.white,  // 선택된 탭의 레이블 색상을 변경합니다.
                      //unselectedLabelColor: Colors.grey,  // 선택되지 않은 탭의 레이블 색상을 변경합니다.
                    ),
                  ),
              ),
          ),
          Expanded(  // <--- 이 줄을 추가
            child: TabBarView(
              controller: _tabController,
              children: [
                buildListView('문제  ', '컴퓨터그래픽스', '진행'),
                buildListView('문제  ', '컴퓨터그래픽스', '완료'),
              ],
            ),
          ),  // <--- 이 줄을 추가
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
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),  // Add this line for a light grey border
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$title ',
                        style: TextStyle(color: Color(0xFF3D6094), fontSize: 16 , fontFamily: 'Bold'),
                      ),
                      TextSpan(
                        text: subject,
                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Round'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: ShapeDecoration(
                    color: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Bold'),
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}
