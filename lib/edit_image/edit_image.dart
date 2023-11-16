// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// import 'package:file_picker/file_picker.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   List<String> _pictures = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {}
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     onPressed: onPressed, child: const Text("Add Pictures")),
//                 for (var picture in _pictures) Image.file(File(picture))
//               ],
//             )),
//       ),
//     );
//   }
//
//   void onPressed() async {
//     List<String> pictures;
//     try {
//       pictures = await CunningDocumentScanner.getPictures(true) ?? [];
//       if (!mounted) return;
//       setState(() {
//         _pictures = pictures;
//       });
//     } catch (exception) {
//       // Handle exception here
//     }
//   }
//
//   Future<void> cropImage() async { // 얘는 작동 안함;
//     try {
//       // Using FilePicker to select an image file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
//
//       if (result != null) {
//         String filePath = result.files.single.path!; // Getting the file path
//
//         // Calling the cropPictureFromFile method
//         String? croppedImagePath = await CunningDocumentScanner.cropPictureFromFile(filePath);
//
//         if (croppedImagePath != null) {
//           // Use the cropped image as needed
//           print("Cropped image path: $croppedImagePath");
//         }
//       } else {
//         // User canceled the picker
//         print("No file selected.");
//       }
//     } catch (e) {
//       // Handle any errors here
//       print("Error cropping image: $e");
//     }
//   }
// }