import 'package:flutter/material.dart';
import 'department_select_signup.dart';
import 'dart:math';
import '../css/css.dart';
void main() {
  runApp(User_agreement());
}

class User_agreement extends StatelessWidget {
  const User_agreement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: UserAgreementScreen(),
    );
  }
}

class UserAgreementScreen extends StatefulWidget {
  @override
  _UserAgreementScreenState createState() => _UserAgreementScreenState();
}

class _UserAgreementScreenState extends State<UserAgreementScreen> {
  List<bool> _isChecked = [false, false, false];  // 체크박스 상태를 추적하기 위한 리스트

  @override
  Widget build(BuildContext context) {
    final double width =  min(MediaQuery.of(context).size.width,500);
    final double height = MediaQuery.of(context).size.height;

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
            width: width, text: '사용자 동의', tSize: 0.05, tStyle: 'Bold'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "회원가입을 위해 아래의 유니스 회원 가입에 필요한 내용을 자세히 읽고 동의합니다",
              style: TextStyle(fontSize: width * 0.04, fontFamily: 'Round'),
            ),
            Divider(),
            AgreementItem(index: 0, title: "이용약관 동의", isChecked: _isChecked, onCheckedChanged: _onCheckedChanged),
            AgreementItem(index: 1, title: "개인정보처리 방침", isChecked: _isChecked, onCheckedChanged: _onCheckedChanged),
            AgreementItem(index: 2, title: "개인정보 유효기간(1년)", isChecked: _isChecked, onCheckedChanged: _onCheckedChanged),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.2, height * 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: null,
                  child:  Text(
                    '이전',
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'Bold',
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: width * 0.2, // Minimum width of the container
                    minHeight: height * 0.05, // Minimum height of the container
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
                        if (_isChecked.every((isChecked) => isChecked)) {
                          // 모든 체크박스가 체크된 경우, 다음 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DepartmentSelectionScreen()),
                          );
                        } else {
                          // 모든 체크박스가 체크되지 않은 경우, 사용자에게 알림
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('모든 항목에 동의해야 다음으로 진행할 수 있습니다.'),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            '다음',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Bold',
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: Size(width * 0.2, height * 0.05),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   onPressed: () {
                //     if (_isChecked.every((isChecked) => isChecked)) {
                //       // 모든 체크박스가 체크된 경우, 다음 화면으로 이동
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => DepartmentSelectionScreen()),
                //       );
                //     } else {
                //       // 모든 체크박스가 체크되지 않은 경우, 사용자에게 알림
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content: Text('모든 항목에 동의해야 다음으로 진행할 수 있습니다.'),
                //         ),
                //       );
                //     }
                //   },
                //   child: Text('다음'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckedChanged(int index, bool value) {
    setState(() {
      _isChecked[index] = value;
    });
  }
}

class AgreementItem extends StatelessWidget {
  final int index;
  final String title;
  final List<bool> isChecked;
  final Function(int, bool) onCheckedChanged;

  AgreementItem({
    required this.index,
    required this.title,
    required this.isChecked,
    required this.onCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "[필수] $title",
          style: TextStyle(color: Colors.blue, fontFamily: 'Round'),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              "$title 내용",
                              style: TextStyle(fontFamily: 'Round'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                "[전문보기]",
                style: TextStyle(color: Colors.blue, fontFamily: 'Round'),
              ),
            ),
            Checkbox(
              value: isChecked[index],
              onChanged: (value) {
                onCheckedChanged(index, value!);
              },
              shape: CircleBorder(),
            ),
          ],
        ),
      ],
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
