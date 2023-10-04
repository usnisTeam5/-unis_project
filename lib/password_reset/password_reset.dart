import 'package:flutter/material.dart';
import 'dart:math';
void main() => runApp(Register());

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordResetPage(),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int checkPoint = 0;

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width,500.0);
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: SingleChildScrollView(
          child: Container(
            height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.05),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '포탈 이메일',
                      suffixIcon: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 0.2, height * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 인증번호 보내기 버튼 클릭 로직
                        },
                        child: Text('인증하기'),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: '인증번호',
                      suffixIcon: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 0.2, height * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 인증번호 확인 버튼 클릭 로직
                        },
                        child: Text('확인'),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: '비밀번호'),
                    obscureText: true,
                  ),

                  SizedBox(height: height * 0.05),

                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: '비밀번호 재확인'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호 재확인을 입력해주세요';
                      } else if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                  ),

                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 0.2, height * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 이전 버튼 클릭 로직
                          Navigator.pop(context);
                        },
                        child: Text('이전'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 0.2, height * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 다음 버튼 클릭 로직
                        },
                        child: Text('다음'),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
