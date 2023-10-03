// file_selector.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileSelector {
  Future<void> pickDocument(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file: ${file.name}')),
        );
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
