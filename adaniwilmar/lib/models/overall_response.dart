class OverallResponse {
  int? userId;
  double? totalTarget;
  double? overallSales;
  double? overallSauda;
  int? monthId;
  String? month;
  List<AchievmentDetailsDto>? achievmentDetailsDto;

  OverallResponse(
      {this.userId, this.totalTarget, this.monthId, this.achievmentDetailsDto,this.month});

  OverallResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    totalTarget = json['totalTarget'];
    overallSales = json['overallSales'];
    overallSauda = json['overallSauda'];
    monthId = json['monthId'];
    month = json['month'];
    if (json['achievmentDetailsDto'] != null) {
      achievmentDetailsDto = <AchievmentDetailsDto>[];
      json['achievmentDetailsDto'].forEach((v) {
        achievmentDetailsDto!.add(AchievmentDetailsDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['totalTarget'] = totalTarget;
    data['monthId'] = monthId;
    data['month'] = month;
    if (achievmentDetailsDto != null) {
      data['achievmentDetailsDto'] =
          achievmentDetailsDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AchievmentDetailsDto {
  int? userId;
  String? date;
  double? achievment;

  AchievmentDetailsDto({this.userId, this.date, this.achievment});

  AchievmentDetailsDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    date = json['date'];
    achievment = json['achievment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['date'] = date;
    data['achievment'] = achievment;
    return data;
  }
}

class OverallChartData {
  int? userId;
  double? totalTarget;
  int? monthId;
  String? month;
  String? categoryName;
  double? achievement;

  OverallChartData(
      {this.userId, this.totalTarget, this.monthId, this.achievement,this.categoryName});

  OverallChartData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    totalTarget = json['totalTarget'];
    monthId = json['monthId'];
    month = json['month'];
    achievement = json['achievement'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['totalTarget'] = totalTarget;
    data['monthId'] = monthId;
    data['month'] = month;
    data['achievement'] = achievement;
    data['categoryName'] = categoryName;
    return data;
  }
}
class OverallDashboard {
  List<OverallResponse>? saudaList;
  List<OverallResponse>? salesList;
  double? totalTarget;
  double? overallSauda;
  double? overallSales;
  Quarter1? quarter1;
  Quarter1? quarter2;
  Quarter1? quarter3;
  Quarter1? quarter4;

  OverallDashboard(
      {this.saudaList,
        this.salesList,
        this.totalTarget,
        this.overallSauda,
        this.overallSales,
        this.quarter1,
        this.quarter2,
        this.quarter3,
        this.quarter4});

  OverallDashboard.fromJson(Map<String, dynamic> json) {
    if (json['salesList'] != null) {
      salesList = <OverallResponse>[];
      json['salesList'].forEach((v) {
        salesList!.add(new OverallResponse.fromJson(v));
      });
    }
    if (json['saudaList'] != null) {
      saudaList = <OverallResponse>[];
      json['saudaList'].forEach((v) {
        saudaList!.add(new OverallResponse.fromJson(v));
      });
    }
    totalTarget = json['totalTarget'];
    overallSauda = json['overallSauda'];
    overallSales = json['overallSales'];
    quarter1 = json['quarter1'] != null
        ? new Quarter1.fromJson(json['quarter1'])
        : null;
    quarter2 = json['quarter2'] != null
        ? new Quarter1.fromJson(json['quarter2'])
        : null;
    quarter3 = json['quarter3'] != null
        ? new Quarter1.fromJson(json['quarter3'])
        : null;
    quarter4 = json['quarter4'] != null
        ? new Quarter1.fromJson(json['quarter4'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.saudaList != null) {
      data['saudaList'] = this.saudaList!.map((v) => v.toJson()).toList();
    }
    data['totalTarget'] = this.totalTarget;
    data['overallSauda'] = this.overallSauda;
    if (this.quarter1 != null) {
      data['quarter1'] = this.quarter1!.toJson();
    }
    if (this.quarter2 != null) {
      data['quarter2'] = this.quarter2!.toJson();
    }
    if (this.quarter3 != null) {
      data['quarter3'] = this.quarter3!.toJson();
    }
    if (this.quarter4 != null) {
      data['quarter4'] = this.quarter4!.toJson();
    }
    return data;
  }
}

class Quarter1 {
  double? totalTarget;
  double? overallSauda;
  double? overallSales;

  Quarter1({this.totalTarget, this.overallSauda,this.overallSales});

  Quarter1.fromJson(Map<String, dynamic> json) {
    totalTarget = json['totalTarget'];
    overallSauda = json['overallSauda'];
    overallSales = json['overallSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalTarget'] = this.totalTarget;
    data['overallSauda'] = this.overallSauda;
    data['overallSales'] = this.overallSales;
    return data;
  }
}
