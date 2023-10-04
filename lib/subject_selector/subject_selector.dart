/**
 * 선택한 과목중에서 찾아서 반환하는 메소드 과목 검색 x
 */
import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';
import 'dart:math';
void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: SubjectSelector(),
    );
  }
}
class SubjectSelector extends StatefulWidget {
  @override
  _SubjectSelectorState createState() => _SubjectSelectorState();
}

class _SubjectSelectorState extends State<SubjectSelector> {
  int selectedSubjectIndex = 0;  // 기본적으로 첫 번째 주제가 선택됩니다.
  @override
  Widget build(BuildContext context) {

    double  width = min(MediaQuery.of(context).size.width,500.0);
    double tabBarHeight = MediaQuery
        .of(context)
        .size
        .height * 0.08;

    String selectedSubject;

    final List<String> subjects = [
      '컴퓨터와 휴먼',
      '인공지능과 윤리',
      '빅데이터 분석',
      '휴먼인터페이스미디어와 마법의 돌과 죄수',
      '컴퓨터와 휴먼',
      '인공지능과 윤리',
      '빅데이터 분석',
      '휴먼인터페이스미디어와 마법의 돌과 죄수',
      '컴퓨터와 휴먼',
      '인공지능과 윤리',
      '빅데이터 분석',
      '휴먼인터페이스미디어',
    ];

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
              selectedSubject = subjects[selectedSubjectIndex]; // 수정된 부분
              print('선택된 주제: ${selectedSubject}');
              Navigator.pop(context, selectedSubject);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '과목 선택', tSize: 0.06, tStyle: 'Bold'),
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
      Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: subjects.length,
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
                      "      ${subjects[index]}",
                      style: TextStyle(color: Colors.grey[700], fontFamily: 'Round', fontSize: 15),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Radio(
                        value: index,
                        groupValue: selectedSubjectIndex,
                        onChanged: (int? value) {
                          setState(() {
                            selectedSubjectIndex = value!;
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
    );
  }
}


