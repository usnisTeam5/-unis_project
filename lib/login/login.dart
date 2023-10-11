import 'package:flutter/material.dart';
import 'package:unis_project/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:unis_project/password_reset/password_reset.dart';
import 'package:unis_project/register/user_agreement.dart';
import 'package:flutter/services.dart';
import '../css/css.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../view_model/login_result_view_model.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginViewModel>(
            create: (context) => LoginViewModel(),
          ),
        ],
        child: UnisApp(navigatorKey: navigatorKey)
      ),
  );
}

class UnisApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  UnisApp({required this.navigatorKey});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return MaterialApp(
      navigatorKey: navigatorKey,
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

class _LoginScreenState extends State<LoginScreen> { // textfield 땜에 일단 둠.
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final id = _idController.text;
    final password = _passwordController.text;
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    bool success = await loginViewModel.login(id, password);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      // 로그인 실패시 에러 메시지 표시 (예: 스낵바를 사용)
      final snackBar = SnackBar(content: Text('로그인 실패: ${loginViewModel.errorMessage}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child)
    {
      if (viewModel.isLoading) {
        return CircularProgressIndicator();
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(width: width,
                    tSize: 0.15,
                    text: '유니스',
                    tStyle: 'ExtraBold'),
                const SizedBox(height: 20),
                GradientText2(width: width,
                    tSize: 0.05,
                    text: '스터디 🔗 문제풀이',
                    tStyle: 'Bold'),
                SizedBox(height: 60),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: Color(0xFF3D6094), width: 2.0), // 빨간색으로 지정
                    ),
                    hintText: '  포탈 아이디 입력',
                    hintStyle: TextStyle(
                      fontFamily: 'Round',
                    ),
                    counterText: "", // 이 속성을 추가하여 글자 수 레이블을 숨깁니다.
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
                    hintText: '  비밀번호 입력',
                    hintStyle: TextStyle(
                      fontFamily: 'Round',
                    ),
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
                          MaterialPageRoute(
                              builder: (context) => PasswordResetPage()),
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
                          MaterialPageRoute(
                              builder: (context) => UserAgreementScreen()),
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
        );
      }
    },
      ),
    ),
    );
  }
}