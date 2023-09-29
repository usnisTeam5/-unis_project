import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: FindStudyScreen(),
    );
  }
}

class FindStudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<FindStudyScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final List<Study> studies = [
    Study(title: '스터디 제목 1', subject: '과목명 1', description: '스터디 설명 1', members: '3/5명', startDate: '2023-01-01'),
    Study(title: '스터디 제목 2', subject: '과목명 2', description: '스터디 설명 2', members: '4/5명', startDate: '2023-01-02'),
    // ... more studies
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('스터디 찾기'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '전체'),
            Tab(text: '잔여석'),
            Tab(text: '공개'),
          ],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10),
              right: Radius.circular(10),
            ),
            color: Colors.grey,
          ),
          unselectedLabelColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildListView(studies),  // 전체 탭
          buildListView(studies),  // 잔여석 탭
          buildListView(studies),  // 공개 탭
        ],
      ),
    );
  }

  ListView buildListView(List<Study> studies) {
    return ListView.builder(
      itemCount: studies.length,
      itemBuilder: (context, index) {
        final study = studies[index];
        return GestureDetector(
          onTap: () {
            // Navigate to study room when a study item is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyRoomScreen(study: study)),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(study.title),
                      Text(study.subject),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    study.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 4),
                          Text(study.members),
                        ],
                      ),
                      Text(study.startDate),
                    ],
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

class Study {
  final String title;
  final String subject;
  final String description;
  final String members;
  final String startDate;

  Study({
    required this.title,
    required this.subject,
    required this.description,
    required this.members,
    required this.startDate,
  });
}

class StudyRoomScreen extends StatelessWidget {
  final Study study;

  StudyRoomScreen({required this.study});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(study.title),
      ),
      body: Center(
        child: Text('Welcome to ${study.title} room'),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  // 여기에 검색 로직을 구현하세요.
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('검색 결과를 여기에 표시하세요.'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('검색 제안을 여기에 표시하세요.'));
  }
}
