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
            Navigator.pop(context);  // 로그인 화면으로 되돌아가기
          },
        ),
        actions: [  // `actions` 속성을 사용하여 IconButton을 추가합니다.
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
        centerTitle: true,  // Title을 중앙에 배치
        title: GradientText(width: width, text: '스터디 제목', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,  // Set the thickness of the undedsrline
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
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
        );
      },
    );
  }
}

