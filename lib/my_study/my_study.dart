import 'package:flutter/material.dart';
import '../css/css.dart';
import '../study_room/bottom_navigation_bar.dart';
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
    Study(title: '공부할 사람fsdfs', subject: '컴퓨터 그래픽스 &&,,,,,&&&', description: '스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용', members: '3/5 명', startDate: '2023-01-01'),
    Study(title: '스터디 제목 2', subject: '과목명 2', description: '스터디 설명 2', members: '4/5 명', startDate: '2023-01-02'),
    // ... more studies
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,  // Title을 중앙에 배치
        title: GradientText(width: width, tSize: 0.06, text:'내 스터디', tStyle: 'Bold' ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        color: Colors.grey[200],
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: studies.length,
          itemBuilder: (context, index) {
            final study = studies[index];
            return GestureDetector(
              onTap: () {
                // Navigate to study room when a study item is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(study.title, style: TextStyle(color: Colors.grey[600], fontFamily: 'Bold', fontSize: width * 0.06)),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Text(
                              study.subject,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xFF3D6094),
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.03),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Text(
                        study.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontFamily: 'Bold', fontSize: width * 0.025),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey,),
                              SizedBox(width: 4),
                              Text(study.members, style: TextStyle(fontFamily: 'Round', fontSize: 13)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('시작일', style: TextStyle(fontFamily: 'Bold', fontSize: 13,color: Colors.grey[600]),),
                              SizedBox(width: 4),
                              Text(study.startDate, style: TextStyle(fontFamily: 'Bold', fontSize: 13, color: Colors.grey[500]),),
                            ],
                          ),
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
