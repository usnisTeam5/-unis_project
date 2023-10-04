import 'package:flutter/material.dart';
import 'package:unis_project/search_department/search_department.dart';
import 'package:unis_project/search_subject/search_subject.dart';
import 'register.dart';
import 'dart:math';
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
      home: DepartmentSelectionScreen(),
    );
  }
}

class DepartmentSelectionScreen extends StatefulWidget {
  @override
  _DepartmentSelectionScreenState createState() => _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  List<String> selectedDepartments = [];
  List<String> selectedCourses = [];

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width,500.0);
    final double height = MediaQuery.of(context).size.height;
    selectedDepartments = selectedDepartments.toSet().toList(); // 중복제거
    selectedCourses = selectedCourses.toSet().toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('학과 및 수강 과목 설정', style: TextStyle(fontFamily: 'Round')),
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            children: [
              // Department Selection
              Row(
                children: [
                  Text('학과', style: TextStyle(fontFamily: 'Round')),
                  SizedBox(width: 10),  // 공간 추가
                  Text('최대 2개 선택', style: TextStyle(fontFamily: 'Round', color: Colors.grey)),
                ],
              ),
              TextField(
                readOnly: true,
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchDepartment()));
                  if (result != null && selectedDepartments.length < 2) {
                    setState(() {
                      selectedDepartments.add(result);
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
                  children: selectedDepartments.map((department) {
                    return ListTile(
                      title: Text(department),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedDepartments.remove(department);
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
                  children:[
                    Text('수강 과목', style: TextStyle(fontFamily: 'Round')),
                    SizedBox(width: 10),  // 공간 추가
                    Text('최소 1개 선택', style: TextStyle(fontFamily: 'Round', color: Colors.grey)),
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
                      title: Text(course),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.2, height * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // 이전 버튼 클릭 로직
                      Navigator.pop(context);
                    },
                    child: Text('이전'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.2, height * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (selectedDepartments.isEmpty || selectedCourses.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('학과와 수강 과목을 최소 하나 이상 선택해주세요.')),
                        );
                      } else {
                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationScreen()),
                        );
                      }
                    },
                    child: Text('다음'),
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

