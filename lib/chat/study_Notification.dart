/*
스터디에서 알람 설정
 */
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudyNotificationSettings(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round', color: Colors.grey[700]),
          headline6: TextStyle(
            fontFamily: 'Bold',
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class StudyNotificationSettings extends StatefulWidget {
  @override
  _StudyNotificationSettingsState createState() =>
      _StudyNotificationSettingsState();
}

class _StudyNotificationSettingsState extends State<StudyNotificationSettings> {
  bool chatNotification = true;
  bool quizNotification = false;
  bool memberNotification = true;
  bool otherNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 55,
        leadingWidth: 105,
        leading: Padding(
          padding: EdgeInsets.only(right: 50.0),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          '스터디 알림 설정',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: 4,
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.grey[300],
        ),
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return ListTile(
                title: Text('스터디원 채팅 알림'),
                trailing: Switch(
                  value: chatNotification,
                  onChanged: (value) {
                    setState(() {
                      chatNotification = value;
                    });
                  },
                  activeColor: Color(0xFF2A7CC1),
                ),
              );
            case 1:
              return ListTile(
                title: Text('새로운 퀴즈 생성 알림'),
                trailing: Switch(
                  value: quizNotification,
                  onChanged: (value) {
                    setState(() {
                      quizNotification = value;
                    });
                  },
                  activeColor: Color(0xFF2A7CC1),
                ),
              );
            case 2:
              return ListTile(
                title: Text('새로운 스터디원 입장 알림'),
                trailing: Switch(
                  value: memberNotification,
                  onChanged: (value) {
                    setState(() {
                      memberNotification = value;
                    });
                  },
                  activeColor: Color(0xFF2A7CC1),
                ),
              );
            case 3:
              return ListTile(
                title: Text('이외의 여러가지 알림'),
                trailing: Switch(
                  value: otherNotification,
                  onChanged: (value) {
                    setState(() {
                      otherNotification = value;
                    });
                  },
                  activeColor: Color(0xFF2A7CC1),
                ),
              );
            default:
              return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
