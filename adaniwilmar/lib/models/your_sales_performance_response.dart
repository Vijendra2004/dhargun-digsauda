class YourSalesPerformance {
  int? userId;
  String? username;
  String? usercode;
  double? userTarget;
  double? userAchievment;
  double? achievmentPercentage;
  int? rank;

  YourSalesPerformance(
      {this.userId,
      this.username,
      this.usercode,
      this.userTarget,
      this.userAchievment,
      this.achievmentPercentage,
      this.rank});

  YourSalesPerformance.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    usercode = json['usercode'];
    userTarget = json['userTarget'];
    userAchievment = json['userAchievment'];
    achievmentPercentage = json['achievmentPercentage'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['usercode'] = usercode;
    data['userTarget'] = userTarget;
    data['userAchievment'] = userAchievment;
    data['achievmentPercentage'] = achievmentPercentage;
    data['rank'] = rank;
    return data;
  }
}
