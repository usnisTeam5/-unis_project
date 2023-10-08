import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';

class ReportPopup extends StatefulWidget {
  @override
  _ReportPopupState createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  int? _selectedReason;
  String _otherReason = "";
  final List<String> _reasons = [
    '예의 없는 언행, 협박이 포함된 질문',
    '욕설, 음란 등 불쾌감을 주는 질문',
    '수행평가, 과제 전체 질문',
    '기타',
  ];



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "신고 사유 선택",
        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < _reasons.length; i++)
              ListTile(
                title: Text(
                  _reasons[i],
                  style: TextStyle(fontFamily: 'Round'),
                ),
                leading: Radio(
                  value: i,
                  groupValue: _selectedReason,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                ),
              ),
            if (_selectedReason == _reasons.length-1)
              TextField(
                onChanged: (text) => _otherReason = text,
                decoration: InputDecoration(
                  hintText: "기타 사유를 입력하세요",
                  hintStyle: TextStyle(fontFamily: 'Round'),
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
          onPressed: () {
            // 확인 버튼 눌렀을 때 처리 로직
            // 관리자에게 채팅 내역과 신고 사유를 보낼 로직 구현
          },
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






