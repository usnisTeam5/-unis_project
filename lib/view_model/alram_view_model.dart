import 'dart:convert';
//import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:/intl.dart';
import '../models/alram_model.dart';



// QaAlarmViewModel class
class AlarmViewModel with ChangeNotifier {
  List<QaAlarmDto> _qaAlarms = [];
  bool _isLoading = false;
  List<QaAlarmDto> qaAlarmsStore = [];

  List<QaAlarmDto> get qaAlarms => _qaAlarms;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fetch QA Alarm data from server
  Future<void> fetchQaAlarms(String nickname) async {
    setLoading(true);
    try {
      _qaAlarms = await getQaAlarm(nickname);

      if(_qaAlarms.isNotEmpty) { // 비어있지 않은 경우
        qaAlarmsStore.addAll(_qaAlarms);
      }
    } catch (e) {
      print(e); // Handle any errors here
    }
    setLoading(false);
  }

}