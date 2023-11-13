import 'url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../view_model/other_profile_view_model.dart';

class UserProfileInfoForShow {

  String nickname = "안녕";
  List<String> departments = ["없음"];
  String introduction = "";
  String profileImage = 'image/unis.png';
  bool isPick = false;
  bool isFriend = false;
  bool isBlock = false;
  int question = 0;
  int answer = 0;
  int studyCnt = 0;
  double review = 0.0;

  UserProfileInfoForShow.defaultValues() :
        nickname = '',
        departments = ["안녕"],
        introduction = '',
        profileImage = 'image/unis.png',
        isPick = false,
        isFriend = false,
        isBlock = false,
        question = 0,
        answer = 0,
        studyCnt = 0,
        review = 0.0;

  UserProfileInfoForShow({
    required this.nickname,
    required this.departments,
    required this.introduction,
    required this.profileImage,
    required this.isPick,
    required this.isFriend,
    required this.isBlock,
    required this.question,
    required this.answer,
    required this.studyCnt,
    required this.review,
  });

  factory UserProfileInfoForShow.fromJson(Map<String, dynamic> json) {
    return UserProfileInfoForShow(
      nickname: json['nickname'],
      departments: List<String>.from(json['departments'] ?? []),
      introduction: json['introduction'] ?? '',
      profileImage: json['profileImage'] ?? 'image/unis.png',
      isPick: json['isPick'],
      isFriend: json['isFriend'],
      isBlock: json['isBlock'],
      question: json['question'],
      answer: json['answer'],
      studyCnt: json['studyCnt'],
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    // 통신할 떄 필요
    return {
      'nickname': nickname,
      'departments': departments,
      'introduction': introduction,
      'profileImage': profileImage,
      'isPick': isPick,
      'isBlock': isBlock,
      'isFriend': isFriend,
      'question': question,
      'answer': answer,
      'studyCnt': studyCnt,
      'review': review,
    };
  }


  static Future<UserProfileInfoForShow?> fetchUserProfile(String userNickname, String friendNickname) async {
    try {
      String endpoint = "$BASE_URL/user/profile/forShow?nickname=$userNickname&friendNickname=$friendNickname";

      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =jsonDecode(utf8.decode(response.bodyBytes));
        //print("data입니다:$data");
        // 이미지 처리 base64 string으로 받아서 임시 파일에 profile_image.png로 저장 후 경로 반환.
        if (data['profileImage'] != null) {
          final bytes = base64Decode(data['profileImage']);
          final directory = await getApplicationDocumentsDirectory();
          //final imageExtension = path.extension(data['profileImage']).replaceAll('.', '');
          // 이미지 파일을 생성하고 원본 확장자를 사용하여 파일명 설정
          final file = File('${directory.path}/$friendNickname${path.extension(data['profileImage'])}');
          if (file.existsSync()) {
            file.deleteSync();
          }
          // 파일에 바이트 데이터를 씀
          file.writeAsBytesSync(bytes);
          // 파일 경로 반환
          data['profileImage'] = file.path;     //
        }

        //data['nickName'] = nickname; // 서버 응답에 없는 닉네임을 추가
        // if (data['departments'][1] == null) {
        //   data['departments'].removeLast();
        //   print(data['departments']);
        // }
        final temp = UserProfileInfoForShow.fromJson(data);
        print("친구정보 패치 ${temp.toJson()}");

        return temp;
      } else {
        print('Server error: ${response.statusCode}'); // response.body
        return null;
      }
    } catch (e) {
      print('fetchUserProfile error: $e');
      return null;
    }
  }


  static Future<String> setPick(String nickname, String otherNickname) async {
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setPick/$nickname');
    final response = await http.post(url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set pick');
    }
  }

  static Future<String> setFriend(String nickname, String otherNickname) async { // 친구
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setFriend/$nickname');
    final response = await http.post(
      url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set friend');
    }
  }

  static Future<String> setBlock(String nickname, String otherNickname) async { // 차단
    final url = Uri.parse('http://3.35.21.123:8080/user/profile/setBlock/$nickname');
    final response = await http.post(
      url,
      body: {'otherNickname': otherNickname},
    );

    if (response.statusCode == 200) {
      return "ok";
    } else {
      throw Exception('Failed to set block');
    }
  }

  UserProfileInfoForShow copyWith({
    bool? isPick,
    bool? isFriend,
    bool? isBlock,
  }) {
    return UserProfileInfoForShow(
      nickname: this.nickname,
      departments: this.departments,
      introduction: this.introduction,
      profileImage: this.profileImage,
      isPick: isPick ?? this.isPick,
      isFriend: isFriend!,
      isBlock: isBlock!,
      question: this.question,
      answer: this.answer,
      studyCnt: this.studyCnt,
      review: this.review,
    );
  }
}