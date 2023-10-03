import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../css/css.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

void main() {
  runApp(
    const MaterialApp(
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),  // kToolbarHeight는 기본 AppBar 높이, 20은 추가 패딩 값
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),  // 상단에만 패딩 추가
          decoration: BoxDecoration(
            gradient: MainGradient(),
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close, size: 30,),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);  // 로그인 화면으로 되돌아가기
              },
            ),
            actions: [  // `actions` 속성을 사용하여 IconButton을 추가합니다.
              IconButton(
                icon: Icon(Icons.delete, size: 30,),
                color: Colors.white,
                onPressed: () {
                  //Navigator.pop(context);  // 로그인 화면으로 되돌아가기
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,  // AppBar 배경을 투명하게 설정
            automaticallyImplyLeading: false,
            centerTitle: true,  // Title을 중앙에 배치
            title: Text(
              '2/10',
              style: TextStyle(color: Colors.white, fontSize: width * 0.06),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                allowedSwipeDirection : AllowedSwipeDirection.symmetric(horizontal: true, vertical: false),
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(30, 20),
                padding: const EdgeInsets.all(40.0),
                cardBuilder: (
                    context,
                    index,
                    horizontalThresholdPercentage,
                    verticalThresholdPercentage,
                    ) =>
                cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton( // 뒤로가기
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipe,
                    child: const Icon(Icons.rotate_right),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeLeft,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeRight,
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeTop,
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeBottom,
                    child: const Icon(Icons.keyboard_arrow_down),
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
    return true;
  }
}

class ExampleCandidateModel {
  String name;
  String job;
  String city;
  List<Color> color;

  ExampleCandidateModel({
    required this.name,
    required this.job,
    required this.city,
    required this.color,
  });
}

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'One, 1',
    job: 'Developer',
    city: 'Areado',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
  ),
  ExampleCandidateModel(
    name: 'Two, 2',
    job: 'Manager',
    city: 'New York',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
  ),
  ExampleCandidateModel(
    name: 'Three, 3',
    job: 'Engineer',
    city: 'London',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
  ),
  ExampleCandidateModel(
    name: 'Four, 4',
    job: 'Designer',
    city: 'Tokyo',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
  ),
];

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
        onTapFlipping: true, //When enabled, the card will flip automatically when touched.
        axis: FlipAxis.vertical,
        controller: con1,
        frontWidget: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: candidate.color,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      candidate.job,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      candidate.city,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        backWidget: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: candidate.color,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      candidate.job,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      candidate.city,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );
    // return Container(
    //   clipBehavior: Clip.antiAlias,
    //   decoration: BoxDecoration(
    //     borderRadius: const BorderRadius.all(Radius.circular(40)),
    //     color: Colors.white,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withOpacity(0.2),
    //         spreadRadius: 3,
    //         blurRadius: 7,
    //         offset: const Offset(0, 3),
    //       )
    //     ],
    //   ),
    //   alignment: Alignment.center,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Flexible(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               begin: Alignment.topCenter,
    //               end: Alignment.bottomCenter,
    //               colors: candidate.color,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               candidate.name,
    //               style: const TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 20,
    //               ),
    //             ),
    //             const SizedBox(height: 5),
    //             Text(
    //               candidate.job,
    //               style: const TextStyle(
    //                 color: Colors.grey,
    //                 fontSize: 15,
    //               ),
    //             ),
    //             const SizedBox(height: 5),
    //             Text(
    //               candidate.city,
    //               style: const TextStyle(color: Colors.grey),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}