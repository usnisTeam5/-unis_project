import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/question/post_settings.dart';
import 'package:unis_project/css/css.dart';
import 'dart:math';
import 'package:unis_project/chat/myQHistoryChat.dart';
import 'package:unis_project/view_model/my_qna_view_model.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';

import '../models/my_qna_model.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);
    return MaterialApp(

      theme: ThemeData(
        fontFamily: 'Round', // 글꼴 테마 설정
      ),
      home: MyQHistory(selectedIndex: 0,),
    );
  }
}

class MyQHistory extends StatefulWidget {
  final int selectedIndex;

  const MyQHistory({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _QuestionAnswerScreenState createState() => _QuestionAnswerScreenState();
}


class _QuestionAnswerScreenState extends State<MyQHistory> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int _selectedIndex = 0;  // Add this line
  int _selectedInext2 = 0;
  List<QaListDto> qaList = [];
  int count =0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.selectedIndex);
    _tabController?.addListener(() {
      if (_tabController?.indexIsChanging ?? false) {
        setState(() {
          _selectedIndex = _tabController?.index ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  Future<void> _fetchData(MyQnAViewModel viewModel, String nickname) async {
    if (_selectedIndex == 0) {
      await viewModel.fetchAskList(nickname);
      qaList = viewModel.askList;
    } else {
      await viewModel.fetchAnswerList(nickname);
      qaList = viewModel.answerList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;
    final String nickname = Provider.of<UserProfileViewModel>(context,listen: false).nickName;

    return  ChangeNotifierProvider(
        create: (_) => MyQnAViewModel(),
        builder: (context, child) {

          final listViewModel = Provider.of<MyQnAViewModel>(context, listen:true);


          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if( _selectedInext2 != _selectedIndex || count == 0 ) {
              count =1;
              _selectedInext2 = _selectedIndex;
              _fetchData(listViewModel, nickname);
            }
          });

          return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,  // Title을 중앙에 배치
            title: GradientText(width: width, text: '내 문답', tSize: 0.06, tStyle: 'Bold'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
              child: Container(
                decoration: BoxDecoration(
                  gradient: MainGradient(),
                ),
                height: 2.0,  // Set the thickness of the underline
              ),
            ),
          ),
          body : Column(
            children: [
              PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          //top: BorderSide(color: Colors.transparent),  // Or use MainGradient here
                          bottom: BorderSide(color: Colors.transparent,width: 2.0),  // Or use MainGradient here
                        ),
                        gradient: MainGradient(),
                      ),
                      child: Material(
                        color: Colors.white,  // TabBar의 배경색을 흰색으로 설정
                        child: TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(
                              icon: _selectedIndex == 1 ?
                                    GradientText( width: width, text: '질문 목록 >', tSize: 0.05, tStyle: 'Bold',)  // Adjust the size as neededtStyle: 'Bold'  // Adjust the style as needed
                                    : Text('질문 목록 >', style: TextStyle(color: Colors.white, fontFamily: 'Bold', fontSize: width * 0.05))
                            ),
                            Tab(
                              icon: _selectedIndex == 0 ?
                              GradientText(
                                  width: width,
                                  text: '답변 목록 >',
                                  tSize: 0.05,  // Adjust the size as needed
                                  tStyle: 'Bold'  // Adjust the style as needed
                              )
                              : Text('답변 목록 >', style: TextStyle(color: Colors.white, fontFamily: 'Bold', fontSize: width * 0.05))
                            ),
                          ],
                          indicator: BoxDecoration(
                            gradient: MainGradient(),
                          ),
                          labelColor: Colors.white,  // 선택된 탭의 레이블 색상을 변경합니다.
                          //unselectedLabelColor: Colors.grey,  // 선택되지 않은 탭의 레이블 색상을 변경합니다.
                        ),
                      ),
                  ),
              ),
              (listViewModel.isLoading == true || count == 0 || _selectedIndex != _selectedInext2)
              ? Center(
                 child: CircularProgressIndicator(),
              )
              : Expanded(  // <--- 이 줄을 추가
                    child: buildListView(),
              ),
            ],
          ),
        );
      }
    );
  }

  ListView buildListView() {
    print("buildListView: $qaList");
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: qaList.length,
      itemBuilder: (context, index) {
        final QaListDto qa = qaList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyQHistoryChatScreen()),
            );
          },

          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),  // Add this line for a light grey border
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${qa.type} ',
                        style: TextStyle(color: Color(0xFF3D6094), fontSize: 16 , fontFamily: 'Bold'),
                      ),
                      TextSpan(
                        text: qa.course,
                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Round'),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: ShapeDecoration(
                    color: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Text(
                    qa.status,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Bold'),
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}
