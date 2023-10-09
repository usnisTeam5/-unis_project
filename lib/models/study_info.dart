class StudyInfo {
  final int roomNum; // 스터디방 고유키
  final String roomName; // 스터디 제목
  final String major; // 과목명
  final int maximumNum; // 최대인원수
  final int num; // 현재인원수
  final String leaderNickName; // 그룹장
  final String startDate; // 시작일
  final bool isOpen; // 공개여부
  final String studyIntroduction; // 스터디 소개글

  StudyInfo({
    required this.roomNum,
    required this.roomName,
    required this.major,
    required this.maximumNum,
    required this.num,
    required this.leaderNickName,
    required this.startDate,
    required this.isOpen,
    required this.studyIntroduction,
  });

  // 이름 있는 생성자를 사용하여 기본값을 설정합니다.
  StudyInfo.defaultValues()
      : roomNum = 1001,
        roomName = 'Intro to Dart Programming',
        major = 'Computer Science',
        maximumNum = 10,
        num = 5,
        leaderNickName = 'JohnDoe',
        startDate = '2023-10-01',
        isOpen = true,
        studyIntroduction = 'This is a beginner-friendly study group for Dart programming.';
  factory StudyInfo.fromJson(Map<String, dynamic> json) {
    return StudyInfo(
      roomNum: json['roomNum'],
      roomName: json['roomName'],
      major: json['major'],
      maximumNum: json['maximumNum'],
      num: json['num'],
      leaderNickName: json['leaderNickName'],
      startDate: json['startDate'],
      isOpen: json['isOpen'],
      studyIntroduction: json['studyIntroduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNum': roomNum,
      'roomName': roomName,
      'major': major,
      'maximumNum': maximumNum,
      'num': num,
      'leaderNickName': leaderNickName,
      'startDate': startDate,
      'isOpen': isOpen,
      'studyIntroduction': studyIntroduction,
    };
  }
}
