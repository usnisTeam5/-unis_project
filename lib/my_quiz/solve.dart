import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/view_model/user_profile_info_view_model.dart';
import '../css/css.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'dart:math';

import '../models/quiz_model.dart';
import '../view_model/quiz_view_model.dart';
// void main() {
//   runApp(
//     MaterialApp(
//
//       debugShowCheckedModeBanner: false,
//       home: Solve(),
//     ),
//   );
// }

class Solve extends StatefulWidget {

  final int quizKey;
  final bool isSolved;
  int curNum =0;
  int quizNum =0;
  String course = '';
  Solve({super.key, required this.quizKey, required this.isSolved, required this.quizNum, required this.curNum, required this.course});

  @override
  State<Solve> createState() => _SolveState();
}

class _SolveState extends State<Solve> {
  final CardSwiperController controller = CardSwiperController(); // 컨트롤러
  List<QuizDto> candidates = []; // 후보군
  List<ExampleCard> cards = []; // 카드
  int idx = 1;
  int count = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: true);

    Future<void> store() async{

      for(int i=0;i<candidates.length;i++){
        //print("candidates[i].quizNum : ${candidates[i].quizNum}");
        if(candidates[i].quizNum < 10000){
          quizViewModel.quizQuestions[candidates[i].quizNum] = candidates[i];
        }
        else{
          //  print("candidates[i].quizNum : ${candidates[i].quizNum}");
          int index = candidates[i].quizNum - 10000;
          quizViewModel.quizQuestions[index] = candidates[i];
          //print("candidates[i].quizNum : ${candidates[i].quizNum}");
        }
       // print("quizQuestions${i} 진행완료?: ${quizViewModel.quizQuestions[candidates[i].quizNum].isSolved}");
      }

      await quizViewModel.updateQuiz(
        widget.quizKey,
        quizViewModel.quizQuestions,
      );

      // 저장 완료 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장이 완료되었습니다'),
          duration: Duration(seconds: 2),
        ),
      );

    }
    bool _done(){
      idx = idx + 1;
      print("Heool");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('저장 및 재시작'),
            content: Text('저장하고 나가시겠습니까?'),
            actions: <Widget>[
              TextButton(
                child: Text('저장하고 나가기'),
                onPressed: () async {
                  await store();
                  Navigator.pop(context); // Dialog 닫기
                  Navigator.pop(context); // 현재 화면 닫기 / 이전 화면으로 돌아가기
                },
              ),
            ],
          );
        },
      );
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
      //print("count");
      if(count == 0) {
        count ++;
        print("count: ${count}");
        await quizViewModel.fetchQuiz(widget.quizKey);
        // 문제 목록을 위한 텍스트 필드 생성
        //_controllers = quizViewModel.quizQuestions;
      for(int i=0;i<widget.quizNum;i++) {
        print("퀴즈 개수: $i");
        if(quizViewModel.quizQuestions[i].isSolved == widget.isSolved){
          candidates.add(quizViewModel.quizQuestions[i]);
          candidates.last.quizNum = i;
        }
      }
        cards = candidates.map(ExampleCard.new).toList();
        print("카드 길이 : ${cards.length}");
        if(cards.length == 0){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('경고'),
                content: Text('카드가 하나도 없습니다.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop(); // 경고창 닫기
                    },
                  ),
                ],
              );
            },
          );
          Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        // kToolbarHeight는 기본 AppBar 높이, 20은 추가 패딩 값
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20), // 상단에만 패딩 추가
          decoration: BoxDecoration(
            gradient: MainGradient(),
          ),
          child: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context); // 현재 스크린을 닫고 이전 스크린으로 돌아가기
              },
              child: Container(
                padding: EdgeInsets.all(8.0), // 탭하기 쉽도록 충분한 패딩 제공
                decoration: BoxDecoration(
                  // 추가적인 스타일링이 필요하다면 여기에 데코레이션 추가
                  color: Colors.transparent, // 터치 피드백을 위한 배경색 설정 (옵션)
                  shape: BoxShape.circle, // 원형으로 클릭 영역을 제한 (옵션)
                ),
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              // `actions` 속성을 사용하여 IconButton을 추가합니다.
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 30,
                ),
                color: Colors.white,
                onPressed: () {
                  controller.swipeTop();
                  print("idx : $idx");
                  candidates[idx-1].quizNum += 10000;
                  //여기 만들어야함
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
            // AppBar 배경을 투명하게 설정
            automaticallyImplyLeading: false,
            centerTitle: true,
            // Title을 중앙에 배치
            title: Text(
              '${idx}/${widget.curNum}',
              style: TextStyle(color: Colors.white, fontSize: width * 0.06),
            ),
          ),
        ),
      ),
      body: (quizViewModel.isLoading || count == 0)
          ?  Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Container(
                color: Colors.grey[200],
                child: CardSwiper(
                    allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                        horizontal: true, vertical: false),
                    controller: controller,
                    cardsCount: cards.length,
                    onSwipe: _onSwipe,
                    onUndo: _onUndo,
                    onEnd: _done,
                    isLoop: false,
                    numberOfCardsDisplayed: (candidates.length <=2) ? candidates.length : 3,
                    backCardOffset: const Offset(25, 10),
                    padding: const EdgeInsets.all(40.0),
                    cardBuilder: (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                    ) {
                      return cards[index]; // cards[index] 를 반환.
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    // 뒤로가기
                    onPressed: (){
                      controller.undo();
                      print("idx : $idx, 문제: ${candidates[idx-1].question}");
                      candidates[idx-1].isSolved = widget.isSolved;
                      if(candidates[idx-1].quizNum > 1000) candidates[idx-1].quizNum - 1000;
                    },
                    child: Container(
                      width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                          gradient: MainGradient(),
                        ),
                        child: const Icon(Icons.rotate_left,color: Colors.white,),
                    ),
                  ),
                  TextButton( // 저장
                    onPressed: () async{
                      await store();
                      },
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                          gradient: MainGradient(),
                        ),
                        child: Center(child: const Text("저장", style: TextStyle(fontFamily: 'Bold',color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {

    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    if (currentIndex != null) {
      if(direction == CardSwiperDirection.right){
        candidates[idx-1].isSolved = true;
      } else if(direction == CardSwiperDirection.left){
        candidates[idx-1].isSolved = false;
      }
      setState(() {
       // if(idx != widget.curNum) {
          idx = idx + 1;
       // }
      });
    }else{
      if(direction == CardSwiperDirection.right){
        candidates[idx-1].isSolved = true;
      } else if(direction == CardSwiperDirection.left){
        candidates[idx-1].isSolved = false;
      }
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    setState(() {
      idx = idx - 1;
    });
    return true;
  }
}

class ExampleCard extends StatelessWidget {
  final QuizDto candidate;

  const ExampleCard(
    this.candidate, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final con1 = FlipCardController();
    // Flip the card programmatically
    //controller.flipcard();

    return FlipCard(
      animationDuration: Duration(milliseconds: 200),
      rotateSide: RotateSide.right,
      onTapFlipping: true,
      //When enabled, the card will flip automatically when touched.
      axis: FlipAxis.vertical,
      controller: con1,
      frontWidget: Container(
        // 앞면
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          candidate.question,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backWidget:
      Container(
        // 뒷면
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          candidate.answer,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
