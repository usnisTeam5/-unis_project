import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../css/css.dart';
import '../file_selector/file_selector.dart';
import '../view_model/study_quiz_view_model.dart';
import 'quiz_creator.dart';
import 'dart:math';
import 'package:flutter/services.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Bold',
      ),
      home: QuizFolderScreen(),
    );
  }
}

class QuizFolderScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizFolderScreen> {
  // 과목 목록
  final FileSelector fileSelector = FileSelector();
  final List<String> folders = [
    '1강',
    '2강',
    '3강',
    '4강',
  ];

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
        create: (_) => StudyQuizViewModel(),
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
                              onPressed: () {
                                Navigator.of(context).pop(_controller.text);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (folderName != null && folderName.isNotEmpty) {
                      setState(() {
                        folders.add(folderName);
                      });
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
          body: FoldersScreen(folders: folders, fileSelector: fileSelector),
        );
      }
    );
  }
}
class FoldersScreen extends StatefulWidget {
  FoldersScreen({
    Key? key,
    required this.folders,
    required this.fileSelector,
  }) : super(key: key);

  final List<String> folders;
  final FileSelector fileSelector;

  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {

  final Map<String, List<String>> folderDocuments = {
    '1강': ['문서1', '문서2'],
    '2강': ['문서3'],
    '3강': [],
    '4강': ['문서4', '문서5', '문서6'],
  };
  void _showDocumentList(BuildContext context, String folder) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$folder 문서 목록'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: folderDocuments[folder]?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(folderDocuments[folder]![index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        folderDocuments[folder]!.removeAt(index);
                      });
                      Navigator.of(context).pop();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          ...widget.folders.map((folder) {
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
                          folder,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Bold',
                            color: Colors.grey[500],
                          ),
                        ),
                        Text('    5'),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            widget.fileSelector.pickDocument(context);
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
                          onPressed: () {
                            // '문서생성' 버튼 클릭 시의 동작
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizCreator()),
                            );
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
                      onPressed: () {
                        _showDocumentList(context, folder);
                      },
                    ),
                  ),
              ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
