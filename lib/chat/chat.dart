/*
답변하기
 */

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/find_study.dart';
import '../models/study_info.dart';
import '../profile/other_profile.dart';
import '../study_room/bottom_navigation_bar.dart';
import '../view_model/find_study_view_model.dart';
import '../view_model/study_info_view_model.dart';
import '../chat/myQHistoryChat.dart';
import 'package:unis_project/chat/countdown.dart';

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unis_project/css/css.dart';
import 'package:unis_project/chat/report.dart';
import 'package:unis_project/chat/popupReview.dart';
import 'package:unis_project/chat/chatShare.dart';
import '../image_viewer/image_viewer.dart';
import '../view_model/user_profile_info_view_model.dart';
import '../../chat/image_picker_popup.dart';

import 'package:flutter/scheduler.dart';


import '../models/question_model.dart';
import '../view_model/question_view_model.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       home: ChatScreen(qaKey: -1, forAns: false,),
//       theme: ThemeData(
//         textTheme: TextTheme(
//           bodyText2: TextStyle(fontFamily: 'Round'),
//         ),
//       ),
//     );
//   }
// }

class ChatScreen extends StatefulWidget {
  final int qaKey; // qaKey 필드 추가
  final bool forAns;
  final String course;
  String? nickname;
  // 생성자에서 qaKey를 받아 초기화
  ChatScreen({Key? key, required this.qaKey, required this.forAns, required this.course, this.nickname}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(forAns);
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<QaMsgDto> _messages = [];
  bool _isDisposed = false; // 화면을 나갈 때, getMsg를 종료시키도록 하기위해서 필요
  bool hasUserSentMessage = false; // 질문 올렸는지 확인함
  String nickname = ''; // 내 이름
  String questioner = ''; //질문자 이름
  // chatModel.friendNickname // 상대방 이름
  // 내 이름 == 질문자 -> 내가 질문자 ,  내 이름 != 질문자 -> 내가 답변자
  bool isAnonymity = true;

  int myQHistoryChat = 0;
  bool isAnswerd = false; // 답변하기 버튼 클릭 여부

  bool _isQuestioner = false; // true: 내가 질문자, false: 내가 답변자
  DateTime _time = DateTime.now().add(Duration(minutes: 20)); // 20분 재기
  int count = 0; // 첫 시도
  bool isReviewed = false;
  List<String> savedMessages = []; // 답변하기 버튼 누륵기 전 저장
  bool forAns;
  _ChatScreenState(this.forAns); // 미답 진행 완료 셋 중 하나.
  int kcount =0;
  bool shareButton = true; // 공유버튼 챗 스터디에서 들어왔을 때 안보이게 하기위해서 필요
  @override
  void dispose() {
    _isDisposed = true; // Set the flag to true when disposing the screen
    super.dispose();
  }

  // 답변 하기 누르면 뜨는 경고창
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('답변이 제출되었습니다'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbarAndClosePopup(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        '채팅을 선택한 스터디에 공유하였습니다.',
        style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop(); // 팝업창을 닫습니다.
  }

  void _sendImage(String base64Image, QaViewModel chatModel) {
    //  이미지 보낼 때
    QaMsgDto msg = QaMsgDto(
      nickname: nickname,
      type: 'img',
      msg: "",
      img: base64Image,
      // base64로 인코드 해서 보내야함.
      time: (DateTime.now()).toString(),
      isAnonymity: isAnonymity,
    );
    //setState(() {
      _messages.add(msg);
    //});
    chatModel.addMsg(msg);
    hasUserSentMessage = true;
    _scrollToBottom();
  }

  void _sendMsg(String text, QaViewModel chatModel) {
    //  이미지 보낼 때 사용
    QaMsgDto msg = QaMsgDto(
      nickname: nickname,
      type: "text",
      msg: text,
      img: "",
      time: (DateTime.now()).toString(),
      isAnonymity: isAnonymity,
    );
    //setState(() {
      _messages.add(msg);
      _messageController.clear();
    //});
    chatModel.addMsg(msg);
    hasUserSentMessage = true;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery
        .of(context)
        .size
        .width, 500.0);
    final height = min(MediaQuery
        .of(context)
        .size
        .height, 700.0);
    if( widget.nickname == null){
      nickname = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
    }else {
      nickname = widget.nickname!;
      shareButton = false;
    }

    return ChangeNotifierProvider(
        create: (_) => QaViewModel(),
        builder: (context, child) {
          final chatModel = Provider.of<QaViewModel>(context, listen: true);

          // 신고하기
          void _showReportDialog() {
            showDialog(
              context: context,
              builder: (context) => ReportPopup(),
            );
          }

          void startGettingMessages() async {
            while (!_isDisposed) {
              await Future.delayed(const Duration(
                  milliseconds: 500)); // Adjust the delay duration as needed
              await chatModel.refreshQaMessages(widget.qaKey, nickname, kcount, context);
              kcount =1;
              if(chatModel.checker) { // 응답이 와서 미답 -> 진행으로 바뀔 때.
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen(qaKey: widget.qaKey, forAns: false, course: widget.course,)),
                );
              }
            }
          } //

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (count == 0) {
              count++; // 여기서 1로 만들면 아래에서 로딩이 활성화됨.
              await chatModel.checkIsReview(widget.qaKey);
              await chatModel.fetchQaStatus(widget.qaKey);
              if(forAns) {
                await chatModel.fetchQaMessages(
                    widget.qaKey, nickname); // 이거 어떻게 처리?
              }
              else{
                await chatModel.fetchAllMsg(
                    widget.qaKey, nickname); // 이거 어떻게 처리?
              }
              await chatModel.loadProfileImage(
                  chatModel.friendNickname); // 상대방 이름으로 이미지 얻어올 것.

              _isQuestioner = chatModel.isQuestioner;
              //print("isAnonymity : $isAnonymity");
              setState(() {
                isReviewed = chatModel.isReviewed;// =  답변이 됨?
                //status = chatModel.qaStatus;// 리뷰를 함? 체크
                isAnonymity = chatModel.isAnonymity;
                _time = chatModel.time;
              });
             //print("isAnonymity : $isAnonymity");
              if(!forAns) {
                startGettingMessages(); // getmsg 무한루프 돌림.
              }
            }
            _scrollToBottom();
            // if(status != chatModel.qaStatus){
            //     chatModel.setLoading(true);
            //     status = chatModel.qaStatus;
            //     chatModel.setLoading(false);
            // }
          });

