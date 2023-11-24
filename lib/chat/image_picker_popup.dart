/*
이미지 선택
 */
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

Future<File> compressImage(File file) async {
  final filePath = file.absolute.path;

  // 새 파일 경로 생성 (원본 파일명 뒤에 _compressed 추가)
  final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jpg'));
  final splitted = filePath.substring(0, lastIndex);
  final outPath = "${splitted}_compressed${filePath.substring(lastIndex)}";

  // 이미지 압축
  var result = await FlutterImageCompress.compressAndGetFile(
    filePath,
    outPath,
    quality: 88, // 품질 설정 (0-100)
    // 원하는 크기로 조절
    minWidth: 1000,
    minHeight: 1000,
  );

  return result!;
}

class ImagePickerPopup extends StatelessWidget {
  final Function(File?) onImagePicked; // XFile 받음

  ImagePickerPopup({required this.onImagePicked});

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    Navigator.pop(context); // Close the bottom sheet
    final pickedFile = await ImagePicker().pickImage(source: source); // 파일을 받아옴
    if (pickedFile != null) {
      File originalImage = File(pickedFile.path);
      String extension = pickedFile.path.split('.').last.toLowerCase();

      // 확장자가 jpg 또는 jpeg인 경우에만 이미지 압축
      // if (extension == 'jpg' || extension == 'jpeg') {
      //   File compressedImage = await compressImage(originalImage);
      //   onImagePicked(compressedImage);
      // } else {
      //   // 그렇지 않은 경우 원본 이미지 사용
        onImagePicked(originalImage);
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.photo_library),
          title: Text('앨범 선택'),
          onTap: () => _pickImage(ImageSource.gallery, context),
        ),
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('사진 찍기'),
          onTap: () => _pickImage(ImageSource.camera, context),
        ),
      ],
    );
  }
}
