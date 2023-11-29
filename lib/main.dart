import 'package:flutter/material.dart';
import 'package:unis_project/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:unis_project/password_reset/password_reset.dart';
import 'package:unis_project/register/user_agreement.dart';
import 'package:flutter/services.dart';
import '../css/css.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../view_model/alram_view_model.dart';
import '../view_model/chatRecord_view_model.dart';
import '../view_model/login_result_view_model.dart';
import '../view_model/quiz_view_model.dart';
import '../view_model/study_info_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'dart:io';

import 'login/login.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginViewModel>(
            create: (context) => LoginViewModel(),
          ),
          ChangeNotifierProvider<UserProfileViewModel>(
            create: (context) => UserProfileViewModel(),
          ),
          ChangeNotifierProvider<MyStudyInfoViewModel>(
            create: (context) => MyStudyInfoViewModel(),
          ),
          ChangeNotifierProvider<QuizViewModel>(
            create: (context) => QuizViewModel(),
          ),
          ChangeNotifierProvider<AlarmViewModel>(
            create: (context) => AlarmViewModel(),
          ),
          ChangeNotifierProvider<ChatListViewModel>(
            create: (context) => ChatListViewModel(),
          ),
        ],
        child: const UnisApp()
    ),
  );
}