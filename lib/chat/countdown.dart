/*
남은 시간
 */
import 'dart:async';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);
    if (remaining.isNegative) {
      _timer?.cancel();
      Navigator.pop(context);  // 시간 끝나면 화면 닫음
      return;
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60; // 시간을 제외한 순수 분
    final seconds = remaining.inSeconds % 60;

    String formatted = hours != 0 ? '남은 시간 ${hours}h ${minutes}m ${seconds}s' : '남은 시간 ${minutes}m ${seconds}s';

    setState(() {
      _timeRemaining = formatted;
    });

    _timer = Timer(Duration(seconds: 1), _updateTime);
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
