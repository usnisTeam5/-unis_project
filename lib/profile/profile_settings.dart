import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';
import 'dart:math';

import '../search_department/search_department.dart';
import '../search_subject/search_subject.dart';
import '../login/login.dart';
import 'package:restart_app/restart_app.dart';
import 'package:provider/provider.dart';
import '../view_model/login_result_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';
import '../view_model/user_quit_view_model.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱 전체 테마 설정
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: ProfileSettings(), // 홈 화면 설정
    );
  }
}

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width,500.0);
    List<String> itemsText = ['학부 설정', '과목 설정하기', '로그아웃', '회원 탈퇴'];
    final viewModel = Provider.of<LoginViewModel>(context);
    final userProfileViewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    //final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

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
      body:ChangeNotifierProvider(
        create: (_) => UserQuitViewModel(),
        builder: (context, child) {
          return ListView.builder(
            itemCount: itemsText.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async{
                  switch(itemsText[index]) {
                    case '학부 설정':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchDepartment()),
                      );
                      break;
                    case '과목 설정하기':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchSubject()),
                      );
                      break;
                    case '로그아웃':
                      await viewModel.logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                      break;
                    case '회원 탈퇴':
                      final String nickname = userProfileViewModel.nickName;
                      final viewQuitModel = Provider.of<UserQuitViewModel>(context, listen: false);
                    // 회원 탈퇴 확인 대화상자
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('회원 탈퇴 확인'),
                          content: Text('정말로 탈퇴하시겠습니까? \n ${userProfileViewModel.point} 의 포인트가 있습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('취소'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('탈퇴'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );

                      // 회원 탈퇴 절차 수행
                      if (confirm) {
                        await viewQuitModel.userQuit(nickname);
                        await viewModel.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      }
                      break;
                  } //
                },
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
          );
        }
      ),
    );
  }
}
