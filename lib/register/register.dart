import 'package:flutter/material.dart';
import 'dart:math';
import '../css/css.dart';

void main() => runApp(Register());

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  RegistrationScreen(),
    );
  }
}

class  RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  String? validationMessage = ' '; // 이메일
  String? validationMessage2 = ' '; // 비밀번호
  String? validationMessage3 = ' '; // 비밀번호 확인
  String? validationMessage4 = ' '; // 인증번호
  String? validationMessage5 = ' '; // 닉네임 중복확인
  int checkPoint = 0;

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width, 500.0);
    final double height = min(MediaQuery.of(context).size.height, 700.0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context); // 로그인 화면으로 되돌아가기
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        //centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '이메일, 닉네임, 비밀번호 입력', tSize: 0.05, tStyle: 'Bold'),
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
                      labelStyle: TextStyle(
                        fontFamily: 'Round',
                        color:_emailController.text.isEmpty
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 2.0), // 포커스 될 때 밑줄 색깔
                      ),
                      suffixIcon: Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.2, // Minimum width of the container
                          maxHeight: height * 0.03, // Minimum height of the container
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: MainGradient(),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () {
                              if (!_emailController.text.trim().endsWith('@cau.ac.kr')) {
                                setState(() {
                                  validationMessage = '이메일은 @cau.ac.kr로 끝나야 합니다.';
                                });
                              } else {
                                setState(() {
                                  validationMessage = '메일을 보냈습니다.';
                                });
                              }
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  '인증하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Bold',
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      validationMessage!,
                      style: TextStyle(color: Colors.grey[500], fontFamily: 'Round', fontSize: 13,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: '인증번호',
                      labelStyle: TextStyle(
                        fontFamily: 'Round',
                        color:_emailController.text.isEmpty
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 2.0), // 포커스 될 때 밑줄 색깔
                      ),
                      suffixIcon: Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.2, // Minimum width of the container
                          maxHeight: height * 0.03, // Minimum height of the container
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: MainGradient(),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () {
                              // validationMessage4
                              // if (!_emailController.text.trim().endsWith('@cau.ac.kr')) { 이것처럼 인증번호 일치하는지 확인
                              //   setState(() {
                              //     validationMessage4 = '인증이 완료되었습니다.';
                              //   });
                              // } else {
                              //   setState(() {
                              //     validationMessage = '인증번호가 일치하지 않습니다.';
                              //   });
                              // }

                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  '확  인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Bold',
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      labelStyle: TextStyle(
                        fontFamily: 'Round',
                        color:_nicknameController.text.isEmpty
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 2.0), // 포커스 될 때 밑줄 색깔
                      ),
                      suffixIcon: Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.2, // Minimum width of the container
                          maxHeight: height * 0.03, // Minimum height of the container
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: MainGradient(),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () {
                             //validationMessage 5 == 닉네임 중복, 닉네임 이상한거 x
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  '중복 확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Bold',
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      counterText: "",  // 이 속성을 추가하여 글자 수 레이블을 숨깁니다.
                    ),
                    maxLength: 10,
                  ),
                  SizedBox(height:2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      validationMessage5!,
                      style: TextStyle(color: Colors.grey[500], fontFamily: 'Round', fontSize: 13,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: TextStyle(
                        fontFamily: 'Round',
                        color:_emailController.text.isEmpty
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 2.0), // 포커스 될 때 밑줄 색깔
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      // 비밀번호가 8자 이상인지 확인
                      bool isLengthValid = value.length >= 8;

                      // 비밀번호가 영어 알파벳과 숫자로만 이루어져 있는지 확인
                      bool isCharacterValid = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);

                      if (!isLengthValid && !isCharacterValid) {
                        setState(() {
                          validationMessage2 = '비밀번호는 8자 이상이며, 영어와 숫자로만 이루어져야 합니다.';
                        });
                      } else if (!isLengthValid) {
                        setState(() {
                          validationMessage2 = '비밀번호는 8자 이상이어야 합니다.';
                        });
                      } else if (!isCharacterValid) {
                        setState(() {
                          validationMessage2 = '비밀번호는 영어와 숫자로만 이루어져야 합니다.';
                        });
                      } else {
                        setState(() {
                          validationMessage2 = '올바른 비밀번호입니다.';  // 조건을 모두 만족하면 메시지를 null로 설정
                        });
                      }
                    },
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      validationMessage2!,
                      style: TextStyle(color: Colors.grey[500], fontFamily: 'Round', fontSize: 13,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호 재확인',
                      labelStyle: TextStyle(
                        fontFamily: 'Round',
                        color:_emailController.text.isEmpty
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 2.0), // 포커스 될 때 밑줄 색깔
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value){
                      if( value != _passwordController.text){
                        setState(() {
                          validationMessage3 = '비밀번호가 일치하지 않습니다.';
                        });
                      }
                      else {
                        setState((){
                          validationMessage3 = '비밀번호가 일치합니다.';
                        });
                      }
                    },
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      validationMessage3!,
                      style: TextStyle(color: Colors.grey[500], fontFamily: 'Round', fontSize: 13,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(32.0),
        height: 50,
        //margin: EdgeInsets.all,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: MainGradient(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () {
              if(validationMessage == '메일을 보냈습니다.'
                  && validationMessage2 == '올바른 비밀번호입니다.'
                  && validationMessage3 == '비밀번호가 일치합니다.') {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '회 원 가 입',
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
    );
  }
}
