import 'package:flutter/material.dart';
import 'package:unis_project/user_agreement/user_agreement.dart';

void main() => runApp(UnisApp());

class UnisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'unis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final id = _idController.text;
    final password = _passwordController.text;

    // 백엔드와의 통신 코드를 이곳에 추가하세요.
    // 예: _authenticate(id, password);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  '유니스',
                  style: TextStyle(
                    color: Colors.white,  // This color will be ignored since we've applied shader
                    fontFamily: 'ExtraBold',
                    fontSize: width * 0.1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '스터디 🔗 문제풀이',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Bold',
                  fontSize: width * 0.03,
                ),
              ),
              SizedBox(height: 60),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: '아이디 입력',
                ),
                maxLength: 20,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: '비밀번호 입력',
                ),
                maxLength: 12,
                obscureText: true,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: _login,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '로그인 하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Bold',
                            fontSize: width * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // 비밀번호 찾기 창으로 이동
                    },
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                  Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.03,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 회원가입 창으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserAgreementScreen()),
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
