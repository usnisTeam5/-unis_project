import 'package:flutter/material.dart';

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
// child: Container(
// height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
// 침범하는거 막을 때 이렇게 쓰면 딱 맞음
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
