import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../css/css.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'dart:math';

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
  int quizNum =0;
  Solve({super.key, required this.quizKey, required this.isSolved, required this.quizNum});

  @override
  State<Solve> createState() => _SolveState();
}

class _SolveState extends State<Solve> {
  final CardSwiperController controller = CardSwiperController(); // 컨트롤러

  List<ExampleCard> cards = [];
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

    WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
      //print("count");
      if(count == 0) {
        count ++;
        print("count: ${count}");
        quizViewModel.fetchQuiz(widget.quizKey);
        // 문제 목록을 위한 텍스트 필드 생성
        //_controllers = quizViewModel.quizQuestions;
      }
      for(int i=0;i<widget.quizNum;i++) {
        if(quizViewModel.quizQuestions[i].isSolved == widget.isSolved){
          candidates.add(
              ExampleCandidateModel(
                problem: quizViewModel.quizQuestions[i].question,
                answer: quizViewModel.quizQuestions[i].answer,
              )
          );
        }
      }
      cards = candidates.map(ExampleCard.new).toList();
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
                  // 문제 삭제
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
              '${idx}/${widget.quizNum}',
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
                    numberOfCardsDisplayed: 3,
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
                  FloatingActionButton(
                    // 뒤로가기
                    onPressed: controller.undo,
                    child: Container(
                      width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                          gradient: MainGradient(),
                        ),
                        child: const Icon(Icons.rotate_left)),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeLeft,

                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                          gradient: MainGradient(),
                        ),
                        child: const Icon(Icons.keyboard_arrow_left)),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeRight,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                          gradient: MainGradient(),
                        ),
                        child: const Icon(Icons.keyboard_arrow_right)),
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
      setState(() {
        idx = currentIndex + 1;
      });
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
      idx = currentIndex + 1;
    });
    return true;
  }
}

class ExampleCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

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
          candidate.problem,
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

class ExampleCandidateModel {
  String problem;
  String answer;

  ExampleCandidateModel({
    required this.problem,
    required this.answer,
  });
}

List<ExampleCandidateModel> candidates = [];
