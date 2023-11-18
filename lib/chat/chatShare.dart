/*
팝업
 */
import 'package:flutter/material.dart';

class ChatShare extends StatefulWidget {
  @override
  _ChatShareState createState() => _ChatShareState();
}

class _ChatShareState extends State<ChatShare> {
  int? _selectedStudyIndex;
  final List<String> _studies = [
    '과목명 1',
    '과목명 2',
    '과목명 3',
    '과목명 4',
    '과목명 5',
  ];

  void _showSnackbarAndClosePopup(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        '채팅을 선택한 스터디에 공유하였습니다.',
        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop(); // 팝업창을 닫습니다.
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "채팅을 스터디에 공유합니다",
        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < _studies.length; i++)
              ListTile(
                title: Text(
                  _studies[i],
                  style: TextStyle(fontFamily: 'Round'),
                ),
                leading: Radio(
                  value: i,
                  groupValue: _selectedStudyIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedStudyIndex = value;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "취소",
            style: TextStyle(fontFamily: 'Bold'),
          ),
        ),
        TextButton(
          onPressed: _selectedStudyIndex != null
              ? () {
            // 확인 버튼 눌렀을 때 처리 로직
            _showSnackbarAndClosePopup(context);
          }
              : null, // _selectedStudyIndex가 null일 경우 버튼을 비활성화
          child: Text(
            "확인",
            style: TextStyle(fontFamily: 'Bold'),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
