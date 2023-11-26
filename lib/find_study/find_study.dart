import 'package:flutter/material.dart';
import 'package:unis_project/find_study/create_study.dart';
import '../../../css/css.dart';
import '../chat/OneToOneChat.dart';
import '../models/study_info.dart';
import '../study_room/bottom_navigation_bar.dart';

import 'dart:math';

import 'package:provider/provider.dart';
import '../study_room/study_home.dart';
import '../view_model/find_study_view_model.dart';
import '../models/find_study.dart';
import '../view_model/study_info_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: FindStudyScreen(),
    );
  }
}

class FindStudyScreen extends StatefulWidget {
  @override
  _FindStudyScreenState createState() => _FindStudyScreenState();
}

class _FindStudyScreenState extends State<FindStudyScreen>
    with SingleTickerProviderStateMixin {
  int count = 0;

  bool isAll = true; //스터디찾기에서 전체가 켜져있는지
  bool isSeatLeft = false; //스터디찾기에서 잔여석이 켜져있는지
  bool isOpen = false; //스터디찾기에서 공개가 켜져있는지

  void selectCategory(bool _isAll, bool _isSeatLeft, bool _isOpen) {
    setState(() {
      isAll = _isAll;
      isSeatLeft = _isSeatLeft;
      isOpen = _isOpen;
    });
  }

  // 스터디 가입 함수
  void _joinStudy(String code, StudyInfoDto selectedStudy, StudyViewModel viewModel, ) async {
    //final viewModel = Provider.of<StudyViewModel>(context, listen: false); // find study에 있는 함수들을 호출할 때 사용.
    final mystudy = Provider.of<MyStudyInfoViewModel>(context, listen: false); // 내가 가입한 스터디 리스트를 갖고있음

    // 유저가 이미 같은 과목의 스터디에 가입했는지 검사
    List<MyStudyInfo> myStudyList =
        Provider.of<MyStudyInfoViewModel>(context, listen: false)
            .MyStudyInfoList;
    bool alreadyJoined = false;

    for (int i = 0; i < myStudyList.length; i++) {
      if (myStudyList[i].course == selectedStudy.course) {
        alreadyJoined = true;
        break;
      }
    }

    if (alreadyJoined) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('해당 과목 스터디에 이미 가입했습니다.')));
      return;
    }

    await viewModel.joinStudy(Provider.of<UserProfileViewModel>(context,listen: false).nickName, selectedStudy.roomKey, code);

    // 가입 결과 처리
    if (viewModel.resultMessage == '스터디 가입 성공!') {
      print('가입 성공 전 - MyStudyInfoList 상태: ${mystudy.MyStudyInfoList}');

      await mystudy.getMyStudyRoomList(Provider.of<UserProfileViewModel>(context,listen: false).nickName); // 가입한 스터디 목록 갱신

      print('가입 성공 후 - MyStudyInfoList 상태: ${mystudy.MyStudyInfoList}');



      MyStudyInfo joinedStudyInfo = MyStudyInfo(
          roomKey: selectedStudy.roomKey,
          roomName: selectedStudy.roomName,
          course: selectedStudy.course,
          maxNum: selectedStudy.maxNum,
          curNum: selectedStudy.curNum + 1,
          startDate: selectedStudy.startDate,
          studyIntroduction: selectedStudy.studyIntroduction);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('스터디 가입에 성공했습니다.')));

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage( myStudyInfo: joinedStudyInfo,)));

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(viewModel.resultMessage)));
    }
  }

  // 비밀번호 입력 다이얼로그 함수
  void _showPasswordDialog(StudyInfoDto selectedStudy, StudyViewModel info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String password = '';
        return AlertDialog(
          title: Text('비밀번호를 입력하세요'),
          content: TextField(
            onChanged: (value) => password = value,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                _joinStudy(password, selectedStudy, info);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.only(left: 16.0),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[400],
            ),
            onPressed: () {Navigator.pop(context);},
          ),
          actions: [
            IconButton(
              // 스터디 찾기 검색
              icon: Icon(
                Icons.search_rounded,
                size: 30,
              ),
              color: Colors.grey[400],
              onPressed: () {
                //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: GradientText(
              width: width, text: '스터디 찾기', tSize: 0.06, tStyle: 'Bold'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: CustomTabBar(onEvent: selectCategory),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildTabContent(RoomStatusDto(
              isAll: isAll, isSeatLeft: isSeatLeft, isOpen: isOpen)),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // 스터디 생성 호출
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateStudy()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: width * 0.13,
                height: width * 0.13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: width * 0.06,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(RoomStatusDto roomStatus) {
    return ChangeNotifierProvider(
      create: (_) => StudyViewModel(),
      builder: (context, child) {
        final info = Provider.of<StudyViewModel>(context, listen: true);

        final width = min(MediaQuery.of(context).size.width, 500.0);
        final height = MediaQuery.of(context).size.height;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final nickname = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
          if (count == 0) {
            count++;
            await info.getStudyRoomList(nickname, roomStatus);
          }
          if (count != 0 &&
              (info.roomStatus.isAll != isAll ||
                  info.roomStatus.isOpen != isOpen ||
                  info.roomStatus.isSeatLeft != isSeatLeft)) {
            print("isAll: $isAll, isOpen: $isOpen, isSeatLeft : $isSeatLeft");
            await info.getStudyRoomList(nickname, roomStatus);
          }
        });

        return (info.isLoading || count == 0)
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.only(top: 10.0),
                color: Colors.grey[200],
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: info.studyRoomlist.length,
                  itemBuilder: (context, index) {
                    final selectedStudy = info.studyRoomlist[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    selectedStudy!.roomName,
                                    style: TextStyle(
                                        fontFamily: 'Bold', fontSize: 21, color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('그룹장: ${selectedStudy!.leader}',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 15,
                                          color: Colors.grey[600])),// 그룹장
                                  SizedBox(height: 8.0),
                                  Text('시작일: ${selectedStudy!.startDate}',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 15,
                                          color: Colors.grey[600])), // 시작일
                                  SizedBox(height: 10.0),
                                  Divider(
                                    thickness: 1.3,
                                  ),
                                  SizedBox(height: 13.0),
                                  Text(
                                    '${selectedStudy!.studyIntroduction}',
                                    style: TextStyle(
                                        fontFamily: 'Bold',
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        height: 1.2),
                                    maxLines: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ), // 소개글
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    // 스터디 리더의 닉네임을 가져온다
                                    String leaderNickname = await info.getLeader(selectedStudy.roomKey);

                                    // 리더와 대화
                                    if (leaderNickname.isNotEmpty) {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => OneToOneChatScreen(friendName: leaderNickname,)
                                      ));
                                    } else {
                                      // 리더 정보를 가져오지 못한 경우 에러 메시지 표시
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('스터디 리더 정보를 가져오는 데 실패했습니다.')));
                                    }
                                  },
                                  child: Text('쪽지 보내기',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 14,
                                          color: Color(0xFF3D6094))),
                                ), // 쪽지보내기
                                TextButton(
                                  onPressed: () {
                                    if (!(selectedStudy.isOpen)) {
                                      // 비밀번호가 있는 경우, 팝업을 보여준다
                                      _showPasswordDialog(selectedStudy,info);
                                    } else {
                                      _joinStudy('',selectedStudy,info);
                                    }
                                  },
                                  child: Text('스터디 가입',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 14,
                                          color: Color(0xFF3D6094))),
                                ),  // 스터디 가입
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('취소',
                                      style: TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 14,
                                          color: Colors.grey[500])),
                                ), // 취소 버튼
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            );
                          }
                        );
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 23),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(selectedStudy.roomName, // 스터디명
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'Bold',
                                          fontSize: width * 0.055)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      selectedStudy.course, // 과목명
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Color(0xFF3D6094),
                                          fontFamily: 'Bold',
                                          fontSize: width * 0.03),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20, height: 23,
                                    child: !selectedStudy.isOpen ? IconButton(
                                      icon: Icon(
                                        Icons.lock,
                                        size: 20,
                                      ),
                                      color: Colors.grey[500],
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ) : SizedBox.shrink(),  // true이면 표시xx
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              Text(
                                selectedStudy.studyIntroduction, // 스터디 소개
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Bold',
                                    fontSize: width * 0.025),
                              ),
                              SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text("${selectedStudy.curNum}/${selectedStudy.maxNum}명",
                                          style: TextStyle(
                                              fontFamily: 'Round',
                                              fontSize: 13)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '시작일',
                                        style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 13,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        selectedStudy.startDate,
                                        style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: 13,
                                            color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}

