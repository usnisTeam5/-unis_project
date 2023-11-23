/*
남은 시간
 */
import 'package:flutter/material.dart';
import 'package:unis_project/css/css.dart';

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
      Navigator.pop(context);  // 시간 끝나면 화면 닫음
      return;
    }

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    final formatted = '남은 시간 ${minutes}m ${seconds}s';
    setState(() {
      _timeRemaining = formatted;
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Text(_timeRemaining,
        style: TextStyle(
          fontFamily: 'Bold',
          color: Colors.grey[500],
          fontSize: 13,
        )
    );
  }
}
