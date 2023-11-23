/*
이미지 사이즈를 줄인다.
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unis_project/chat/image_resizing.dart';

class ImageResizing extends StatefulWidget {
  @override
  _ImageResizingState createState() => _ImageResizingState();
}

class _ImageResizingState extends State<ImageResizing> {
  final ImagePicker _picker = ImagePicker();
  String? _compressedImagePath;

  Future<void> _getImageAndCompress() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Compress the image
      final filePath = imageFile.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outPath,
        quality: 88,
      );

      setState(() {
        _compressedImagePath = compressedImage?.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Compress Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getImageAndCompress,
              child: Text('Pick and Compress Image'),
            ),
            if (_compressedImagePath != null)
              Image.file(
                File(_compressedImagePath!),
                width: 150,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
