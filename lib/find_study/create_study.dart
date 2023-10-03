import 'package:flutter/material.dart';
import '../css/css.dart';

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

class CreateStudy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
        actions: [
          // `actions` 속성을 사용하여 IconButton을 추가합니다.
          IconButton(
            icon: GradientIcon(iconData: Icons.check),
            onPressed: () {
              //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
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
                maxLength: 10,
              ),
              SizedBox(height: 10),
              // 과목 선택과 인원 선택은 단순 Dropdown 혹은 Picker를 사용하여 구현할 수 있습니다.
              // 아래는 단순한 예시입니다.

              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          '과목 선택',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Bold',
                              fontSize: width * 0.045),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 25,
                          ),
                          color: Colors.grey[400],
                          onPressed: () {
                            // 과목선택
                          },
                        ),
                      ],
                    ),
                    Container(
                      // SizedBox를 Container로 변경
                      height: 1.0,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          '인원 선택',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Bold',
                              fontSize: width * 0.045),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 25,
                          ),
                          color: Colors.grey[400],
                          onPressed: () {
                            // 과목선택
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
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
