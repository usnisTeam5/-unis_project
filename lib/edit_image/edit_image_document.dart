// import 'dart:io';
//
// import 'package:document_scanner_flutter/configs/configs.dart';
// import 'package:document_scanner_flutter/document_scanner_flutter.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   File? _scannedImage;
//
//   openImageScanner(BuildContext context) async {
//     var image = await DocumentScannerFlutter.launch(context,
//         source: ScannerFileSource.CAMERA,
//         labelsConfig: {
//           ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
//           ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
//         });
//     if (image != null) {
//       _scannedImage = image;
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Document Scanner Demo'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (_scannedImage != null)
//               Image.file(_scannedImage!,
//                   width: 300, height: 300, fit: BoxFit.contain),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(_scannedImage?.path ?? ''),
//             ),
//             Center(
//               child: Builder(builder: (context) {
//                 return ElevatedButton(
//                     onPressed: () => openImageScanner(context),
//                     child: Text("Image Scan"));
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
