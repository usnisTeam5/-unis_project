import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/models/study_info.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import '../file_selector/file_selector.dart';
import '../models/study_quiz_model.dart';
import '../view_model/find_study_view_model.dart';
import '../view_model/study_quiz_view_model.dart';
import 'quiz_creator.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
// void main() {
//   runApp(MyApp());
// }

class FileSelector {
  Future<File?> pickDocument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      // 사용자가 파일 선택을 취소한 경우
      return null;
    }
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       theme: ThemeData(
//         fontFamily: 'Bold',
//       ),
//       home: QuizFolderScreen(),
//     );
//   }
// }

class QuizFolderScreen extends StatefulWidget {
  MyStudyInfo myStudyInfo;
  QuizFolderScreen(this.myStudyInfo);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizFolderScreen> {
  // 과목 목록
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
        create: (_) => StudyQuizViewModel(),
        builder: (context, child) {

          final quizViewModel = Provider.of<StudyQuizViewModel>(context, listen: true);
          WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
            // context를 사용하여 UserProfileViewModel에 접근
            //print("sdfsdfsdfsadfasdfsadfasdf");

            if(count == 0) {
              count ++;
              print("count: ${count}");
              await quizViewModel.getFolderList(widget.myStudyInfo.roomKey); // **
            }
          });

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              ),
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              // `actions` 속성을 사용하여 IconButton을 추가합니다.
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                color: Colors.grey,
                onPressed: () async {
                    String? folderName = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController _controller = TextEditingController();
                        return AlertDialog(

                          title: Text('폴더 추가',style: TextStyle(fontFamily: 'Round'),),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: '폴더 이름',
                            ),
                            maxLength: 10,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('추가'),
                              onPressed: () async{
                                if(_controller.text.isNotEmpty) {
                                  await quizViewModel.makeFolder(
                                      widget.myStudyInfo.roomKey,
                                      _controller.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('폴더가 만들어졌습니다.'),
                                      duration: Duration(seconds: 2), // 스낵바 표시 시간
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('폴더 이름을 입력해 주세요'),
                                      duration: Duration(seconds: 2), // 스낵바 표시 시간
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            // Title을 중앙에 배치
            title: GradientText(
                width: width, text: 'Quiz', tSize: 0.06, tStyle: 'Bold'),
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
          body: FoldersScreen(widget.myStudyInfo.roomKey, widget.myStudyInfo),
        );
      }
    );
  }
}

class FoldersScreen extends StatefulWidget {
  int roomkey;
  MyStudyInfo myStudyInfo;
  FoldersScreen(this.roomkey, this.myStudyInfo, {
    Key? key,
  }) : super(key: key);

  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<StudyQuizListDto> folders = []; // 폴더
  FileSelector? fileSelector;

  final Map<String, List<String>> folderDocuments = {}; // 폴더 문서
  void _showDocumentList(List<String> users, int folderKey, String folderName, StudyQuizViewModel quizViewModel, String leader) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$folderName. 문서 등록자'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(users[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      String nickname = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
                      if (nickname == leader || users[index] == nickname) {

                        String deletedUser = users[index]; // 삭제할 사용자 저장
                        users.removeAt(index);
                        await quizViewModel.deleteUser(widget.roomkey, folderKey, deletedUser);
                        Navigator.of(context).pop();
                        _showDocumentList(users, folderKey, folderName, quizViewModel, leader);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$deletedUser님의 문서가 삭제되었습니다.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('방장을 제외한 나머지는 본인 문서만 삭제할 수 있습니다.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
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
    final quizViewModel = Provider.of<StudyQuizViewModel>(context, listen: true);
    folders = quizViewModel.folderList;
    return SingleChildScrollView(
      child: (folders.isNotEmpty)
          ? Column(
        children: [
          SizedBox(height: 20,),
          ...folders.map((folder) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 33),
              padding: EdgeInsets.only(left: 30,bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Stack(
                children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 아이템을 세로축 왼쪽으로 정렬
                  children: [
                    SizedBox(height: 25,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          folder.folderName,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Bold',
                            color: Colors.grey[500],
                          ),
                        ),
                        //Text('    5'),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async{

                            fileSelector ??= FileSelector();
                            File? file = await fileSelector?.pickDocument(context);
                            if (file != null) {
                              String response = await quizViewModel.enrollFile(
                                  widget.roomkey, folder.folderKey,
                                  Provider.of<UserProfileViewModel>(context, listen: false).nickName,
                                  file);
                              print("$response");
                              if(response == 'already enroll'){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('폴더에 이미 문서가 등록되어 있습니다.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else if(response == 'ok') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('문서 등록이 완료되었습니다.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('파일을 선택해 주세요'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.white),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // 둥근 모서리를 만듦
                            ),
                          ),
                          child: Text(
                            '문서등록',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Bold',
                            ),
                          ),
                        ),
                        SizedBox(width: 30,),
                        OutlinedButton(
                          onPressed: () async {
                            List<String> users = await quizViewModel.getEnrollUserList(widget.roomkey, folder.folderKey);
                            if (users.isEmpty) {
                              // 사용자 목록이 비어 있을 경우 경고창 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('알림'),
                                    content: Text('문서를 먼저 등록해주세요.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // 경고창 닫기
                                        },
                                        child: Text('확인'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuizCreator(widget.myStudyInfo,
                                            folder.folderName, folder.folderKey)),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            elevation: 2,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.white),
                            // 테두리색을 배경색과 동일하게 함
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // 둥근 모서리를 만듦
                            ),
                          ),
                          child: Text(
                            '문제생성',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Bold',
                            ),
                          ),
                        ),
                        SizedBox(width: 30,),
                      ],
                    )
                  ],
                ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(
                        Icons.settings_rounded,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                      onPressed: () async{
                        String leader = await Provider.of<StudyViewModel>(context, listen: false).getLeader(widget.roomkey);
                        List<String> users = await quizViewModel.getEnrollUserList(widget.roomkey, folder.folderKey);
                        _showDocumentList(users,folder.folderKey,folder.folderName, quizViewModel, leader);
                      },
                    ),
                  ),
              ],
              ),
            );
          }).toList(),
        ],
      ) :  Center(child: Container( padding: EdgeInsets.only(top: 20), child: Text("폴더를 생성해주세요", style: TextStyle(fontSize: 17,fontFamily: 'Bold')))),
    );
  }
}
