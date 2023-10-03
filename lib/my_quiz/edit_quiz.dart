import 'package:flutter/material.dart';

class EditQuizScreen extends StatefulWidget {
  final String folderName;

  EditQuizScreen({required this.folderName});

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  late TextEditingController _questionController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  _saveQuestion() {
    // 저장 로직. 여기서는 단순히 터미널에 출력만 합니다.
    print('문제 저장: ${_questionController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문제 수정 - ${widget.folderName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _questionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '문제를 입력하세요...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveQuestion,
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
