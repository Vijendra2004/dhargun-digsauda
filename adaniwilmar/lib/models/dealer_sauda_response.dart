class DealerSaudaList {
  int? saudaId;
  int? saudaOrderId;
  String? biddingDate;
  String? dealerName;
  double? totalQty;
  double? totalAmt;
  String? deliveryLocation;
  String? plantOrDepot;
  String? incoTerms;
  String? saudaNo;

  DealerSaudaList(
      {this.saudaId,
      this.saudaOrderId,
      this.biddingDate,
      this.dealerName,
      this.totalQty,
      this.totalAmt,
      this.deliveryLocation,
      this.plantOrDepot,
      this.incoTerms,
      this.saudaNo});

  DealerSaudaList.fromJson(Map<String, dynamic> json) {
    saudaId = json['saudaId'];
    saudaOrderId = json['saudaOrderId'];
    biddingDate = json['biddingDate'];
    dealerName = json['dealerName'];
    totalQty = json['totalQty'];
    totalAmt = json['totalAmt'];
    deliveryLocation = json['deliveryLocation'];
    plantOrDepot = json['plantOrDepot'];
    incoTerms = json['incoTerms'];
    saudaNo = json['saudaNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saudaId'] = saudaId;
    data['saudaOrderId'] = saudaOrderId;
    data['biddingDate'] = biddingDate;
    data['dealerName'] = dealerName;
    data['totalQty'] = totalQty;
    data['totalAmt'] = totalAmt;
    data['deliveryLocation'] = deliveryLocation;
    data['plantOrDepot'] = plantOrDepot;
    data['incoTerms'] = incoTerms;
    data['saudaNo'] = saudaNo;
    return data;
  }
}

class DealerDetail {
  int? dealerId;
  String? dealerName;
  String? dealerCode;
  double? bgsgGiven;
  double? currentLimit;
  double? sales;
  double? saudaOutStatnding;
  int? visitsDone;
  double? collectionDue;

  DealerDetail(
      {this.dealerId,
      this.dealerName,
      this.dealerCode,
      this.bgsgGiven,
      this.currentLimit,
      this.sales,
      this.saudaOutStatnding,
      this.visitsDone,
      this.collectionDue});

  DealerDetail.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    dealerCode = json['dealerCode'];
    bgsgGiven = json['bgsgGiven'];
    currentLimit = json['currentLimit'];
    sales = json['sales'];
    saudaOutStatnding = json['saudaOutStatnding'];
    visitsDone = json['visitsDone'];
    collectionDue = json['collectionDue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['dealerCode'] = dealerCode;
    data['bgsgGiven'] = bgsgGiven;
    data['currentLimit'] = currentLimit;
    data['sales'] = sales;
    data['saudaOutStatnding'] = saudaOutStatnding;
    data['visitsDone'] = visitsDone;
    data['collectionDue'] = collectionDue;
    return data;
  }
}
