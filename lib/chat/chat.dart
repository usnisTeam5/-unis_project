import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ChatScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Round'),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  bool _isMine = false;
  DateTime _time = DateTime.now().add(Duration(minutes: 20));

  Future<void> _sendMessage(String message) async {
  //   // final response = await http.post(
  //   //   Uri.parse('https://your-backend-url.com/send-message'),
  //   //   body: {'message': message},
  //   // );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //   }
  }

   Future<void> _fetchMessages() async {
  //   // final response = await http.get(
  //   //   Uri.parse('https://your-backend-url.com/fetch-messages'),
  //   // );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       _messages = List<String>.from(data['messages']);
  //     });
  //   }
   }

  @override
  // void initState() {
  //   super.initState();
  //
  //   Future.doWhile(() async {
  //     await Future.delayed(Duration(seconds: 5));
  //     await _fetchMessages();
  //     return true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('포기하기', style: TextStyle(color: Colors.black, fontSize: 10)),
        ),
        title: Center(
          child: Text(
            '과목명',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _messages.add(_messageController.text);
                _isMine = !_isMine;
                _sendMessage(_messageController.text);
                _messageController.clear();
              });
            },
            child: Text('답변하기', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Countdown(
                  endTime: _time,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment:
                    _isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),  // 이 라인을 추가합니다.
                        decoration: BoxDecoration(
                          color: _isMine ? Colors.lightBlue : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_messages[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.report),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('앨범 선택'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('사진 찍기'),
                            onTap: () {},
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '메시지를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (String message) {
                    setState(() {
                      _messages.add(message);
                      _isMine = !_isMine;
                      _sendMessage(message);
                      _messageController.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Countdown extends StatefulWidget {
  final DateTime endTime;

  Countdown({required this.endTime});

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late String _timeRemaining;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);
    if (remaining.isNegative) {
      Navigator.pop(context);
      return;
    }

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    final formatted = '${minutes}m ${seconds}s';
    setState(() {
      _timeRemaining = formatted;
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Text(_timeRemaining);
  }
}
