/**
 * 선택한 과목중에서 찾아서 반환하는 메소드 과목 검색 x
 */
import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';

void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: SearchDepartment(),
    );
  }
}
class SearchDepartment extends StatefulWidget {
  @override
  _SearchDepartmentState createState() => _SearchDepartmentState();
}

class _SearchDepartmentState extends State<SearchDepartment> {
  TextEditingController _searchController = TextEditingController();
  int selectedDepartmentIndex = 0;  // 기본적으로 첫 번째 주제가 선택됩니다.
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery
        .of(context)
        .size
        .width;
    double tabBarHeight = MediaQuery
        .of(context)
        .size
        .height * 0.08;

    String selectedDepartment;

    final List<String> departments = [
      '컴퓨터와 휴먼 학부',
      '인공지능과 윤리 학과',
      '빅데이터 분석 학과',
      '휴먼인터페이스미디어와 마법의 돌과 죄수 학과',
      '컴퓨터와 휴먼 학부',
      '인공지능과 윤리 학과',
      '빅데이터 분석 학과',
      '휴먼인터페이스미디어와 마법의 돌과 죄수 학과',
      '컴퓨터와 휴먼 학부',
      '인공지능과 윤리 학과',
      '빅데이터 분석 학과',
      '휴먼인터페이스미디어와 마법의 돌과 죄수 학과',
    ];
    List<String> selectedDepartments = [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context); // 로그인 화면으로 되돌아가기
          },
        ),
        actions: [ // `actions` 속성을 사용하여 IconButton을 추가합니다.
          IconButton(
            icon: Icon(Icons.check, size: 30,),
            color: Colors.grey,
            onPressed: () {
              selectedDepartment = departments[selectedDepartmentIndex]; // 수정된 부분
              print('선택된 주제: ${selectedDepartment}');
              Navigator.pop(context, selectedDepartment);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '학과 선택', tSize: 0.06, tStyle: 'Bold'),
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
      body:// ListView를 Expanded 위젯으로 감싸서 남은 공간을 모두 차지하게 합니다.
      Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: TextField(
              controller: _searchController,
              onChanged: (text) {
                setState(() {});  // 검색어가 변경될 때마다 화면을 갱신
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: width * 0.04), // 위쪽 패딩 추가
                suffixIcon: Icon(Icons.search),
              ),
              style: TextStyle(
                fontFamily: 'Round',
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: width*0.04,
              ),
            )
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: departments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),  // 회색 테두리 추가
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 체크박스를 오른쪽으로 이동시킵니다.
                        children: [
                          Text(
                            "      ${departments[index]}",
                            style: TextStyle(color: Colors.grey[700], fontFamily: 'Round', fontSize: 15),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Radio(
                              value: index,
                              groupValue: selectedDepartmentIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedDepartmentIndex = value!;
                                });
                              },
                              activeColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


