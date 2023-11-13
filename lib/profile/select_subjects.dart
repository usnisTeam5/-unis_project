import 'package:flutter/material.dart';
import 'package:unis_project/search_department/search_department.dart';
import 'package:unis_project/search_subject/search_subject.dart';
import 'dart:math';
import '../css/css.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(Department_selection_screen());
}

class Department_selection_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: SubjectSelectionScreen(),
    );
  }
}

class SubjectSelectionScreen extends StatefulWidget {
  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  List<String> selectedCurCourses = [];
  List<String> selectedCourses = [];

  @override
  void initState() {
    super.initState();

    // 처음에 한 번만 실행되어야 하는 코드를 여기에 작성합니다.
    Future.delayed(Duration.zero, () {
      final viewModel = Provider.of<UserProfileViewModel>(context, listen: false);
      setState(() {
        selectedCurCourses = viewModel.currentCourses;
        selectedCourses = viewModel.pastCourses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width,500.0);
    final double height = MediaQuery.of(context).size.height;
    selectedCurCourses = selectedCurCourses.toSet().toList(); // 중복제거
    selectedCourses = selectedCourses.toSet().toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context); // 로그인 화면으로 되돌아가기
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        //centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '수강과목 설정', tSize: 0.05, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          // Set the height of the underline
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0, // Set the thickness of the undedsrline
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            children: [
              // Department Selection
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,  // baseline으로 정렬
                textBaseline: TextBaseline.alphabetic,
                children: [
                  GradientText(width: width, tSize: 0.05, text:'수강중인 과목', tStyle: 'Round' ),
                  // SizedBox(width: 10),  // 공간 추가
                  // Text('최대 2개 선택', style: TextStyle(fontFamily: 'Round', color: Colors.grey,fontSize: width*0.03)),
                ],
              ),
              TextField(
                readOnly: true,
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchDepartment()));
                  if (result != null && selectedCurCourses.length < 2) {
                    setState(() {
                      selectedCurCourses.add(result);
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              Container(
                height: height * 0.2,  // 높이 설정
                child: ListView(
                  shrinkWrap: true,
                  children: selectedCurCourses.map((department) {
                    return ListTile(
                      title: Text(department, style: TextStyle(fontFamily: 'Bold'),),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedCurCourses.remove(department);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20),  // Spacing

              // Course Selection
              Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,  // baseline으로 정렬
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    GradientText(width: width, tSize: 0.05, text:'수강한 과목', tStyle: 'Round' ),
                    // SizedBox(width: 10),  // 공간 추가
                    // Text('최소 1개 선택', style: TextStyle(fontFamily: 'Round', color: Colors.grey,fontSize: width*0.03)),
                  ]
              ),
              TextField(
                readOnly: true,
                onTap: () async {
                  final List<String>? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSubject()));
                  if (result != null) {
                    setState(() {
                      selectedCourses.addAll(result);
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              Container(
                height: height * 0.3,  // 높이 설정
                child: ListView(
                  shrinkWrap: true,
                  children: selectedCourses.map((course) {
                    return ListTile(
                      title: Text(course, style: TextStyle(fontFamily: 'Bold'),),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedCourses.remove(course);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      minWidth: width * 0.2, // Minimum width of the container
                      minHeight: height * 0.05, // Minimum height of the container
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: MainGradient(),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '이전',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Bold',
                                fontSize: width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minWidth: width * 0.2, // Minimum width of the container
                      minHeight: height * 0.05, // Minimum height of the container
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: MainGradient(),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          if (selectedCourses.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('수강 과목을 최소 하나 이상 선택해주세요.')),
                            );
                          } else {
                          }
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '다음',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Bold',
                                fontSize: width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

