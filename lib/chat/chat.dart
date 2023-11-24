/*
답변하기
 */

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'myQHistoryChat.dart';
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
import 'image_picker_popup.dart';

import 'package:flutter/scheduler.dart';


import '../models/question_model.dart';
import '../view_model/question_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: ChatScreen(qaKey: -1),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final int qaKey; // qaKey 필드 추가

  // 생성자에서 qaKey를 받아 초기화
  ChatScreen({Key? key, required this.qaKey}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
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
  String status = "진행"; // 미답 진행 완료 셋 중 하나.

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
    nickname = Provider
        .of<UserProfileViewModel>(context, listen: false)
        .nickName;

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
              await chatModel.refreshQaMessages(widget.qaKey, nickname);
            }
          } //

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (count == 0) {
              count++; // 여기서 1로 만들면 아래에서 로딩이 활성화됨.
              await chatModel.fetchQaMessages(widget.qaKey, nickname);
              await chatModel.loadProfileImage(
                  chatModel.friendNickname); // 상대방 이름으로 이미지 얻어올 것.
              _isQuestioner = chatModel.isQuestioner;
              await chatModel.checkIsReview(widget.qaKey);
              await chatModel.fetchQaStatus(widget.qaKey);
              isReviewed = chatModel.isReviewed;// =  답변이 됨?
              status = chatModel.qaStatus;// 리뷰를 함? 체크
              isAnonymity = chatModel.isAnonymity;
              startGettingMessages(); // getmsg 무한루프 돌림.
              if(status == '진행') {
                _time = await chatModel.getAnswerTime(widget.qaKey);
              }
            }
            _scrollToBottom();
          });

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 55,
              leadingWidth: 105,
              leading: (status == '미답' && _isQuestioner) // 미답이고, 질문자이면
                  ? Container(
                margin: EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    chatModel.giveUpQa(widget.qaKey, nickname); //포기
                    Navigator.pop(context);
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
                '과목명',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Bold',
                ),
              ),
              actions: [
                if (_isQuestioner) ...[ // 질문자라면
                  if (status == '미답') // '질문자'의 경우 Acton에 질문 완료(끝내기) 또는 취소가 있어야함. 여기는 취소
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
                  if (status != '미답') // '질문자'의 경우 '완료' 버튼
                    Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: MainGradient(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (status == '진행') {
                              // '완료' 버튼을 눌렀을 때 실행할 작업을 여기에 추가
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PopupReview(qaKey: widget.qaKey); // 리뷰 작성 내부에서 finishQa 실행함.
                                },
                              );
                            } else { // 여기부터 하면 됨 11-24
                              // '공유' 버튼을 눌렀을 때 chatShare.dart 파일로 이동
                              if(isReviewed == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatShare()),
                                );
                              }
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
                            (status == '진행')
                                ? '완료'
                                : (status == '완료' && isReviewed) ? '공유' : '리뷰',
                            style: const TextStyle(
                              fontFamily: 'ExtraBold',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        )
                    ), // 답변 끝내기(완료)
                ] else ...[ // '답변자'의 경우 '답변하기' 버튼
                  (status == '미답')
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
                            status = '진행';
                            await chatModel.sendQaMessageList(
                                widget.qaKey, _messages);
                            await chatModel.solveQa(widget.qaKey);
                            await chatModel.fetchQaMessages(widget.qaKey, nickname);
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
                      : (status == '완료')  // 완료
                        ? Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: MainGradient(),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatShare()),
                              );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              vertical: 6, horizontal: 15),
                        ),
                        child: const Text( '공유',
                          style: TextStyle(
                            fontFamily: 'ExtraBold',
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      )
                  ) //완료
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
                  ((status == '미답' && !_isQuestioner) || (status == '진행'))  // 미답인 상태에서 답변자거나 진행중일 때, 보여줌.
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
                        child : Countdown(endTime : _time, ),
                      ),
                    ),
                  ) : Container(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: chatModel.qaMessages.length,
                      itemBuilder: (context, index) {
                        final QaMsgDto message = chatModel.qaMessages[index];

                        final byteImage = base64Decode(message.img);

                        bool shouldDisplayHeader = ( // 메세지가 상대방 메세지이면 프로필 보여줌
                            !isAnonymity && // 익명이 아니야
                                (index == 0 ||
                                    chatModel.qaMessages[index - 1].nickname !=
                                        message.nickname));

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
                                    CircleAvatar(
                                      backgroundImage: MemoryImage(chatModel
                                          .friendProfileImage), // ** 추가
                                      radius: 15,
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
                                    if (message.nickname != nickname &&
                                        shouldDisplayHeader) // 상대방의 경우
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
                                                ? (!isAnonymity
                                                ? 8.0
                                                : 4.0) // 익명 아닐 때 프로필 위치
                                                : (isAnonymity
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
                          onPressed: status != "완료" ? () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ImagePickerPopup(
                                  onImagePicked: (pickedFile) async {
                                    Uint8List imageBytes = await pickedFile!
                                        .readAsBytes();
                                    DateTime time = DateTime.now();
                                    if (_isQuestioner || isAnswerd) { // 답변하기를 한 후에 답변자 -> 이미지 바로 전송하면 됨
                                      // 질문자 -> 무조건 바로 전송. 답변자와 같음. 구분 x
                                      await chatModel.fetchQaStatus(widget.qaKey);
                                      status = chatModel.qaStatus;
                                      if(status != '완료') {
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
                              enabled: status != "완료",
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
                              if (_isQuestioner || isAnswerd) { // 답변하기를 한 후에 답변자 -> 이미지 바로 전송하면 됨
                                // 질문자 -> 무조건 바로 전송. 답변자와 같음. 구분 x
                                DateTime time = DateTime.now();
                                await chatModel.fetchQaStatus(widget.qaKey);
                                status = chatModel.qaStatus;
                                if (status != '완료') {
                                  chatModel.sendQaMessage(widget.qaKey,
                                      nickname,
                                      'text',
                                      _messageController.text,
                                      Uint8List(0),
                                      time.toString());
                                }
                              }
                              else { // 답변하기 하기 이전에 답변자  : mssagesToSend에 저장했다가 답변하기 할 때 한꺼번에 보냄
                                _sendMsg(_messageController.text,chatModel); // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                              } // 내부적으로 저 경로를 따라서 이미지를 다른곳에 저장 후 그 저장된 경로를 profileImage 에 저장함.
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
