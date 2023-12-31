import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/models/study_info.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import '../models/find_study.dart';
import '../subject_selector/subject_selector.dart';
import 'dart:math';

import '../view_model/find_study_view_model.dart';

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       theme: ThemeData(
//         fontFamily: 'Round',
//       ),
//       home: StudyRoomSetting(),
//     );
//   }
// }

class StudyRoomSetting extends StatefulWidget {
  MyStudyInfo myStudyInfo;
  String code;
  String leader;
  List<UserInfoMinimumDto> studyFriendList;

  StudyRoomSetting(
      this.myStudyInfo, this.code, this.leader, this.studyFriendList);

  @override
  _StudyRoomSettingState createState() => _StudyRoomSettingState(myStudyInfo);
}

class _StudyRoomSettingState extends State<StudyRoomSetting> {
  MyStudyInfo myStudyInfo;
  var titleController = TextEditingController();
  var passwordController = TextEditingController();
  var descriptionController = TextEditingController();
  String? subject = null;
  String numberOfPeople = '인원 선택';

  _StudyRoomSettingState(this.myStudyInfo);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: myStudyInfo.roomName);
    passwordController = TextEditingController(text: widget.code);
    descriptionController =
        TextEditingController(text: myStudyInfo.studyIntroduction);
    subject = myStudyInfo.course;
    numberOfPeople = "${myStudyInfo.maxNum}명";
  }

  Future<void> _selectNumberOfPeople() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String? selectedValue; // 선택된 인원

        return AlertDialog(
          title: Text('인원 선택'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true, // 리스트의 크기를 내용에 맞게 조절
              itemCount: 5, // 5개의 항목 (1명 ~ 5명)
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${index + 1}명'),
                  onTap: () {
                    setState(() {
                      numberOfPeople = '${index + 1}명';
                    });
                    Navigator.of(context).pop(); // 선택 후 다이얼로그 닫기
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = MediaQuery.of(context).size.height;
    final nickname =
        Provider.of<UserProfileViewModel>(context, listen: false).nickName;
    return ChangeNotifierProvider(
      create: (_) => StudyViewModel(),
      builder: (context, child) {
        final mystudylist = Provider.of<StudyViewModel>(context, listen: false);

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
            actions: [
              // `actions` 속성을 사용하여 IconButton을 추가합니다.
              IconButton(
                icon: GradientIcon(iconData: Icons.check),
                onPressed: () async {
                  //class StudyChangeDto {
                  //   String roomName;
                  //   String course;
                  //   int maxNum;
                  //   bool isOpen;
                  //   String code;
                  //   String studyIntroduction;
                  int number = int.parse(numberOfPeople[0]);

                  if (myStudyInfo.curNum > number) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("현재 인원수보다 많은 인원으로 설정해야합니다"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    await mystudylist.changeStudyInfo(
                        myStudyInfo.roomKey,
                        StudyChangeDto(
                          roomName: titleController.text,
                          course: subject!,
                          maxNum: number,
                          isOpen: passwordController.text.isEmpty,
                          code: passwordController.text,
                          studyIntroduction:
                              descriptionController.text, // 비어있으면 true
                        ));
                    myStudyInfo.roomName = titleController.text;
                    myStudyInfo.course = subject!;
                    myStudyInfo.maxNum = number;
                    myStudyInfo.studyIntroduction = descriptionController.text;
                    print("제목: ${titleController.text}");
                    print("비밀번호: ${passwordController.text}");
                    print("설명: ${descriptionController.text}");
                    print("과목명: ${subject}");
                    print("인원수: ${numberOfPeople}");
                    Navigator.pop(context);
                  }
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            // Title을 중앙에 배치
            title: GradientText(
                width: width, text: '스터디 설정', tSize: 0.06, tStyle: 'Bold'),
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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  (widget.leader == nickname)
                      ? Column(
                          children: [
                            TextField(
                              controller: titleController, // 컨트롤러 연결
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.grey[200],
                                // 배경색을 회색으로 설정
                                filled: true,
                                // 배경색을 적용하기 위해 필요한 속성
                                labelText: '   제목',
                                labelStyle: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.045,
                                  color: Colors
                                      .grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                                ),
                                counterText: "", // 글자 수 레이블을 숨깁니다.
                              ),
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize: width * 0.045,
                                color: Colors.black, // 입력할 때의 글씨색을 지정
                              ),
                              maxLength: 10,
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: passwordController, // 컨트롤러 연결
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.grey[200],
                                // 배경색을 회색으로 설정
                                filled: true,
                                // 배경색을 적용하기 위해 필요한 속성
                                labelText: '   비밀번호(선택)',
                                labelStyle: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.045,
                                  color: Colors
                                      .grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                                ),
                                counterText: "", // 글자 수 레이블을 숨깁니다.
                              ),
                              maxLength: 8,
                            ),
                            SizedBox(height: 10),
                            // 과목 선택과 인원 선택은 단순 Dropdown 혹은 Picker를 사용하여 구현할 수 있습니다.
                            // 아래는 단순한 예시입니다.

                            Container(
                              padding:
                                  EdgeInsets.only(top: 5, bottom: 5, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                        ),
                                        subject == null
                                            ? Text(
                                                '과목 선택',
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'Bold',
                                                    fontSize: width * 0.045),
                                              )
                                            : Text(
                                                subject!.length > 18
                                                    ? subject!
                                                            .substring(0, 18) +
                                                        '...'
                                                    : subject!,
                                                style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontFamily: 'Bold',
                                                    fontSize: width * 0.04),
                                              ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 25,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // SizedBox를 Container로 변경
                                    height: 1.0,
                                    color: Colors.white,
                                  ),
                                  InkWell(
                                    onTap: _selectNumberOfPeople,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Text(
                                            numberOfPeople,
                                            style: numberOfPeople == '인원 선택'
                                                ? TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'Bold',
                                                    fontSize: width * 0.045,
                                                  )
                                                : TextStyle(
                                                    color: Colors.grey[900],
                                                    fontFamily: 'Bold',
                                                    fontSize: width * 0.04),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 25,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: descriptionController, // 컨트롤러 연결
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.grey[200],
                                // 배경색을 회색으로 설정
                                filled: true,
                                // 배경색을 적용하기 위해 필요한 속성
                                hintText: '   스터디에 대해 설명해주세요',
                                hintStyle: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: width * 0.045,
                                  color: Colors
                                      .grey[400], // 이 부분에서 레이블 텍스트의 색상을 변경합니다.
                                ),
                                counterText: "", // 글자 수 레이블을 숨깁니다.
                              ),
                              maxLength: 200,
                              maxLines: 10,
                            ),
                          ],
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: MainGradient(),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          String studyTitle = myStudyInfo.roomName;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  '스터디 탈퇴',
                                  style: TextStyle(fontFamily: 'Round'),
                                ),
                                content:
                                    Text("'$studyTitle' 스터디를 정말 탈퇴하시겠습니까?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('확인'),
                                    onPressed: () async {
                                      print(
                                          "widget.leader == nickname : ${widget.leader == nickname}, myStudyInfo.curNum : ${myStudyInfo.curNum}");
                                      if ((widget.leader == nickname) && myStudyInfo.curNum != 1) {
                                        // 리더일 경우 리더 넘겨야함
                                        for (int i = 0; i < myStudyInfo.curNum; i++) {
                                          print("nickname : $i ${widget.studyFriendList[i].nickname}");
                                          if (widget.studyFriendList[i].nickname != nickname) {
                                            // 아무나 찾아서 넘김
                                            //print("nickname : ${mystudylist.studyFriendList[i].nickname}");
                                            await mystudylist.commitLeader(
                                              myStudyInfo.roomKey,
                                              widget
                                                  .studyFriendList[i].nickname,
                                            );
                                            break;
                                          }
                                        }
                                      }

                                      await mystudylist.leaveStudy(
                                          myStudyInfo.roomKey, nickname);
                                      Provider.of<UserProfileViewModel>(context,
                                              listen: false)
                                          .decrementStudyCnt();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '스터디 탈퇴',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
