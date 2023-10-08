
class UserProfileInfo {
  final String nickName;
  final List<String> major;
  final String introduction;
  final List<String> currentCourses;
  final List<String> pastCourses;
  final String profileImageUrl;
  final int point;
  final int question;
  final int answer;
  final int studyCnt;

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

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) {
    return UserProfileInfo(
      nickName: json['nickName'],
      major: json['major'],
      introduction: json['introduction'],
      currentCourses: List<String>.from(json['currentCourses']),
      pastCourses: List<String>.from(json['pastCourses']),
      // `profileImage` 처리는 Flutter 앱 내에서 이미지 처리 방식에 따라 달라질 수 있습니다.
      profileImageUrl: Image.network(json['profileImageUrl']), // 예시로 네트워크 이미지를 사용하였습니다.
      point: json['point'],
      question: json['question'],
      answer: json['answer'],
      studyCnt: json['studyCnt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'major': major,
      'introduction': introduction,
      'currentCourses': currentCourses,
      'pastCourses': pastCourses,
      // `profileImage`에 대한 JSON 변환은 해당 이미지 처리 방식에 따라 달라질 수 있습니다.
      'profileImageUrl': profileImage.networkUrl, // 예시로 네트워크 이미지의 URL을 사용하였습니다.
      'point': point,
      'question': question,
      'answer': answer,
      'studyCnt': studyCnt,
    };
  }
}
