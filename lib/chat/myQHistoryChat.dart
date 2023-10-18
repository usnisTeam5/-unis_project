import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);
    return MaterialApp(
      home: MyQHistoryChatPage(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class MyQHistoryChatPage extends StatefulWidget {
  @override
  _MyQHistoryChatPageState createState() => _MyQHistoryChatPageState();
}

class _MyQHistoryChatPageState extends State<MyQHistoryChatPage> {
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, 500.0);
    final height = min(MediaQuery.of(context).size.height, 700.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '과목명',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Bold',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.grey,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
      ),
    );
  }
}

class Message {
  final String? text;
  final String? imagePath;
  final String sender;
  final bool isMine;
  final String senderImageURL;
  final String senderName;
  final DateTime sentAt;

  Message({
    this.text,
    this.imagePath,
    required this.sender,
    required this.isMine,
    required this.senderImageURL,
    required this.senderName,
    required this.sentAt,
  });
}
