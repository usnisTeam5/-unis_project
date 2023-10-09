import 'package:flutter/material.dart';
import 'package:unis_project/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:unis_project/password_reset/password_reset.dart';
import 'package:unis_project/register/user_agreement.dart';
import 'package:flutter/services.dart';
import '../css/css.dart';
import 'dart:math';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(UnisApp());
}

class UnisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
    // 백엔드와의 통신 코드를 이곳에 추가하세요.
    // 예: _authenticate(id, password);
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(width: width, tSize: 0.15, text:'유니스', tStyle: 'ExtraBold' ),
                const SizedBox(height: 20),
                GradientText2(width: width, tSize: 0.05, text:'스터디 🔗 문제풀이', tStyle: 'Bold' ),
                SizedBox(height: 60),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelText: '  포탈 아이디 입력',
                    counterText: "",  // 이 속성을 추가하여 글자 수 레이블을 숨깁니다.
                  ),
                  maxLength: 20,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelText: '  비밀번호 입력',
                    counterText: "",
                  ),
                  maxLength: 12,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: MainGradient(),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PasswordResetPage()),
                        );
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
      ),
    );
  }
}