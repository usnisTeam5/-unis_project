import 'package:flutter/material.dart';

void main() => runApp(Register());

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int checkPoint = 0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('포탈 인증, 비밀번호 설정'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);  // 로그인 화면으로 되돌아가기
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
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

              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: '닉네임',
                  suffixIcon: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.2, height * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // 닉네임 중복 확인 버튼 클릭 로직
                    },
                    child: Text('중복확인'),
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
    );
  }
}
