/**
 * 선택한 과목중에서 찾아서 반환하는 메소드 과목 검색 x
 */
import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';
import 'dart:math';
import '../view_model/subject_search_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: SearchSubject(),
    );
  }
}

class SearchSubject extends StatefulWidget {
  @override
  _SearchSubjectState createState() => _SearchSubjectState();
}

class _SearchSubjectState extends State<SearchSubject> {
  TextEditingController _searchController = TextEditingController();
  List<bool> selectedSubjectsChecklist = []; // 체크박스의 상태를 관리하기 위한 리스트

  List<String> selectedSubjects = [];
  bool _isCallbackExecuted = false; // Declare this flag in your state class.

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, 500.0);
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => SubjectSearchViewModel(),
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_searchController.text == '' && !_isCallbackExecuted) {
            Provider.of<SubjectSearchViewModel>(context, listen: false)
                .searchSubject('');
            _isCallbackExecuted = true;
          }
        });
        // No longer throws
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
                icon: Icon(
                  Icons.check,
                  size: 30,
                ),
                color: Colors.grey,
                onPressed: () {
                  print('선택된 주제: ${selectedSubjects.toString()}');
                  Navigator.pop(context, selectedSubjects);
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            // centerTitle: true,
            // Title을 중앙에 배치
            title: GradientText(
                width: width, text: '과목 선택', tSize: 0.06, tStyle: 'Bold'),
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
          body: // ListView를 Expanded 위젯으로 감싸서 남은 공간을 모두 차지하게 합니다.
              Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (text) {
                      Provider.of<SubjectSearchViewModel>(context,
                              listen: false)
                          .searchSubject(text);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: width * 0.04),
                      // 위쪽 패딩 추가
                      suffixIcon: Icon(Icons.search),
                    ),
                    style: TextStyle(
                      fontFamily: 'Round',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: width * 0.04,
                    ),
                  )),
              Consumer<SubjectSearchViewModel>(
                  builder: (context, viewModel, child) {
                // 만약 뷰모델이 로딩 중이라면 로딩 인디케이터를 보여줍니다.
                if (viewModel.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                // 검색 결과에 따라 ListView를 업데이트합니다.
                final subjects = viewModel.subjects; // 뷰모델의 학과 목록
                // 검색 결과가 없으면 사용자에게 알립니다.
                if (selectedSubjectsChecklist.length != subjects.length) {
                  // subjects 리스트 길이만큼 selectedSubjectsChecklist를 초기화합니다.
                  selectedSubjectsChecklist =
                      List<bool>.filled(subjects.length, false);
                }

                if (subjects.isEmpty) {
                  return Center(child: Text('검색 결과가 없습니다.'));
                }
                //print("Hellooooo");
                //print('Subjects: $subjects');
                return Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 3.0),
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, right: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.0), // 회색 테두리 추가
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 체크박스를 오른쪽으로 이동시킵니다.
                              children: [
                                Text(
                                  subjects[index].length > 22
                                      ? "      " +
                                          subjects[index].substring(0, 18) +
                                          '...'
                                      : "      ${subjects[index]}",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontFamily: 'Round',
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                          width: 1.0, color: Colors.grey[300]!),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    value: selectedSubjectsChecklist[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedSubjectsChecklist[index] =
                                            value!;
                                        if (value) {
                                          selectedSubjects.add(subjects[index]);
                                        } else {
                                          selectedSubjects
                                              .remove(subjects[index]);
                                        }
                                      });
                                      print(
                                          '선택된 주제: ${selectedSubjects.toString()}');
                                    },
                                    activeColor: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
