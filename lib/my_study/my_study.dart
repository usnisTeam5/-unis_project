import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: StudyScreen(),
    );
  }
}

class StudyScreen extends StatelessWidget {
  final List<Study> studies = [
    Study(title: '스터디 제목 1', subject: '과목명 1', description: '스터디 설명 1', members: '3/5명', startDate: '2023-01-01'),
    Study(title: '스터디 제목 2', subject: '과목명 2', description: '스터디 설명 2', members: '4/5명', startDate: '2023-01-02'),
    // ... more studies
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.grey, Colors.black],
          ).createShader(bounds),
          child: Center(
            child: Text(
              '내 스터디',
              style: TextStyle(
                // Assume the font family 'Bold' is defined elsewhere in your project
                fontFamily: 'ExtraBold',
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
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
        ),
      ),
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
