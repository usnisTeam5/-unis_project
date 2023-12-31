import 'package:flutter/material.dart';


/*
위의 모델을 가지고 플러터 provider 뷰 모델을 작성해줘
isLoading이 들어가야해
적절한 주석을 넣어야해
모든 코드 생략하지말고 하나의 파일에 담아서 전부 작성해줘
 */
/*
이 API를 보고 플러터 모델을 짜면 돼.
../url.dart 파일에 BASE_URL을 가져와서 작성하면 돼!
pram 어떻게 넘기는지에 대해 주의하고
jsonDecode(utf8.decode(response.bodyBytes)); 이런식으로 디코드해야해!
모든 코드 생략하지말고 하나의 파일에 담아서 전부 작성해줘
print(response.body);를 넣어줘
적절한 주석을 넣어줘
*/
//*********************************************************************
 // File('image/unis.png').readAsBytesSync(),
//   final bytes = base64Decode(data['profileImage']); // base64 디코드.
//
//           data['profileImage'] = bytes; // byte로 저장.
//         } else{
//           data['profileImage'] = File('image/unis.png').readAsBytesSync();
// 위에는 모델 ****************************************************************
//Uint8List? _image; //이미지를 담을 변수 선언
//  child: CircleAvatar(
//                   radius: 50.0,
//                   backgroundImage: MemoryImage(_image!),
//                 ),
// 뷰~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



//WidgetsBinding.instance.addPostFrameCallback((_) { // 나중에 호출됨.
//             // context를 사용하여 UserProfileViewModel에 접근
//             final nickName = Provider.of<UserProfileViewModel>(context, listen: false).nickName;
//             // 다른 비동기 작업 실행
//             Provider.of<UserProfileOtherViewModel>(context, listen: false)
//                 .fetchUserProfile(nickName, "별뚜기");
//           });

//
//                 (chatModel.isLoading == true || count == 0)
//               ? Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container(
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     OthersProfileInfoSection(),
//                     StatsSection(),
//                     SatisfactionAndReportSection(),
//                   ],
//                 ),
//               );
//             },
//           ),



// body: ChangeNotifierProvider(
//         create: (_) => OneToOneChatViewModel(),
//           builder: (context, child) {
// cntl + alt + L 자동정렬 , cntl + shift + F 모두찾기 , F 대신 R -> 모두바꾸기
// final responseData = jsonDecode(utf8.decode(response.bodyBytes)); 이렇게 해야 안깨짐 한글.

// 비밀번호 8! 20자 , 닉네임 10자 이하.
// APPBAR 글씨 bold, 크기 width * 0.6
//GradientText(width: width, text: '내 문답', tSize: 0.06, tStyle: 'Bold'), 참고하세요
//  GradientText(width: width, tSize: 0.15, text:'유니스', tStyle: 'ExtraBold' ),
//Text('답변 목록 >', style: TextStyle(color: Colors.white, fontFamily: 'Bold', fontSize: width * 0.05))
//color: Color(0xFF3D6094) 내 문답에서 질문 or 조언 글씨 색깔

//final width = min(MediaQuery.of(context).size.width,500.0);
//final height = min(MediaQuery.of(context).size.height,700.0);

// 18자 넘어가면 ... 처리
// Text( // 18자 넘어가면 ... 처리
//   subject!.length > 18 ? subject!.substring(0, 18) + '...' : subject!,
//   style: TextStyle(
//   color: Colors.grey[900],
//   fontFamily: 'Bold',
//   fontSize: width * 0.04
//   ),
// ),

// SingleChildScrollView(
// child: Container( // container 대신 padding 으로 해도 오류 안남.
// height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
// 침범하는거 막을 때 이렇게 쓰면 딱 맞음

// final result = await Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => SubjectSelector()),
// ); 콜백함수

// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => MyHomePage()),
// );

//import 'package:intl/intl.dart'; 숫자 표기법 1,000,000 같은 것 처리
// String formatNumber(int number) {
//   final formatter = NumberFormat('#,###');
//   return formatter.format(number);
// }


// consumer 등록 context 접근이 힘들 때
// 접근이 되면( ex) 내부 위젯을 메소드로 떼어낼 때, 그냥 context넘겨 받음
/*
*  Consumer<MyDataModel>(
                builder: (context, dataModel, child) {
                  return Text(
                    '카운트: ${dataModel.count}',
                    style: TextStyle(fontSize: 24),
                  );
                },
              ),
              *
    context.read<CounterModel>().increment(); -> 주의점. builder 내, 위젯 밖에서 사용 x 위젯 안에서 써야함.
    * context.watch<CounterModel>().count
    *
    * import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class CounterModel with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Counter App'),
        ),
        body: ChangeNotifierProvider( // *******************이런식으로 등록 가능********
          create: (context) => CounterModel(), // 데이터 모델 등록
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '카운트: ${context.watch<CounterModel>().count}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterModel>().increment();
                  },
                  child: Text('증가'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
이런식으로도 추가 가능
* */


// final List<String> subjects = [
//   '컴퓨터와 휴먼',
//   '인공지능과 윤리',
//   '빅데이터 분석',
//   '휴먼인터페이스미디어와 마법의 돌과 죄수',
//   '컴퓨터와 휴먼',
//   '인공지능과 윤리',
//   '빅데이터 분석',
//   '휴먼인터페이스미디어와 마법의 돌과 죄수',
//   '컴퓨터와 휴먼',
//   '인공지능과 윤리',
//   '빅데이터 분석',
//   '휴먼인터페이스미디어',
// ];

class GradientText extends StatelessWidget {
  const GradientText({
    super.key,
    required this.width,
    required this.text,
    required this.tStyle,
    required this.tSize,
  });

  final double width;
  final text;
  final double tSize;
  final tStyle;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFF59D9D5), Color(0xFF2A7CC1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,  // This color will be ignored since we've applied shader
          fontFamily: tStyle,
          fontSize: width * tSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class GradientText2 extends StatelessWidget {
  const GradientText2({
    super.key,
    required this.width,
    required this.text,
    required this.tStyle,
    required this.tSize,
  });

  final double width;
  final text;
  final double tSize;
  final tStyle;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFF59D9D5), Color(0xFF2A7CC1)],
        begin: Alignment.topLeft,
        end: Alignment.topCenter,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,  // This color will be ignored since we've applied shader
          fontFamily: tStyle,
          fontSize: width * tSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class MainGradient extends LinearGradient {
  MainGradient()
      : super(
    colors: [Color(0xFF59D9D5), Color(0xFF2A7CC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class GradientIcon extends StatelessWidget {
  final IconData iconData;

  const GradientIcon({super.key,
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
      colors: [Color(0xFF59D9D5), Color(0xFF2A7CC1)],
      begin: Alignment.topLeft,
      end: Alignment.topCenter,
      ).createShader(bounds),
      child: Icon(
        iconData,
      ),
    );
  }
}
