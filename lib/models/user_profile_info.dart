import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileInfo {
  final String nickName;
  List<String> major;
  String introduction;
  List<String> currentCourses;
  List<String> pastCourses;
  String profileImageUrl;
  int point;
  int question;
  int answer;
  int studyCnt;

  UserProfileInfo({
    required this.nickName,
    required this.major,
    required this.introduction,
    required this.currentCourses,
    required this.pastCourses,
    required this.profileImageUrl,
    required this.point,
    required this.question,
    required this.answer,
    required this.studyCnt,
  });

  UserProfileInfo.defaultValues() :// 디폴트값 넣어놓음.
        nickName = "꽃구리",
        major = ['소프트웨어학부','경영학부'],
        introduction = 'Hello! I am a student.',
        currentCourses = ['컴퓨터 그래픽스', '휴먼인터페이스'],
        pastCourses = ['수치해석'],
        profileImageUrl = 'image/unis.png',
        point = 100,
        question = 10,
        answer = 5,
        studyCnt = 3;

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) { // json to userprofile.
    return UserProfileInfo(
      nickName: json['nickName'],
      major: json['major'],
      introduction: json['introduction'] ?? '',
      currentCourses: List<String>.from(json['currentCourses']),
      pastCourses: List<String>.from(json['pastCourses']),
      // `profileImage` 처리는 Flutter 앱 내에서 이미지 처리 방식에 따라 달라질 수 있습니다.
      profileImageUrl: json['profileImageUrl'] ?? 'image/unis.png', // 예시로 네트워크 이미지를 사용하였습니다.
      point: json['point'],
      question: json['question'],
      answer: json['answer'],
      studyCnt: json['studyCnt'],
    );
  }

  Map<String, dynamic> toJson() { // 통신할 떄 필요
    return {
      'nickName': nickName,
      'major': major,
      'introduction': introduction,
      'currentCourses': currentCourses,
      'pastCourses': pastCourses,
      // `profileImage`에 대한 JSON 변환은 해당 이미지 처리 방식에 따라 달라질 수 있습니다.
      'profileImageUrl': profileImageUrl, // 예시로 네트워크 이미지의 URL을 사용하였습니다.
      'point': point,
      'question': question,
      'answer': answer,
      'studyCnt': studyCnt,
    };
  }

  static Future<UserProfileInfo?> fetchUserProfile(String nickName) async { // 유저 프로필 정보 가져옴
    final response = await http.get(Uri.parse('http://3.35.21.123:8080/user/profile'));
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['nickName'] = nickName; // 서버 응답에 없는 닉네임을 추가
        return UserProfileInfo.fromJson(data);
      } else {
        throw Exception('Failed to load user profile');
      }
    }
    catch (error) {
    // 네트워크 호출 중 발생한 예외 처리
    }
    return null;
  }

  Future<void> setImage(String nickname, String imagePath) async {
    // 프로필 이미지 업로드 API 호출
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setImage/$nickname');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      // 업로드 성공 시 처리
      // 예: 이미지 URL 업데이트
      profileImageUrl = await response.stream.bytesToString();
    } else {
      throw Exception('Failed to upload profile image');
    }
  }

  Future<void> setIntroduction(String nickname, String introduce) async {
    // 자기 소개 업데이트 API 호출
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setIntroduction/$nickname');
    final response = await http.post(url, body: introduce);

    if (response.statusCode == 200) {
      // 업데이트 성공 시 처리
      // 예: introduction 업데이트
      introduction = introduce;
    } else {
      throw Exception('Failed to update introduction');
    }
  }

  Future<void> changeCourseNowToPast(String nickname, String courseName) async {
    // 현재 과목을 수강한 과목으로 변경하는 API 호출
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/nowToPastCourse/$nickname');
    final response = await http.post(url, body: courseName);

    if (response.statusCode == 200) {
      // 업데이트 성공 시 처리
      // 예: currentCourses에서 해당 과목 삭제, pastCourses에 추가
      currentCourses.remove(courseName);
      pastCourses.add(courseName);
    } else {
      throw Exception('Failed to change course from now to past');
    }
  }

  Future<void> changeCoursePastToNow(String nickname, String courseName) async {
    // 수강한 과목을 현재 과목으로 변경하는 API 호출
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/PastToNowCourse/$nickname');
    final response = await http.post(url, body: courseName);

    if (response.statusCode == 200) {
      // 업데이트 성공 시 처리
      // 예: pastCourses에서 해당 과목 삭제, currentCourses에 추가
      pastCourses.remove(courseName);
      currentCourses.add(courseName);
    } else {
      throw Exception('Failed to change course from past to now');
    }
  }
}
