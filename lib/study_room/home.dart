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
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
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
            icon: Icon(Icons.settings, size: 30,),
            color: Colors.grey,
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
            width: width, text: '스터디 제목', tSize: 0.06, tStyle: 'Bold'),
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
      body: Column( // Scaffold의 body를 Column으로 변경합니다.
        children: [
          GestureDetector( // GestureDetector 위젯을 추가합니다.
            onTap: () { // onTap 속성에 팝업을 띄우는 로직을 추가합니다.
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('공지'),
                    content: Text('이것은 공지입니다!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 팝업을 닫습니다.
                        },
                        child: Text('닫기'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200], // 배경색을 밝은 회색으로 변경합니다.
              child: Text(
                '공지: 이것은 공지입니다!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Round',
                ),
                //textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded( // ListView를 Expanded 위젯으로 감싸서 남은 공간을 모두 차지하게 합니다.
            child: buildListView(),
          ),
        ],
      ),
    );
  }
}
  ListView buildListView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(  // GestureDetector를 추가
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OthersProfilePage()),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                ),
                SizedBox(width: 20),
                Text(
                  '친구$index',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


