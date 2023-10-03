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
        home: FindStudyScreen(),
      );
    }
  }
  class FindStudyScreen extends StatefulWidget {
    @override
    _FindStudyScreenState createState() => _FindStudyScreenState();
  }

  class _FindStudyScreenState extends State<FindStudyScreen> with SingleTickerProviderStateMixin {
    TabController? _tabController;
    final List<String> _tabLabels = ['전체', '잔여석', '공개'];

    @override
    void initState() {
      super.initState();
      _tabController =
          TabController(length: 3, vsync: this); // 3 탭을 위한 컨트롤러를 초기화합니다.
    }

    @override
    void dispose() {
      _tabController?.dispose(); // 컨트롤러를 해제합니다.
      super.dispose();
    }

    final List<Study> studies = [
      Study(title: '공부할 사람fsdfs',
          subject: '컴퓨터 그래픽스 &&,,,,,&&&',
          description: '스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용 스터디 내용',
          members: '3/5 명',
          startDate: '2023-01-01'),
      Study(title: '스터디 제목 2',
          subject: '과목명 2',
          description: '스터디 설명 2',
          members: '4/5 명',
          startDate: '2023-01-02'),
      // ... more studies
    ];

    @override
    Widget build(BuildContext context) {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      final height = MediaQuery
          .of(context)
          .size
          .height;

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(102.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 35,
                color: Colors.grey[400],),

              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context); // 로그인 화면으로 되돌아가기
              },
            ),
            actions: [ // `actions` 속성을 사용하여 IconButton을 추가합니다.
              IconButton(
                icon: Icon(Icons.search_rounded, size: 35,),
                color: Colors.grey,
                onPressed: () {
                  //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: GradientText(
                width: width, text: '스터디 찾기', tSize: 0.06, tStyle: 'Bold'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: CustomTabBar(),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // 각 탭에 대한 내용을 여기에 추가합니다.
            _buildTabContent('전체'),
            _buildTabContent('잔여석'),
            _buildTabContent('공개'),
          ],
        ),
      );
    }

    Widget _buildTabContent(String tabLabel) {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      final height = MediaQuery
          .of(context)
          .size
          .height;

      return Container(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35, vertical: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(study.title, style: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: 'Bold',
                              fontSize: width * 0.06)),
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
                        style: TextStyle(color: Colors.grey[600],
                            fontFamily: 'Bold',
                            fontSize: width * 0.025),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey,),
                              SizedBox(width: 4),
                              Text(study.members, style: TextStyle(
                                  fontFamily: 'Round', fontSize: 13)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('시작일', style: TextStyle(fontFamily: 'Bold',
                                  fontSize: 13,
                                  color: Colors.grey[600]),),
                              SizedBox(width: 4),
                              Text(study.startDate, style: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 13,
                                  color: Colors.grey[500]),),
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
      );
    }
  }
  class CustomTabBar extends StatefulWidget {
    @override
    _CustomTabBarState createState() => _CustomTabBarState();
  }

  class _CustomTabBarState extends State<CustomTabBar> {
    bool _isTab1Selected = true;  // 전체 탭의 선택 상태를 저장합니다.
    bool _isTab2Selected = false;  // 잔여석 탭의 선택 상태를 저장합니다.
    bool _isTab3Selected = false;  // 공개 탭의 선택 상태를 저장합니다.

    void _toggleTab1() {
      setState(() {
        _isTab1Selected = true;
        _isTab2Selected = false;
        _isTab3Selected = false;
      });
    }

    void _toggleTab2() {
      setState(() {
        if(!_isTab2Selected) {
          _isTab1Selected = false;
          _isTab2Selected = true;
        }
        else if( _isTab2Selected && !_isTab3Selected){
          _isTab1Selected = true;
          _isTab2Selected = false;
        }
        else if(_isTab2Selected && _isTab3Selected){
          _isTab2Selected = false;
        }
      });
    }

    void _toggleTab3() {
      setState(() {
        if(!_isTab3Selected) {
          _isTab1Selected = false;
          _isTab3Selected = true;
        }
        else if( _isTab3Selected && !_isTab2Selected){
          _isTab1Selected = true;
          _isTab3Selected = false;
        }
        else if(_isTab3Selected && _isTab2Selected){
          _isTab3Selected = false;
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return Container(
        color: Colors.grey[200],
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width : 20,),
            _buildTab('전체', _isTab1Selected, _toggleTab1),
            SizedBox(width : 20,),
            _buildTab('잔여석', _isTab2Selected, _toggleTab2),
            SizedBox(width : 20,),
            _buildTab('공개', _isTab3Selected, _toggleTab3),
          ],
        ),
      );
    }

    Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: 17),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSelected ? Colors.grey[400] : Colors.white,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
            ),
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
