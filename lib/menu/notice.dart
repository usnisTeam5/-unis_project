import 'package:flutter/material.dart';
import '../css/css.dart';
import 'dart:math';
class Notice {
  final String title;
  final String content;
  final String imageUrl;

  Notice({required this.title, required this.content, required this.imageUrl});
}

class NoticeScreen extends StatelessWidget {
  final List<Notice> notices = [
    Notice(
        title: '공지사항 1',
        content: '이것은 첫 번째 공지사항입니다.',
        imageUrl: 'https://example.com/image1.jpg'),
    Notice(
        title: '공지사항 2',
        content: '이것은 두 번째 공지사항입니다.',
        imageUrl: 'https://example.com/image1.jpg'),
    Notice(
        title: '공지사항 3',
        content: '이것은 세 번째 공지사항입니다.',
        imageUrl: 'https://example.com/image1.jpg'),
    Notice(
        title: '공지사항 4',
        content: '이것은 네 번째 공지사항입니다.',
        imageUrl: 'https://example.com/image1.jpg'),
    // ... 다른 공지사항 항목들 ...
  ];

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context); // 로그인 화면으로 되돌아가기
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '공지사항', tSize: 0.06, tStyle: 'Bold'),
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
        body: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            return GestureDetector( // GestureDetector 추가
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Image.asset(
                        'image/gongji_top.jpg',
                        fit: BoxFit.cover,  // 이미지를 잘라내고 표시
                        width: double.infinity,  // 이미지의 너비를 최대로 설정
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10), // 이미지와 내용 사이에 간격 추가
                            Text(notices[index].content),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("닫기"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 100,  // 높이를 100으로 설정
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 1.0,
                      child: Image.asset(
                        'image/gongji_top.jpg',
                        fit: BoxFit.cover,  // 이미지를 잘라내고 표시
                        width: double.infinity,  // 이미지의 너비를 최대로 설정
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
