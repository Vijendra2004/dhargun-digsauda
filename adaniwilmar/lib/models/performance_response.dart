class PerformanceViewDto {
  PerformanceViewDto({
    required this.userId,
    required this.username,
    required this.usercode,
    required this.userTarget,
    required this.userAchievment,
    required this.achievmentPercentage,
  });
  late final int userId;
  late final String username;
  late final String usercode;
  late final int userTarget;
  late final double userAchievment;
  late final int achievmentPercentage;

  PerformanceViewDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    usercode = json['usercode'];
    userTarget = json['userTarget'];
    userAchievment = json['userAchievment'];
    achievmentPercentage = json['achievmentPercentage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['username'] = username;
    _data['usercode'] = usercode;
    _data['userTarget'] = userTarget;
    _data['userAchievment'] = userAchievment;
    _data['achievmentPercentage'] = achievmentPercentage;
    return _data;
  }
}
