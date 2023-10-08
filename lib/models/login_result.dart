class LoginResult {
  final String msg;
  final int userKey;
  final String userNickName;

  LoginResult({
    required this.msg,
    required this.userKey,
    required this.userNickName,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      msg: json['msg'],
      userKey: json['userKey'],
      userNickName: json['userNickName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'userKey': userKey,
      'userNickName': userNickName,
    };
  }
}