class CustomTabBar extends StatefulWidget {
  final Function(bool, bool, bool) onEvent;

  CustomTabBar({required this.onEvent});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  bool _isTab1Selected = true; // 전체 탭의 선택 상태를 저장합니다.
  bool _isTab2Selected = false; // 잔여석 탭의 선택 상태를 저장합니다.
  bool _isTab3Selected = false; // 공개 탭의 선택 상태를 저장합니다.

  void _toggleTab1() {
    setState(() {
      _isTab1Selected = true;
      _isTab2Selected = false;
      _isTab3Selected = false;
    });
    widget.onEvent(_isTab1Selected, _isTab2Selected, _isTab3Selected);
  }

  void _toggleTab2() {
    setState(() {
      if (!_isTab2Selected) {
        _isTab1Selected = false;
        _isTab2Selected = true;
      } else if (_isTab2Selected && !_isTab3Selected) {
        _isTab1Selected = true;
        _isTab2Selected = false;
      } else if (_isTab2Selected && _isTab3Selected) {
        _isTab2Selected = false;
      }
    });
    widget.onEvent(_isTab1Selected, _isTab2Selected, _isTab3Selected);
  }

  void _toggleTab3() {
    setState(() {
      if (!_isTab3Selected) {
        _isTab1Selected = false;
        _isTab3Selected = true;
      } else if (_isTab3Selected && !_isTab2Selected) {
        _isTab1Selected = true;
        _isTab3Selected = false;
      } else if (_isTab3Selected && _isTab2Selected) {
        _isTab3Selected = false;
      }
    });
    widget.onEvent(_isTab1Selected, _isTab2Selected, _isTab3Selected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 20,
          ),
          _buildTab('전체', _isTab1Selected, _toggleTab1),
          SizedBox(
            width: 20,
          ),
          _buildTab('잔여석', _isTab2Selected, _toggleTab2),
          SizedBox(
            width: 20,
          ),
          _buildTab('공개', _isTab3Selected, _toggleTab3),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 17),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? Colors.grey[400] : Colors.white,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16, color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}



