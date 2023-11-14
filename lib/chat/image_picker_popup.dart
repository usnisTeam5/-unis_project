import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPopup extends StatelessWidget {
  final Function(XFile?) onImagePicked;

  ImagePickerPopup({required this.onImagePicked});

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    Navigator.pop(context); // Close the bottom sheet
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(pickedFile);
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