          return WillPopScope(
            onWillPop: () async {
              if (chatModel.qaStatus == '미답' && !_isQuestioner) {
                // 사용자에게 경고창을 표시합니다.
                final bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('경고'),
                      content: Text('답변을 포기하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // '취소' 버튼을 누르면 false 반환
                          },
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // '확인' 버튼을 누르면 true 반환
                          },
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm) {
                  chatModel.giveUpQa(widget.qaKey, nickname); // 사용자가 '확인'을 눌렀을 때 포기 동작 수행
                  Navigator.pop(context);
                  return true;
                } else {
                  return false; // 사용자가 '취소'를 누르거나 다이얼로그 밖을 눌러 닫은 경우 뒤로 가기 동작을 취소
                }
              } else {
                Navigator.pop(context); // 다른 조건에서는 그냥 뒤로 가기
                return true;
              }
          },
           child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 55,
                leadingWidth: 105,
                leading: (chatModel.qaStatus == '미답' && !_isQuestioner) // 미답이고, 질문자가 아니// 면
                    ? Container(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () async {
                      final bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('경고'),
                            content: Text('답변을 포기하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // '취소' 버튼을 누르면 false 반환
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // '확인' 버튼을 누르면 true 반환
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm) {
                        chatModel.giveUpQa(widget.qaKey, nickname); // 사용자가 '확인'을 눌렀을 때 포기 동작 수행
                        Navigator.pop(context);
                      }
                      return;
                    },
                    child: Text(
                      '포기하기',
                      style: TextStyle(
                        fontFamily: 'ExtraBold',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                )  // 포기하기 버튼
                    : Padding(
                  padding: EdgeInsets.only(right: 50.0),
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left,
                        size: 30, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ), // 나머지는 그냥 뒤로가기
                title: Text(
                  widget.course,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Bold',
                  ),
                ),
                actions: chatModel.isLoading ? <Widget>[] : [
                  if (_isQuestioner || (!_isQuestioner && chatModel.qaStatus == '완료')) ...[ // 질문자라면
                    if (chatModel.qaStatus== '미답') // '질문자'의 경우 Acton에 질문 완료(끝내기) 또는 취소가 있어야함. 여기는 취소
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: MainGradient(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('알림'),
                                  content: Text('질문을 취소하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String ans = await chatModel.deleteQa(
                                            widget.qaKey);
                                        if (ans == 'no') {
                                          Navigator.of(context).pop(); // 주의!
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('알림'),
                                                content: Text(
                                                    '답변이 되었거나 보고있는 답변자가 있습니다.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('확인'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // 알림 다이얼로그를 닫습니다.
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }
                                        else {
                                          Navigator.of(context).pop(); // 주의!
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            '질문 취소',
                            style: TextStyle(
                              fontFamily: 'ExtraBold',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 15),
                          ),
                        ),
                      ), // 취소가 있어야 함
                    if (chatModel.qaStatus!= '미답' && shareButton) // '질문자'의 경우 '완료' 버튼
                      Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: MainGradient(),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ChangeNotifierProvider(
                              create: (_) => StudyViewModel(),
                              builder: (context, child) {
                                final studychat = Provider.of<StudyViewModel>(context,listen: false);
                              return TextButton(
                                onPressed: () {
                                  if (chatModel.qaStatus == '진행') {
                                    // '완료' 버튼을 눌렀을 때 실행할 작업을 여기에 추가
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PopupReview(qaKey: widget.qaKey); // 리뷰 작성 내부에서 finishQa 실행함.
                                      },
                                    );
                                    setState(() {
                                      isReviewed = true;
                                      chatModel.qaStatus = "완료";
                                    });
                                    // Provider.of<UserProfileViewModel>(context,listen: false).setPoint(, point);
                                  } else { // 여기부터 하면 됨 11-24
                                    // '공유' 버튼을 눌렀을 때 chatShare.dart 파일로 이동
                                    if(isReviewed == true) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            List<MyStudyInfo> myStudyList = Provider.of<MyStudyInfoViewModel>(context,listen: false).MyStudyInfoList;
                                            MyStudyInfo myStudyInfo = MyStudyInfo.defaultValues();
                                            String studyname ='';
                                            int roomKey = -1;
                                            for(int i=0; i< myStudyList.length;i++){
                                              if( myStudyList[i].course == widget.course){
                                                  myStudyInfo = myStudyList[i];
                                                  roomKey = myStudyList[i].roomKey;
                                                  studyname = myStudyList[i].roomName;
                                                  break;
                                              }
                                            }
                                            if (studyname.isEmpty) {
                                              // 스터디가 없는 경우 경고 메시지를 표시합니다.
                                              return AlertDialog(
                                                title: Text(
                                                  "경고",
                                                  style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
                                                ),
                                                content: Text(
                                                  "스터디에 먼저 가입해주세요",
                                                  style: TextStyle(fontFamily: 'Round'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text(
                                                      "확인",
                                                      style: TextStyle(fontFamily: 'Bold'),
                                                    ),
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                              );
                                            } // 스터디 가입이 아직 안되어있는경우 공유 안된다고 경고띄움
                                            else {
                                              return AlertDialog(
                                                title: Text(
                                                  "채팅을 \"$studyname\" 스터디에 공유합니다",
                                                  style: TextStyle(fontFamily: 'Bold',
                                                      color: Colors.grey[700]),
                                                ),
                                                // content: Text(studyname,
                                                //   style: TextStyle(
                                                //       fontFamily: 'Round'),),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context).pop(),
                                                    child: Text(
                                                      "취소",
                                                      style: TextStyle(
                                                          fontFamily: 'Bold'),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async{
                                                      DateTime time = DateTime.now();
                                                      await studychat.sendMessage(StudySendMsgDto( // 공유함
                                                          sender: nickname,
                                                          roomKey: roomKey,
                                                          type: 'share',
                                                          msg: "${widget.qaKey}",
                                                          img: "${widget.course}",
                                                          time: time.toString()));
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => MyHomePage(myStudyInfo: myStudyInfo,)),
                                                      );
                                                    },
                                                    // _selectedStudyIndex가 null일 경우 버튼을 비활성화
                                                    child: Text(
                                                      "확인",
                                                      style: TextStyle(
                                                          fontFamily: 'Bold'),
                                                    ),
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      20.0),
                                                ),
                                              );
                                            }
                                        }
                                      );
                                    } // 리뷰했을 때
                                    else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PopupReview(qaKey: widget.qaKey)),
                                      );
                                    } // 라뷰 안했으면
                                  }
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 15),
                                ),
                                child: Text(
                                  (chatModel.qaStatus == '진행')
                                      ? '완료'
                                      : ((chatModel.qaStatus == '완료' && isReviewed) || !_isQuestioner) ? '공유' : '리뷰',
                                  style: const TextStyle(
                                    fontFamily: 'ExtraBold',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            }
                          )
                      ), // 답변 끝내기(완료)
                  ] else ...[ // '답변자'의 경우 '답변하기' 버튼
                    (chatModel.qaStatus == '미답')
                        ? Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: MainGradient(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () async{
                            if (!hasUserSentMessage) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('알림'),
                                    content: Text('답변을 입력해주세요'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('확인'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              chatModel.qaStatus = '진행';
                              forAns = false;
                              await chatModel.sendQaMessageList(
                                  widget.qaKey, _messages);
                              await chatModel.solveQa(widget.qaKey);
                              Provider.of<UserProfileViewModel>(context,listen: false).incrementAnswer();
                              await chatModel.fetchAllMsg(widget.qaKey, nickname);
                              setState(() {
                                _time = chatModel.time;
                              });
                              startGettingMessages();
                              _showAlertDialog(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 15),
                          ),
                          child: const Text(
                            '답변하기', style: TextStyle(fontFamily: 'ExtraBold',
                            color: Colors.white,
                            fontSize: 15,),
                          ),
                        ),
                      )
                    //     : (chatModel.qaStatus == '완료')  // 완료
                    //       ? Container(
                    //     margin: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //       gradient: MainGradient(),
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     child: TextButton(
                    //       onPressed: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ChatShare()),
                    //             );
                    //       },
                    //       style: TextButton.styleFrom(
                    //         primary: Colors.transparent,
                    //         shadowColor: Colors.transparent,
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: 6, horizontal: 15),
                    //       ),
                    //       child: const Text( '공유',
                    //         style: TextStyle(
                    //           fontFamily: 'ExtraBold',
                    //           color: Colors.white,
                    //           fontSize: 15,
                    //         ),
                    //       ),
                    //     )
                    // ) //완료
                          : Container() // 진행중인 상태에는 아무것도 안보임,
                    ],
                ],
              ),
              body: (chatModel.isLoading == true || count == 0)
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    (chatModel.qaStatus != "완료" && !(_isQuestioner && chatModel.qaStatus == '미답'))  // 미답인 상태에서 답변자거나 진행중일 때, 보여줌.
                        ? Container( // 시간 표기
                      padding:EdgeInsets.all(8),
                      color : Colors.transparent,
                      child : Center(
                        child : isAnswerd
                            ? SizedBox()
                            : Container(
                          padding :
                          EdgeInsets.symmetric(horizontal : 12, vertical : 4),
                          decoration : BoxDecoration(
                            color : Colors.white,
                            borderRadius : BorderRadius.circular(30),
                          ),
                          child :
                          Countdown(endTime :
                          _time
                            , ),
                        ),
                      ),
                    ) : Container(),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: chatModel.qaMessages.length,
                        itemBuilder: (context, index) {
                          final QaMsgDto message = chatModel.qaMessages[index];
                          //message.isAnonymity;
                          final byteImage = base64Decode(message.img);

                          bool shouldDisplayHeader = ( // 메세지가 상대방 메세지이면 프로필 보여줌
                              !message.isAnonymity && // 익명이 아니야
                                  (index == 0 || chatModel.qaMessages[index - 1].nickname != message.nickname));

                          bool shouldDisplayTime = ((index ==
                              chatModel.qaMessages.length - 1 ||
                              chatModel.qaMessages[index + 1].nickname !=
                                  message.nickname ||
                              chatModel.qaMessages[index + 1].time !=
                                  message.time));


                          return Padding(
                            // 메시지 보내는곳.
                            padding: const EdgeInsets.all(8.0),
                            key: ValueKey(index),
                            child: Row(
                              // 메시지 가로로 길게 쭉 있음.
                              mainAxisAlignment: message.nickname == nickname
                                  ? MainAxisAlignment.end // 내 닉네임이면 오른쪽 정렬
                                  : MainAxisAlignment.start,
                              // 상대방 닉네임이면 왼쪽 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // 세로 방향에서 위젯을 시작 부분에 정렬 (모르겠음)
                              children: [
                                if (message.nickname != nickname && shouldDisplayHeader) // 내 메시지가 아닌 상대방 메시지 인데, header를 보여줄 때
                                  Column( // 상대방 프로필 표시
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => OthersProfilePage(message.nickname)),
                                          );
                                        },
                                        child: ClipOval(
                                          child: Image.memory(
                                            chatModel.friendProfileImage,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                    ],
                                  ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column( //  이름 답 시간
                                    crossAxisAlignment:
                                    message.nickname == nickname
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (message.nickname != nickname && shouldDisplayHeader) // 상대방의 경우
                                        Padding( // 닉네임을 표기함
                                          padding: const EdgeInsets.only(
                                              left: 12, bottom: 7),
                                          child: Text(
                                            // 닉네임 표기 *******************************************
                                            message.nickname,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      Row( // 메시지 내용과 시간 표기
                                        mainAxisAlignment:
                                        message.nickname == nickname
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          if (message.nickname ==
                                              nickname) // 나일 경우 **추가, 내 메세지의 시간 표시
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, top: 20.0),
                                              child: shouldDisplayTime // 시간 표기
                                                  ? Text(
                                                message.time,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Round',
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              )
                                                  : Container(),
                                            ),
                                          Container( // 이미지일 경우 높이랑 길이 지정
                                            width: message.type == 'img'
                                                ? width * 0.6
                                                : null,
                                            height: message.type == 'img'
                                                ? height * 0.3
                                                : null,
                                            constraints: BoxConstraints(
                                              maxWidth: width * 0.6,
                                              maxHeight: height * 0.5,
                                            ),
                                            margin: EdgeInsets.only(
                                              left: (message.nickname ==
                                                  nickname) // 나일 경우
                                                  ? 0 // 0
                                                  : (shouldDisplayHeader // 내가 아닐 경우
                                                  ? (!message.isAnonymity
                                                  ? 8.0
                                                  : 4.0) // 익명 아닐 때 프로필 위치
                                                  : (message.isAnonymity
                                                  ? 0
                                                  : 39.0)),
                                              // 익명 일 때 프로필 위치
                                              // top: (message.nickname == myNickname) // 나일 경우
                                              //     ? 0
                                              //     : 0,
                                            ),
                                            padding: message.type == "text"
                                                ? const EdgeInsets.all(8.0)
                                                : null,
                                            decoration:
                                            BoxDecoration(
                                              color: (message.type == 'img')
                                                  ? Colors.grey[200]
                                                  : (message.nickname ==
                                                  nickname) // 나일 경우
                                                  ? Colors.lightBlue // 내 메세지는 파란색
                                                  : Colors.white, // 상대방 메세지는 흰 색
                                              borderRadius: BorderRadius.circular(
                                                  15),
                                              // image: message.type == 'text'
                                              //     ? null
                                              //     : DecorationImage(
                                              //   fit: BoxFit.cover,
                                              //   image: MemoryImage(
                                              //     a, //byteImage[index]
                                              //   ),
                                              // ),
                                            ),
                                            child: message.type ==
                                                "text" // 메세지가 텍스트일 때
                                                ? Text(
                                              message.msg,
                                              style: TextStyle(
                                                color:
                                                (message.nickname ==
                                                    nickname)
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontFamily: 'Round',
                                              ),
                                            )
                                                : message.type ==
                                                "img" // 메세지가 이미지일 때
                                                ? ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  15),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(
                                                      context)
                                                      .push(
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                            PhotoView(
                                                              photoData:
                                                              byteImage,
                                                            ),
                                                      ));
                                                },
                                                child: Image.memory(
                                                  byteImage,
                                                  width: width * 0.6,
                                                  height: height * 0.3,
                                                  fit: BoxFit.cover,
                                                  gaplessPlayback: true,
                                                ),
                                              ),
                                            )
                                                : SizedBox(),
                                          ),
                                          if (message.nickname !=
                                              nickname) // 내 닉네임이 아닌 경우
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                // 상대방 메세지의 시간 표시
                                                  left: 8.0,
                                                  top: 20.0),
                                              child: shouldDisplayTime
                                                  ? Text(
                                                // 메세지 시간 표시 스타일
                                                message.time, // 시간을 보여줌
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Round',
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              )
                                                  : Container(), // 대화 내용
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ); // 메시지 주고받는것들
                        },
                      ),
                    ),
                    Container(
                      // 하단에  있는것들.
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.warning_amber_rounded),
                            color: Colors.grey,
                            iconSize: 30,
                            onPressed: _showReportDialog,
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline_rounded),
                            color: Colors.grey,
                            iconSize: 30,
                            onPressed: chatModel.qaStatus != "완료" ? () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ImagePickerPopup(
                                    onImagePicked: (pickedFile) async {
                                      Uint8List imageBytes = await pickedFile!
                                          .readAsBytes();
                                      DateTime time = DateTime.now();
                                      if (!(forAns)) { // 답변하기를 한 후에 답변자 -> 이미지 바로 전송하면 됨
                                        // 질문자 -> 무조건 바로 전송. 답변자와 같음. 구분 x
                                        await chatModel.fetchQaStatus(widget.qaKey);

                                        if(chatModel.qaStatus != '완료') {
                                          await chatModel.sendQaMessage(widget.qaKey,
                                              nickname,
                                              'img',
                                              "",
                                              imageBytes,
                                              time.toString());
                                        }
                                      }
                                      else { // 답변하기 하기 이전에 답변자  : mssagesToSend에 저장했다가 답변하기 할 때 한꺼번에 보냄
                                        final String base64Image = base64Encode(
                                            imageBytes);
                                        _sendImage(
                                            base64Image,chatModel); // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                                      } // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                                    },
                                  ); //
                                },
                              );
                            }: null,
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: width * 0.7,
                                maxHeight: height * 0.7,
                              ),
                              height: 40,
                              child: TextField(
                                maxLength: 200,
                                controller: _messageController,
                                enabled: chatModel.qaStatus != "완료",
                                decoration: InputDecoration(
                                  hintText: '메시지를 입력하세요',
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  counterText:
                                  '', // This will hide the character count
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Transform.rotate(
                              angle: -30 * (3.141592653589793 / 180),
                              child: Icon(
                                Icons.send,
                                color: _messageController.text.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            onPressed: () async{
                              if (_messageController.text.isNotEmpty) {
                                if (!(forAns)) { // 답변하기를 한 후에 답변자 -> 이미지 바로 전송하면 됨
                                  // 질문자 -> 무조건 바로 전송. 답변자와 같음. 구분 x
                                  //print("dasjfasdkfjhsdafjd : $forAns");
                                  DateTime time = DateTime.now();
                                  await chatModel.fetchQaStatus(widget.qaKey);

                                  if (chatModel.qaStatus != '완료') {
                                    chatModel.sendQaMessage(widget.qaKey,
                                        nickname,
                                        'text',
                                        _messageController.text,
                                        Uint8List(0),
                                        time.toString());
                                  }
                                }
                                else { // 답변하기 하기 이전에 답변자  : mssagesToSend에 저장했다가 답변하기 할 때 한꺼번에 보냄
                                  _sendMsg(_messageController.text,chatModel);
                                  // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                                } // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                                _messageController.text = '';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
