/*
* 로그인 했을 때, 처음 뜨는 질문 목록 창
*
* */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../chat/chat.dart';
import '../css/css.dart';
import '../question/post_question.dart';
import 'dart:math';

import '../models/question_model.dart';
import '../view_model/question_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';

void main() {
  runApp(const Question());
}

class Question extends StatelessWidget {
  const Question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {

  int count =0;

  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return ChangeNotifierProvider(
        create: (_) => QaViewModel(),
        builder: (context, child) {

          final qaViewModel = Provider.of<QaViewModel>(context, listen: true);
          final myprofile = Provider.of<UserProfileViewModel>(context, listen: false);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (count == 0) {
                count++; // 여기서 1로 만들면 아래에서 로딩이 활성화됨.
              await qaViewModel.fetchQaList(myprofile.nickName);
            }
            print("heoo.");
          });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      width: width,
                      text: '  궁금한 게 생겼을 때 질문하세요!',
                      tStyle: 'ExtraBold',
                      tSize: 0.045,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PostQuestionPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          gradient: MainGradient(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '질문하기',
                          style: TextStyle(
                            fontFamily: 'ExtraBold',
                            color: Colors.white,
                            fontSize: width *0.04,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          body: (qaViewModel.isLoading == true || count == 0)
              ? Center(child: CircularProgressIndicator(),)
              : Container(
              color: Colors.grey[200],
              child: RefreshIndicator(
                  onRefresh: () async {
                    await qaViewModel.fetchQaList(myprofile.nickName);
                  },
                child: (qaViewModel.qaList.length == 0)
                    ? LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('현재 올라와있는 질문이 없습니다.',
                                style: TextStyle(
                                color: Color(0xFF3D6094),
                                fontFamily: 'Bold',
                                fontSize: 25,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: qaViewModel.qaList.length,
                  itemBuilder: (context, index) {
                    final qa = qaViewModel.qaList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == 14 ? 16.0 : 8.0,
                      ),
                      child: QuestionItem(index, qa),
                    );
                  }
                ),
              ),
            ),
        );
      }
    );
  }

}



class QuestionItem extends StatelessWidget {
  final int index;
  final QaBriefDto qa;
  const QuestionItem(this.index, this.qa, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return GestureDetector(
      onTap: () async{
        final qaViewModel = Provider.of<QaViewModel>(context, listen: false);
        final nickname = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
        if(await qaViewModel.isQaWatching(qa.qaKey)){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('다른 사용자가 이미 답변하고 있습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }else {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChatScreen(qaKey: qa.qaKey, forAns: true, course: qa.course,)),
          );
        }
        await qaViewModel.fetchQaList(nickname);
      },
      child: Container(
        margin: EdgeInsets.only( // 리스트 마진
          top: index == 0 ? 20 : 7,
          bottom: index == 14 ? 30 : 1,
          left: 30,
          right: 30,
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "  ${qa.type}  ",
                  style: TextStyle(
                    color: Color(0xFF3D6094),
                    fontFamily: 'Bold',
                    fontSize: 17,
                  ),
                ),
                Container(
                  width: width- 210,
                  child: Text(
                    qa.course,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Bold',
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${qa.point}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Bold',
                  ),
                ),
                SizedBox(width: 1), // 2000과 아이콘 사이의 간격
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
