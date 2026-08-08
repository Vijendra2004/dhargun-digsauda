class PriceDiscoveryRequest {
  List<CompetitorAnalysisList>? competitorAnalysisList;

  PriceDiscoveryRequest({this.competitorAnalysisList});

  PriceDiscoveryRequest.fromJson(Map<String, dynamic> json) {
    if (json['CompetitorAnalysisList'] != null) {
      competitorAnalysisList = <CompetitorAnalysisList>[];
      json['CompetitorAnalysisList'].forEach((v) {
        competitorAnalysisList!.add(CompetitorAnalysisList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (competitorAnalysisList != null) {
      data['CompetitorAnalysisList'] =
          competitorAnalysisList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompetitorAnalysisList {
  List<CompetitorAnalysisDetailsList>? competitorAnalysisDetailsList;
  double? emamiPrice;
  double? workableQuantity;
  bool? isOpen;
  int? loginUserId;
  int? oilTypeId;
  int? skuId;
  double? workablePrice;

  CompetitorAnalysisList(
      {this.competitorAnalysisDetailsList,
      this.emamiPrice,
      this.workableQuantity,
      this.isOpen,
      this.loginUserId,
      this.oilTypeId,
      this.skuId,
      this.workablePrice});

  CompetitorAnalysisList.fromJson(Map<String, dynamic> json) {
    if (json['CompetitorAnalysisDetailsList'] != null) {
      competitorAnalysisDetailsList = <CompetitorAnalysisDetailsList>[];
      json['CompetitorAnalysisDetailsList'].forEach((v) {
        competitorAnalysisDetailsList!
            .add(CompetitorAnalysisDetailsList.fromJson(v));
      });
    }
    emamiPrice = json['EmamiPrice'];
    workableQuantity = json['WorkableQuantity'];
    isOpen = json['isOpen'];
    loginUserId = json['LoginUserId'];
    oilTypeId = json['OilTypeId'];
    skuId = json['SkuId'];
    workablePrice = json['WorkablePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (competitorAnalysisDetailsList != null) {
      data['CompetitorAnalysisDetailsList'] =
          competitorAnalysisDetailsList!.map((v) => v.toJson()).toList();
    }
    data['EmamiPrice'] = emamiPrice;
    data['WorkableQuantity'] = workableQuantity;
    data['isOpen'] = isOpen;
    data['LoginUserId'] = loginUserId;
    data['OilTypeId'] = oilTypeId;
    data['SkuId'] = skuId;
    data['WorkablePrice'] = workablePrice;
    return data;
  }
}

class CompetitorAnalysisDetailsList {
  int? competitorId;
  String? competitorName;
  double? marketOperatingPrice;
  double? saudaRate;

  CompetitorAnalysisDetailsList(
      {this.competitorId,
      this.competitorName,
      this.marketOperatingPrice,
      this.saudaRate});

  CompetitorAnalysisDetailsList.fromJson(Map<String, dynamic> json) {
    competitorId = json['CompetitorId'];
    competitorName = json['competitorName'];
    marketOperatingPrice = json['MarketOperatingPrice'];
    saudaRate = json['SaudaRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompetitorId'] = competitorId;
    data['competitorName'] = competitorName;
    data['MarketOperatingPrice'] = marketOperatingPrice;
    data['SaudaRate'] = saudaRate;
    return data;
  }
}
