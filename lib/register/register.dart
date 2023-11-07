import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unis_project/models/register.dart';
import 'dart:math';
import '../css/css.dart';
import '../view_model/register_view_model.dart';
import 'package:provider/provider.dart';

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
  final List<String> selectedDepartments;
  final List<String> selectedCourses;

  // Constructor에서 빈 리스트를 default로 설정
  RegistrationScreen({
    Key? key,
    List<String>? selectedDepartments,
    List<String>? selectedCourses,
  })  : selectedDepartments = selectedDepartments ?? [],
        // Null일 경우 빈 리스트 할당
        selectedCourses = selectedCourses ?? [],
        // Null일 경우 빈 리스트 할당
        super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // 여기서 widget.selectedDepartments와 widget.selectedCourses를 사용합니다.

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

  bool isCodeTextFieldEnabled = false; // 인증번호 TextField의 활성화 상태를 제어하는 변수
  Timer? _timer; // 타이머를 저장할 변수
  int _start = 300; // 5분을 초로 환산

// 타이머 시작 함수
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel(); // 타이머 종료
            isCodeTextFieldEnabled = false; // 인증번호 TextField 비활성화
          });
        } else {
          setState(() {
            _start--; // 시간 감소
          });
        }
      },
    );
  }

  // 타이머 종료 및 초기화 함수
  void cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _start = 300; // 타이머 시간 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = min(MediaQuery.of(context).size.width, 500.0);
    final double height = min(MediaQuery.of(context).size.height, 700.0);

    return ChangeNotifierProvider(
        create: (_) => UserViewModel(ApiService()),
        builder: (context, child) {
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
                  width: width,
                  text: '이메일, 닉네임, 비밀번호 입력',
                  tSize: 0.05,
                  tStyle: 'Bold'),
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
                  height: height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: height * 0.05),
                        TextField(
                          controller: _emailController,
                          maxLength: 30,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: '포탈 이메일',
                            labelStyle: TextStyle(
                              fontFamily: 'Round',
                              color: _emailController.text.isEmpty
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 2.0), // 포커스 될 때 밑줄 색깔
                            ),
                            suffixIcon: Container(
                              constraints: BoxConstraints(
                                maxWidth: width * 0.2,
                                // Minimum width of the container
                                maxHeight: height *
                                    0.03, // Minimum height of the container
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: MainGradient(),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.0),
                                  // 이메일 인증하기 버튼이 눌렸을 때의 로직
                                  onTap: () async {
                                    final RegExp emailRegExp =
                                        RegExp(r'^[a-zA-Z0-9]+@cau\.ac\.kr$');
                                    bool emailIsValid = emailRegExp
                                        .hasMatch(_emailController.text.trim());
                                    // 이메일 형식이 유효하다면 인증 메일을 보냄
                                    if (!emailIsValid) {
                                      setState(() {
                                        validationMessage =
                                            '이메일은 @cau.ac.kr로 끝나고, 아이디에는 영어와 숫자만 사용 가능합니다.';
                                      });
                                    } else {
                                      setState(() {
                                        validationMessage = '메일을 보냈습니다.';
                                      });
                                      // 여기서 뷰 모델의 이메일 인증 메소드를 호출합니다.
                                      setState(() {
                                        if (_timer != null) {
                                          cancelTimer();
                                        }
                                        isCodeTextFieldEnabled =
                                            true; // 인증번호 TextField 활성화
                                        startTimer(); // 타이머 시작
                                      });
                                      await Provider.of<UserViewModel>(context,
                                              listen: false)
                                          .authenticateEmail(
                                              _emailController.text.trim());
                                      // 뷰 모델을 통해 인증 상태를 받아옵니다.
                                      String? authStatus =
                                          Provider.of<UserViewModel>(context,
                                                  listen: false)
                                              .authenticationStatusEmail;
                                      // 인증 상태에 따라 UI를 업데이트합니다.
                                      setState(() {
                                        if (authStatus == 'ok') {
                                          //validationMessage = '메일을 보냈습니다.';
                                        } else if (authStatus == "duplicate") {
                                          validationMessage = '이미 가입된 이메일입니다.';
                                          setState(() {
                                            cancelTimer();
                                          });
                                        } else {
                                          validationMessage = '인증 오류가 발생하였습니다.';
                                          setState(() {
                                            cancelTimer();
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
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
                        SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            validationMessage!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'Round',
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        TextField(
                          maxLength: 20,
                          controller: _codeController,
                          enabled: isCodeTextFieldEnabled, // 여기에 변수를 사용합니다.
                          decoration: InputDecoration(
                            counterText: "", // 이 속성을 추가하여 글자 수 레이블을 숨깁니다.
                            labelText: '인증번호',
                            labelStyle: TextStyle(
                              fontFamily: 'Round',
                              color: _emailController.text.isEmpty
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 2.0), // 포커스 될 때 밑줄 색깔
                            ),
                            suffixIcon: Container(
                              constraints: BoxConstraints(
                                maxWidth: width * 0.2,
                                // Minimum width of the container
                                maxHeight: height *
                                    0.03, // Minimum height of the container
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: MainGradient(),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.0),
                                  // 인증번호 확인 버튼이 눌렸을 때의 로직
                                  onTap: () async {
                                    final verificationDto =
                                        Provider.of<UserViewModel>(context,
                                                listen: false)
                                            .verificationDto;
                                    // 인증번호를 확인하는 메소드를 뷰 모델에서 호출합니다.
                                    await Provider.of<UserViewModel>(context,
                                            listen: false)
                                        .checkCode(VerificationCheckDto(
                                            verificationNum: int.parse(
                                                _codeController.text.trim()),
                                            epochSecond:
                                                verificationDto!.epochSecond,
                                            email: _emailController.text.trim(),
                                            verificationHashcode:
                                                verificationDto
                                                    .verificationHashcode));
                                    // 뷰 모델을 통해 인증 상태를 받아옵니다.
                                    String? codeCheckStatus =
                                        Provider.of<UserViewModel>(context,
                                                listen: false)
                                            .authenticationStatusCode;
                                    // 인증 상태에 따라 UI를 업데이트합니다.
                                    setState(() {
                                      validationMessage4 =
                                          codeCheckStatus == 'ok'
                                              ? '인증번호 확인 완료'
                                              : '인증번호 오류가 발생했습니다.';
                                    });
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
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
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                validationMessage4!,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: 'Round',
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            //if (isCodeTextFieldEnabled) // 타이머가 활성화되어 있을 때만 타이머 표시
                            Text(
                              '${(_start / 60).floor().toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Round',
                                fontSize: 10,
                              ),
                            ),
                            // else
                            //   Container(), // 타이머가 비활성화되어 있을 때는 빈 컨테이너를 표시함
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        TextField(
                          controller: _nicknameController,
                          decoration: InputDecoration(
                            labelText: '닉네임',
                            labelStyle: TextStyle(
                              fontFamily: 'Round',
                              color: _nicknameController.text.isEmpty
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 2.0), // 포커스 될 때 밑줄 색깔
                            ),
                            suffixIcon: Container(
                              constraints: BoxConstraints(
                                maxWidth: width * 0.2,
                                // Minimum width of the container
                                maxHeight: height *
                                    0.03, // Minimum height of the container
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                gradient: MainGradient(),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.0),
                                  onTap: () async {
                                    final userViewModel =
                                        Provider.of<UserViewModel>(context,
                                            listen: false);
                                    String nickname =
                                        _nicknameController.text.trim();
                                    // 영어, 숫자, 한글을 체크하는 정규 표현식
                                    RegExp nicknameRegExp =
                                        RegExp(r'^[a-zA-Z0-9가-힣]+$');

                                    // 정규 표현식에 맞는지 확인
                                    if (nicknameRegExp.hasMatch(nickname)) {
                                      // 정규 표현식 조건에 맞으면 닉네임 중복 확인
                                      await userViewModel
                                          .dupCheckNickname(nickname);
                                      setState(() {
                                        validationMessage5 = userViewModel
                                                    .authenticationStatusNickname ==
                                                'ok'
                                            ? '사용 가능한 닉네임입니다.'
                                            : '이미 사용 중인 닉네임입니다.';
                                      });
                                    } else {
                                      // 정규 표현식 조건에 맞지 않으면 경고 메시지 설정
                                      setState(() {
                                        validationMessage5 =
                                            '닉네임은 영어, 숫자, 한글로만 이루어져야 합니다.';
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
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
                            counterText: "", // 이 속성을 추가하여 글자 수 레이블을 숨깁니다.
                          ),
                          maxLength: 10,
                        ),
                        SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            validationMessage5!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'Round',
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        TextFormField(
                          maxLength: 20,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: '비밀번호',
                            labelStyle: TextStyle(
                              fontFamily: 'Round',
                              color: _emailController.text.isEmpty
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 2.0), // 포커스 될 때 밑줄 색깔
                            ),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            bool isLengthValid = value.length >= 8; // 최소 길이 8자
                            bool hasLowercase = value.contains(RegExp(r'[a-z]')); // 소문자 포함
                            bool hasUppercase = value.contains(RegExp(r'[A-Z]')); // 대문자 포함 (필요한 경우 추가)
                            bool hasDigits =
                                value.contains(RegExp(r'[0-9]')); // 숫자 포함
                            bool hasSpecialCharacters = value.contains(
                                RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // 특수 문자 포함
                            //bool isSequentialOrRepeated = hasSequentialOrRepeatedCharacters(value); // 연속되거나 반복되는 문자 제한

                            setState(() {
                              if (!isLengthValid) {
                                validationMessage2 = '비밀번호는 최소 8자 이상이어야 합니다.';
                              } else if (!hasLowercase && !hasUppercase) {
                                validationMessage2 =
                                    '비밀번호에는 적어도 하나의 영문자가 포함되어야 합니다.';
                              } else if (!hasDigits) {
                                validationMessage2 =
                                    '비밀번호에는 적어도 하나의 숫자가 포함되어야 합니다.';
                              } else if (!hasSpecialCharacters) {
                                validationMessage2 =
                                    '비밀번호에는 적어도 하나의 특수문자가 포함되어야 합니다.';
                              } else {
                                validationMessage2 = '올바른 비밀번호입니다.';
                              }
                            });
                          },
                        ),
                        SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            validationMessage2!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'Round',
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        TextFormField(
                          maxLength: 20,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: '비밀번호 재확인',
                            labelStyle: TextStyle(
                              fontFamily: 'Round',
                              color: _emailController.text.isEmpty
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 2.0), // 포커스 될 때 밑줄 색깔
                            ),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            if (value != _passwordController.text) {
                              setState(() {
                                validationMessage3 = '비밀번호가 일치하지 않습니다.';
                              });
                            } else {
                              setState(() {
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
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'Round',
                              fontSize: 13,
                            ),
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
                  onTap: () async {
                    final userViewModel =
                        Provider.of<UserViewModel>(context, listen: false);
                    // 모든 유효성 검사를 통과했는지 확인
                    if (validationMessage == '메일을 보냈습니다.' &&
                        validationMessage2 == '올바른 비밀번호입니다.' &&
                        validationMessage3 == '비밀번호가 일치합니다.' &&
                        validationMessage4 == '인증번호 확인 완료' &&
                        validationMessage5 == '사용 가능한 닉네임입니다.') {
                      // 회원 가입 메소드를 호출
                      if (widget.selectedDepartments.length == 2) {
                        userViewModel.userDto = UserDto(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            nickname: _nicknameController.text.trim(),
                            deptName1: widget.selectedDepartments[0],
                            deptName2: widget.selectedDepartments[1],
                            courseNames: widget.selectedCourses);
                      } else {
                        userViewModel.userDto = UserDto(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            nickname: _nicknameController.text.trim(),
                            deptName1: widget.selectedDepartments[0],
                            courseNames: widget.selectedCourses);
                      }
                      print(
                          'UserDto(email: ${userViewModel.userDto!.email}, password: ${userViewModel.userDto!.password}, '
                          'nickname: ${userViewModel.userDto!.nickname}, deptName1: ${userViewModel.userDto!.deptName1}, '
                          'courseNames: ${userViewModel.userDto!.courseNames!.join(', ')})');
                      // final List<String> selectedDepartments;
                      //   final List<String> selectedCourses;
                      // UserDto({this.email, this.password, this.nickname, this.deptName1, this.deptName2, this.courseNames});
                      await userViewModel.enroll(userViewModel.userDto!);
                      if (userViewModel.registrationStatus == 'ok') {
                        // 회원 가입 성공 처리

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        // 회원 가입 실패 처리
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('회원 가입에 실패했습니다. 다시 시도해 주세요.'),
                            duration: Duration(seconds: 3), // 팝업이 보이는 시간
                            behavior: SnackBarBehavior.floating, // 팝업창 스타일
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(24), // 팝업창 모서리 둥글게
                            ),
                          ),
                        );
                      }
                    } else {
                      // 유효성 검사 중 하나라도 통과하지 못한 경우
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('모든 필드를 다 채워주세요.'),
                          duration: Duration(seconds: 3), // 팝업이 보이는 시간
                          behavior: SnackBarBehavior.floating, // 팝업창 스타일
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24), // 팝업창 모서리 둥글게
                          ),
                        ),
                      );
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
        });
  }
}
