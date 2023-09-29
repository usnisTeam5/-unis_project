import 'package:flutter/material.dart';
import 'register.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
      body: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
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
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
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
              height: screenHeight * 0.2,  // 높이 설정
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
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                if (result != null) {
                  setState(() {
                    selectedCourses.add(result);
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
              ),
            ),
            Container(
              height: screenHeight * 0.3,  // 높이 설정
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
              children: [
                ElevatedButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text('이전', style: TextStyle(fontFamily: 'Round')),
                ),
                ElevatedButton(
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
                  child: Text('다음', style: TextStyle(fontFamily: 'Round')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색', style: TextStyle(fontFamily: 'Round')),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, '검색 결과');
          },
          child: Text('검색 결과 반환', style: TextStyle(fontFamily: 'Round')),
        ),
      ),
    );
  }
}
