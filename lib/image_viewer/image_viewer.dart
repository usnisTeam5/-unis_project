import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../css/css.dart';

class PhotoView extends StatefulWidget {
  final Uint8List photoData;

  PhotoView({Key? key, required this.photoData}) : super(key: key);


  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);  // 로그인 화면으로 되돌아가기
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,  // Title을 중앙에 배치
        title: GradientText(width: screenWidth, text: '사진', tSize: 0.06, tStyle: 'Bold'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
          child: Container(
            decoration: BoxDecoration(
              gradient: MainGradient(),
            ),
            height: 2.0,  // Set the thickness of the undedsrline
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: InteractiveViewer(
          panEnabled: true, // Set it to false to prevent panning.
          boundaryMargin: EdgeInsets.all(0),
          minScale: 0.5,
          maxScale: 4,
          child: Image.memory(
            widget.photoData,
            fit: BoxFit.contain, // This will fill the width of the screen.
          ),
        ),
      ),
    );
  }
}
