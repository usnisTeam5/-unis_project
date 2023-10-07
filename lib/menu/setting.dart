import 'package:flutter/material.dart';
import '../css/css.dart';
import 'dart:math';
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text("닫기"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
            width: width, text: '설정', tSize: 0.06, tStyle: 'Bold'),
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
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('알림 설정'),
            trailing: Switch(
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
            ),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('버전 정보'),
            onTap: () => _showDialog('버전 정보', '현재 버전: 1.0.0'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('이용정보약관'),
            onTap: () => _showDialog('이용정보약관', '이용정보약관 내용...'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('개인정보처리방침'),
            onTap: () => _showDialog('개인정보처리방침', '개인정보처리방침 내용...'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('오픈소스라이선스'),
            onTap: () => _showDialog('오픈소스라이선스', '오픈소스 라이선스 내용...'),
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
