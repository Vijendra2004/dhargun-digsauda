class CreditLimitTotal {
  int? dealersCount;
  double? totalCreditLimit;
  double? totalCreditExposure;
  double? totalPack;

  CreditLimitTotal(
      {this.dealersCount,
      this.totalCreditLimit,
      this.totalCreditExposure,
      this.totalPack});

  CreditLimitTotal.fromJson(Map<String, dynamic> json) {
    dealersCount = json['dealersCount'];
    totalCreditLimit = json['totalCreditLimit'];
    totalCreditExposure = json['totalCreditExposure'];
    totalPack = json['totalPack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealersCount'] = dealersCount;
    data['totalCreditLimit'] = totalCreditLimit;
    data['totalCreditExposure'] = totalCreditExposure;
    data['totalPack'] = totalPack;
    return data;
  }
}

class SalesChartResponse {
  List<SalesChart>? salesList;
  double? totalTarget;
  double? overallSales;

  SalesChartResponse({this.salesList, this.totalTarget, this.overallSales});

  SalesChartResponse.fromJson(Map<String, dynamic> json) {
    totalTarget = json['totalTarget'];
    overallSales = json['overallSales'];
    if (json['salesList'] != null) {
      salesList = <SalesChart>[];
      json['salesList'].forEach((v) {
        salesList!.add(SalesChart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTarget'] = totalTarget;
    data['overallSales'] = overallSales;
    if (salesList != null) {
      data['salesList'] = salesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesChart {
  int? oilTypeId;
  String? oilType;
  int? dealerId;
  String? dealer;
  double? totalTarget;
  double? totalAchievment;
  int? monthId;
  double? achievmentPercentage;

  SalesChart(
      {this.oilTypeId,
      this.oilType,
      this.dealerId,
      this.dealer,
      this.totalTarget,
      this.totalAchievment,
      this.monthId,
      this.achievmentPercentage});

  SalesChart.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    totalTarget = json['totalTarget'];
    totalAchievment = json['totalAchievment'];
    monthId = json['monthId'];
    achievmentPercentage = json['achievmentPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilTypeId'] = oilTypeId;
    data['oilType'] = oilType;
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['totalTarget'] = totalTarget;
    data['totalAchievment'] = totalAchievment;
    data['monthId'] = monthId;
    data['achievmentPercentage'] = achievmentPercentage;
    return data;
  }
}

class DealerSalesChartResponse {
  List<DealerSalesChart>? salesList;
  double? totalTarget;
  double? overallSales;

  DealerSalesChartResponse(
      {this.salesList, this.totalTarget, this.overallSales});

  DealerSalesChartResponse.fromJson(Map<String, dynamic> json) {
    totalTarget = json['totalTarget'];
    overallSales = json['overallSales'];
    if (json['salesList'] != null) {
      salesList = <DealerSalesChart>[];
      json['salesList'].forEach((v) {
        salesList!.add(DealerSalesChart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTarget'] = totalTarget;
    data['overallSales'] = overallSales;
    if (salesList != null) {
      data['salesList'] = salesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DealerSalesChart {
  int? dealerId;
  String? dealer;
  String? townName;
  double? totalTarget;
  double? totalAchievment;

  DealerSalesChart(
      {this.dealerId,
      this.dealer,
      this.townName,
      this.totalTarget,
      this.totalAchievment});

  DealerSalesChart.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    townName = json['townName'];
    totalTarget = json['totalTarget'];
    totalAchievment = json['totalAchievment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['townName'] = townName;
    data['totalTarget'] = totalTarget;
    data['totalAchievment'] = totalAchievment;
    return data;
  }
}
