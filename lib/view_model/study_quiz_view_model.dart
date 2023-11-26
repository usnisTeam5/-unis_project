import 'dart:io';

import 'package:flutter/material.dart';
import '../models/study_quiz_model.dart';

class StudyQuizViewModel with ChangeNotifier {
  final StudyApiService _apiService = StudyApiService();
  bool _isLoading = false;

  // 로딩 상태 getter
  bool get isLoading => _isLoading;

  // 로딩 상태 setter
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 폴더 목록 가져오기
  Future<List<StudyQuizListDto>> getFolderList(int roomKey) async {
    _setLoading(true);
    try {
      var folders = await _apiService.getFolderList(roomKey);
      _setLoading(false);
      return folders;
    } catch (e) {
      // 에러 처리
      print('Error getting folder list: $e');
      _setLoading(false);
      throw e;
    }
  }

  // 폴더 생성
  Future<void> makeFolder(int roomKey, String folderName) async {
    _setLoading(true);
    try {
      await _apiService.makeFolder(roomKey, folderName);
      // 추가 작업 (예: 폴더 목록 업데이트)
    } catch (e) {
      // 에러 처리
      print('Error making folder: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 등록된 사용자 목록 가져오기
  Future<List<String>> getEnrollUserList(int roomKey, int folderKey) async {
    _setLoading(true);
    try {
      var userList = await _apiService.getEnrollUserList(roomKey, folderKey);
      _setLoading(false);
      return userList;
    } catch (e) {
      // 에러 처리
      print('Error getting enroll user list: $e');
      _setLoading(false);
      throw e;
    }
  }

  // 파일 등록
  Future<String> enrollFile(int roomKey, int folderKey, String nickname, File file) async {
    _setLoading(true);
    try {
      var response = await _apiService.enrollFile(roomKey, folderKey, nickname, file);
      // 추가 작업
      _setLoading(false);
      return response;
    } catch (e) {
      // 에러 처리
      print('Error enrolling file: $e');
      _setLoading(false);
      throw e;
    }
  }

  // 퀴즈 생성
  Future<List<QuizDto>> getQuiz(StudyQuizInfoDto info) async {
    _setLoading(true);
    try {
      var quizzes = await _apiService.getQuiz(info);
      _setLoading(false);
      return quizzes;
    } catch (e) {
      // 에러 처리
      print('Error getting quiz: $e');
      _setLoading(false);
      throw e;
    }
  }
}
