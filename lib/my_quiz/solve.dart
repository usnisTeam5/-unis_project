import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../css/css.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'dart:math';
void main() {
  runApp(
    MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Solve(),
    ),
  );
}

class Solve extends StatefulWidget {
  const Solve({
    Key? key,
  }) : super(key: key);

  @override
  State<Solve> createState() => _SolveState();
}

class _SolveState extends State<Solve> {
  final CardSwiperController controller = CardSwiperController(); // 컨트롤러

  final cards = candidates.map(ExampleCard.new).toList();
  int idx = 1;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  width = min(MediaQuery.of(context).size.width,500.0);
    final height = MediaQuery.of(context).size.height;

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
            leading: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context); // 로그인 화면으로 되돌아가기
              },
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
              '${idx}/${candidates.length}',
              style: TextStyle(color: Colors.white, fontSize: width * 0.06),
            ),
          ),
        ),
      ),
      body: SafeArea(
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
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeLeft,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeRight,
                    child: const Icon(Icons.keyboard_arrow_right),
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

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
      problem: 'determinant의 기하학적 의미1', answer: '선형 변환에서의 넓이1'),
  ExampleCandidateModel(
      problem: 'determinant의 기하학적 의미2', answer: '선형 변환에서의 넓이2'),
  ExampleCandidateModel(
      problem: 'determinant의 기하학적 의미3', answer: '선형 변환에서의 넓이3'),
  ExampleCandidateModel(
      problem: 'determinant의 기하학적 의미4', answer: '선형 변환에서의 넓이4'),
];
