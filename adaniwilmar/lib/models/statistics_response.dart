class StatisticsResponse {
  double? totalSaudaQuantity;
  double? totalSaudaPercentage;
  double? availableSaudaQuantity;
  double? outstandingSaudaQuantity;
  double? belowOutstandingSaudaQuantity;
  double? aboveOutstandingSaudaQuantity;
  double? pendingSaudaQuantity;
  double? overAllSalesQuantity;
  int? overAllSalesPercentage;
  int? dealersCount;
  int? rankTotalUserCount;
  int? loginUserRank;
  double? totalDueForTomorrow;
  double? totalOverDue;
  double? totalSpecialRateApproval;
  String? currentDateTime;
  bool? isApplySpecialityFatDiscount;

  StatisticsResponse(
      {this.totalSaudaQuantity,
      this.totalSaudaPercentage,
      this.availableSaudaQuantity,
      this.outstandingSaudaQuantity,
      this.belowOutstandingSaudaQuantity,
      this.aboveOutstandingSaudaQuantity,
      this.pendingSaudaQuantity,
      this.overAllSalesQuantity,
      this.overAllSalesPercentage,
      this.dealersCount,
      this.rankTotalUserCount,
      this.loginUserRank,
      this.totalDueForTomorrow,
      this.totalOverDue,
      this.totalSpecialRateApproval,
      this.currentDateTime,
      this.isApplySpecialityFatDiscount});

  StatisticsResponse.fromJson(Map<String, dynamic> json) {
    totalSaudaQuantity = json['totalSaudaQuantity'];
    totalSaudaPercentage = json['totalSaudaPercentage'];
    availableSaudaQuantity = json['availableSaudaQuantity'];
    outstandingSaudaQuantity = json['outstandingSaudaQuantity'];
    belowOutstandingSaudaQuantity = json['belowOutstandingSaudaQuantity'];
    aboveOutstandingSaudaQuantity = json['aboveOutstandingSaudaQuantity'];
    pendingSaudaQuantity = json['pendingSaudaQuantity'];
    overAllSalesQuantity = json['overAllSalesQuantity'];
    overAllSalesPercentage = json['overAllSalesPercentage'];
    dealersCount = json['dealersCount'];
    rankTotalUserCount = json['rankTotalUserCount'];
    loginUserRank = json['loginUserRank'];
    totalDueForTomorrow = json['totalDueForTomorrow'];
    totalOverDue = json['totalOverDue'];
    totalSpecialRateApproval = json['totalSpecialRateApproval'];
    currentDateTime = json['currentDateTime'];
    isApplySpecialityFatDiscount = json['isApplySpecialityFatDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSaudaQuantity'] = totalSaudaQuantity;
    data['totalSaudaPercentage'] = totalSaudaPercentage;
    data['availableSaudaQuantity'] = availableSaudaQuantity;
    data['outstandingSaudaQuantity'] = outstandingSaudaQuantity;
    data['belowOutstandingSaudaQuantity'] = belowOutstandingSaudaQuantity;
    data['aboveOutstandingSaudaQuantity'] = aboveOutstandingSaudaQuantity;
    data['pendingSaudaQuantity'] = pendingSaudaQuantity;
    data['overAllSalesQuantity'] = overAllSalesQuantity;
    data['overAllSalesPercentage'] = overAllSalesPercentage;
    data['dealersCount'] = dealersCount;
    data['rankTotalUserCount'] = rankTotalUserCount;
    data['loginUserRank'] = loginUserRank;
    data['totalDueForTomorrow'] = totalDueForTomorrow;
    data['totalOverDue'] = totalOverDue;
    data['totalSpecialRateApproval'] = totalSpecialRateApproval;
    data['currentDateTime'] = currentDateTime;
    data['isApplySpecialityFatDiscount'] = isApplySpecialityFatDiscount;
    return data;
  }
}
