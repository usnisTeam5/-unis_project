import 'package:flutter/material.dart';
import '../css/css.dart';

import 'package:provider/provider.dart';
import '../study_room/study_home.dart';
import '../view_model/find_study_view_model.dart';



class JoinStudy extends StatefulWidget {
  @override
  _JoinStudyState createState() => _JoinStudyState();
}

class _JoinStudyState extends State<JoinStudy> {
  final TextEditingController _passwordController = TextEditingController();
  int? _selectedStudyIndex;



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudyViewModel(),
      builder: (context, child) {

        // final join = Provider.of<StudyViewModel>(context, listen: false);
        // join.(roomKey, mystudylist.nickname);


        return AlertDialog(
          title: Text('스터디 가입'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => _joinStudy(context),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }


  void _joinStudy(BuildContext context) {
    // 이 함수는 실제 백엔드 API 호출 로직을 포함해야 합니다.
    // 현재는 단순한 조건을 사용하여 로직을 시뮬레이션합니다.

    if (_selectedStudyIndex == null) return;

    if (_selectedStudyIndex == 1) { // 비밀번호가 있는 스터디
      _showPasswordDialog(context);

    } else if (_selectedStudyIndex == 3) { // 인원이 가득 찬 스터디
      _showFullStudyDialog(context);

    } else { // 일반 스터디
      _showJoinConfirmationDialog(context);
    }
  }


  void _showPasswordDialog(BuildContext context) { // 비번 O
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('비공개 스터디입니다. 비밀번호를 입력해주세요.'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '비밀번호',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 비밀번호 검증 로직
                if (_passwordController.text == "올바른 비밀번호") {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FriendsList()));
                } else {
                  Navigator.of(context).pop();
                  _showSnackbar(context, '비밀번호가 틀렸습니다. 다시 입력해주세요.');
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showFullStudyDialog(BuildContext context) { // 인원 FULL
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('해당 스터디는 인원이 모두 찼습니다. 다음에 다시 시도해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showJoinConfirmationDialog(BuildContext context) { // 비번 X
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('스터디에 가입하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => FriendsList()));
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
