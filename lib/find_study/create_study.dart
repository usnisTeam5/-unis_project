import 'package:flutter/material.dart';
import '../css/css.dart';
import '../subject_selector/subject_selector.dart';
import 'dart:math';
void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: CreateStudy(),
    );
  }
}

class CreateStudy extends StatefulWidget {
  @override
  _CreateStudyState createState() => _CreateStudyState();
}

class _CreateStudyState extends State<CreateStudy> {
  final titleController = TextEditingController();
  final passwordController = TextEditingController();
  final descriptionController = TextEditingController();
  String? subject = null;
  String numberOfPeople = '인원 선택';

  Future<void> _selectNumberOfPeople() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String? selectedValue; // 선택된 인원

        return AlertDialog(
          title: Text('인원 선택'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true, // 리스트의 크기를 내용에 맞게 조절
              itemCount: 5, // 5개의 항목 (1명 ~ 5명)
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${index + 1}명'),
                  onTap: () {
                    setState(() {
                      numberOfPeople = '${index + 1}명';
                    });
                    Navigator.of(context).pop(); // 선택 후 다이얼로그 닫기
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(
          padding: const EdgeInsets.only(left: 16.0),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[400],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // `actions` 속성을 사용하여 IconButton을 추가합니다.
          IconButton(
            icon: GradientIcon(iconData: Icons.check),
            onPressed: () {
              print("제목: ${titleController.text}");
              print("비밀번호: ${passwordController.text}");
              print("설명: ${descriptionController.text}");
              print("과목명: ${subject}");
              print("인원수: ${numberOfPeople}");
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '스터디 생성', tSize: 0.06, tStyle: 'Bold'),
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
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextField(
                controller: titleController, // 컨트롤러 연결
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.grey[200],
                  // 배경색을 회색으로 설정
                  filled: true,
                  // 배경색을 적용하기 위해 필요한 속성
                  labelText: '   제목',
                  labelStyle: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: width * 0.045,
                    color: Colors.grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                  ),
                  counterText: "", // 글자 수 레이블을 숨깁니다.
                ),
                style: TextStyle(
                  fontFamily: 'Bold',
                  fontSize: width * 0.045,
                  color: Colors.black, // 입력할 때의 글씨색을 지정
                ),
                maxLength: 10,
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController, // 컨트롤러 연결
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.grey[200],
                  // 배경색을 회색으로 설정
                  filled: true,
                  // 배경색을 적용하기 위해 필요한 속성
                  labelText: '   비밀번호(선택)',
                  labelStyle: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: width * 0.045,
                    color: Colors.grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                  ),
                  counterText: "", // 글자 수 레이블을 숨깁니다.
                ),
                maxLength: 8,
              ),
              SizedBox(height: 10),
              // 과목 선택과 인원 선택은 단순 Dropdown 혹은 Picker를 사용하여 구현할 수 있습니다.
              // 아래는 단순한 예시입니다.

              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectSelector()),
                        );
                        // 반환된 결과를 처리하는 코드
                        if (result != null) {
                          setState(() {
                            subject = result;
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            subject == null
                                ? Text(
                                    '과목 선택',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontFamily: 'Bold',
                                        fontSize: width * 0.045),
                                  )
                                : Text(
                                    subject!.length > 18
                                        ? subject!.substring(0, 18) + '...'
                                        : subject!,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontFamily: 'Bold',
                                        fontSize: width * 0.04),
                                  ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 25,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // SizedBox를 Container로 변경
                      height: 1.0,
                      color: Colors.white,
                    ),
                    InkWell(
                      onTap: _selectNumberOfPeople,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              numberOfPeople,
                              style: numberOfPeople == '인원 선택'
                                  ? TextStyle(
                                      color: Colors.grey[400],
                                      fontFamily: 'Bold',
                                      fontSize: width * 0.045,
                                    )
                                  : TextStyle(
                                      color: Colors.grey[900],
                                      fontFamily: 'Bold',
                                      fontSize: width * 0.04),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 25,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController, // 컨트롤러 연결
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.grey[200],
                  // 배경색을 회색으로 설정
                  filled: true,
                  // 배경색을 적용하기 위해 필요한 속성
                  hintText: '   스터디에 대해 설명해주세요',
                  hintStyle: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: width * 0.045,
                    color: Colors.grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                  ),
                  counterText: "", // 글자 수 레이블을 숨깁니다.
                ),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
