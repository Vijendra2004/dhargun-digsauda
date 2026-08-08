class WeeklyResponse {
  double? totalTarget;
  double? overallSauda;
  List<OverallWeekWiseAchievements>? overallWeekWiseAchievements;

  WeeklyResponse({this.totalTarget, this.overallSauda,this.overallWeekWiseAchievements});

  WeeklyResponse.fromJson(Map<String, dynamic> json) {
    totalTarget = json['totalTarget'];
    overallSauda = json['overallSauda'];
    if (json['overallWeekWiseAchievements'] != null) {
      overallWeekWiseAchievements = <OverallWeekWiseAchievements>[];
      json['overallWeekWiseAchievements'].forEach((v) {
        overallWeekWiseAchievements!
            .add(OverallWeekWiseAchievements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTarget'] = totalTarget;
    data['overallSauda'] = overallSauda;
    if (overallWeekWiseAchievements != null) {
      data['overallWeekWiseAchievements'] =
          overallWeekWiseAchievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OverallWeekWiseAchievements {
  int? weekId;
  String? week;
  double? achievement;
  double? target;

  OverallWeekWiseAchievements({this.weekId, this.week, this.achievement,this.target});

  OverallWeekWiseAchievements.fromJson(Map<String, dynamic> json) {
    weekId = json['weekId'];
    week = json['week'];
    achievement = json['achievement'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekId'] = weekId;
    data['week'] = week;
    data['achievement'] = achievement;
    data['target'] = target;
    return data;
  }
}

class WeeklySalesResponse {
  double? totalTarget;
  double? overallSales;
  List<OverallWeekWiseAchievements>? overallWeekWiseAchievements;

  WeeklySalesResponse({this.totalTarget, this.overallSales,this.overallWeekWiseAchievements});

  WeeklySalesResponse.fromJson(Map<String, dynamic> json) {
    totalTarget = json['totalTarget'];
    overallSales = json['overallSales'];
    if (json['overallWeekWiseAchievements'] != null) {
      overallWeekWiseAchievements = <OverallWeekWiseAchievements>[];
      json['overallWeekWiseAchievements'].forEach((v) {
        overallWeekWiseAchievements!
            .add(OverallWeekWiseAchievements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTarget'] = totalTarget;
    data['overallSales'] = overallSales;
    if (overallWeekWiseAchievements != null) {
      data['overallWeekWiseAchievements'] =
          overallWeekWiseAchievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
