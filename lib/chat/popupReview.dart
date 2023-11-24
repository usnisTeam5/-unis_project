/*
리뷰
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/chat/myQHistoryChat.dart';

import '../view_model/question_view_model.dart';

class PopupReview extends StatefulWidget {
  @override
  final int qaKey; // 생성자로 받을 변수

  PopupReview({required this.qaKey}); // 생성자

  _PopupReviewState createState() => _PopupReviewState();
}

class _PopupReviewState extends State<PopupReview> {
  int _selectedStars = 0; // 선택한 별점을 저장하는 변수

  void _submitReview(BuildContext context, int review) {
    final chatModel = Provider.of<QaViewModel>(context, listen: false);
    if (_selectedStars > 0) {
      // 별점을 선택한 경우에만 MyQHistoryChatScreen으로 이동
      chatModel.finishQa(widget.qaKey, review);
      Navigator.of(context).pop(); // 팝업 창 닫기
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyQHistoryChatScreen()), // MyQHistoryChatScreen으로 이동
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => QaViewModel(),
        builder: (context, child) {
        return AlertDialog(
          title: Text(
              "답변을 평가해주세요",
              style: TextStyle(fontFamily: 'Bold', color: Colors.grey[700]),
          ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    // 별점을 표시하는 아이콘 생성
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedStars = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 36,
                        color: index < _selectedStars ? Colors.yellow : Colors.grey,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                Text(
                  "선택한 별점: $_selectedStars",
                  style: TextStyle(fontFamily: 'Round'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: _selectedStars > 0
                    ? () => _submitReview(context, _selectedStars)
                    : null, // 별점을 선택하지 않으면 버튼 비활성화
                child: Text(
                  "확인",
                  style: TextStyle(fontFamily: 'Bold'),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
        );
      }
    );
  }
}
