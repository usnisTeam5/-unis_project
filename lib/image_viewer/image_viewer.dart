import 'dart:typed_data';
import 'package:flutter/material.dart';

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
        title: Text('Photo Viewer'),
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
