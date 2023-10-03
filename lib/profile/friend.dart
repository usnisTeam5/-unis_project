import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';
void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: MyListScreen(),
    );
  }
}

class MyListScreen extends StatefulWidget {
  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget gradientTabText(double width, String text, int tabIndex) {
    return _tabController?.index == tabIndex
        ? GradientText(
      width: width,
      text: text,
      tStyle: 'Bold',
      tSize: 0.04,
    )
        : Text(
      text,
      style: TextStyle(
        color: Colors.grey[300],
        fontWeight: FontWeight.bold,
        fontSize: width * 0.04,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double tabBarHeight = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: tabBarHeight,
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(child: gradientTabText(width, '친구 리스트', 0)),
                  Tab(child: gradientTabText(width, '찜 리스트', 1)),
                  Tab(child: gradientTabText(width, '차단 리스트', 2)),
                ],
                indicatorColor: Colors.white,
                labelColor: Colors.white,
              ),
            ),
            Container(
              height: 2.0,
              decoration: BoxDecoration(
                gradient: MainGradient(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildListView(),
                  buildListView(),
                  buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(  // GestureDetector를 추가
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OthersProfilePage()),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                ),
                SizedBox(width: 20),
                Text(
                  '친구$index',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

