/**
 * 학과 검색
 */
import 'package:flutter/material.dart';
import '../css/css.dart';
import '../profile/other_profile.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../view_model/department_search_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Round',
      ),
      home: SearchDepartment(),
    );
  }
}

class SearchDepartment extends StatefulWidget {
  @override
  _SearchDepartmentState createState() => _SearchDepartmentState();
}

class _SearchDepartmentState extends State<SearchDepartment> {
  TextEditingController _searchController = TextEditingController();

  int selectedDepartmentIndex = -2;

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery
        .of(context)
        .size
        .width, 500.0);
    double tabBarHeight = MediaQuery
        .of(context)
        .size
        .height * 0.08;

    return ChangeNotifierProvider(
      create: (_) => DepartmentSearchViewModel(),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 여기에 빌드가 완료된 후에 실행하고 싶은 코드를 넣으세요.
          if (_searchController.text == '' && selectedDepartmentIndex == -2) {
            Provider.of<DepartmentSearchViewModel>(context, listen: false)
                .searchDepartment('');
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
                  // Consumer<DepartmentSearchViewModel>를 사용하여 선택된 학과 이름 가져오기
                  String? selectedDepartment = selectedDepartmentIndex != -1
                      ? Provider
                      .of<DepartmentSearchViewModel>(context,
                      listen: false)
                      .departments[selectedDepartmentIndex]
                      : null;

                  if (selectedDepartment != null) {
                    print('선택된 학과: $selectedDepartment');
                    Navigator.pop(context, selectedDepartment);
                  }
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            // centerTitle: true,
            // Title을 중앙에 배치
            title: GradientText(
                width: width, text: '학과 선택', tSize: 0.06, tStyle: 'Bold'),
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
                      Provider.of<DepartmentSearchViewModel>(context,
                          listen: false)
                          .searchDepartment(text);
                      setState(() {
                        selectedDepartmentIndex = -1;
                      });
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
              Consumer<DepartmentSearchViewModel>(
                builder: (context, viewModel, child) {
                  // 만약 뷰모델이 로딩 중이라면 로딩 인디케이터를 보여줍니다.
                  if (viewModel.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  // 검색 결과에 따라 ListView를 업데이트합니다.
                  final departments = viewModel.departments; // 뷰모델의 학과 목록
                  // 검색 결과가 없으면 사용자에게 알립니다.
                  if (departments.isEmpty) {
                    return Center(child: Text('검색 결과가 없습니다.'));
                  }

                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: departments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 3.0),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.0), // 회색 테두리 추가
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // 체크박스를 오른쪽으로 이동시킵니다.
                              children: [
                                Text(
                                  "      ${departments[index]}",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontFamily: 'Round',
                                      fontSize: 15),
                                ),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Radio(
                                    value: index,
                                    groupValue: selectedDepartmentIndex,
                                    onChanged: (int? value) {
                                      setState(() {
                                         selectedDepartmentIndex = value!;
                                      });
                                    },
                                    activeColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
