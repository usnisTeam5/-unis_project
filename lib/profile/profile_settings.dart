import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<String> itemsText = ['학부 설정', '과목 설정하기', '로그아웃', '회원 탈퇴'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 35,),
          color: Colors.grey[400],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GradientText(width: width, text: '프로필 설정', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: itemsText.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {/*리스트 탭*/},
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    itemsText[index],
                    style: TextStyle(
                      color: itemsText[index] == '회원 탈퇴' ? Colors.red : Colors.grey[600],
                        fontSize: 20,
                        fontFamily: 'Bold',
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, size: 35, color: Colors.grey[400],),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
