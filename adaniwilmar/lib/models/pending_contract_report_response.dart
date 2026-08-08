class PendingContractReport {
  int? id;
  String? currentDate;
  List<PendingContractDealerOutput>? pendingContractDealerOutput;
  double? totalQuantityInMT;
  double? totalQuantityInCase;
  String? pendingDate;

  PendingContractReport({this.id, this.currentDate, this.pendingContractDealerOutput, this.totalQuantityInMT, this.totalQuantityInCase, this.pendingDate});

  PendingContractReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentDate = json['currentDate'];
    if (json['pendingContractDealerOutput'] != null) {
      pendingContractDealerOutput = <PendingContractDealerOutput>[];
      json['pendingContractDealerOutput'].forEach((v) {
        pendingContractDealerOutput!.add(PendingContractDealerOutput.fromJson(v));
      });
    }
    totalQuantityInMT = json['totalQuantityInMT'];
    totalQuantityInCase = json['totalQuantityInCase'];
    pendingDate = json['pendingDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currentDate'] = currentDate;
    if (pendingContractDealerOutput != null) {
      data['pendingContractDealerOutput'] = pendingContractDealerOutput!.map((v) => v.toJson()).toList();
    }
    data['totalQuantityInMT'] = totalQuantityInMT;
    data['totalQuantityInCase'] = totalQuantityInCase;
    data['pendingDate'] = pendingDate;
    return data;
  }
}

class PendingContractDealerOutput {
  int? dealerId;
  String? dealer;
  List<PendingContractSkuOutput>? pendingContractSkuOutput;

  PendingContractDealerOutput({this.dealerId, this.dealer, this.pendingContractSkuOutput});

  PendingContractDealerOutput.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    if (json['pendingContractSkuOutput'] != null) {
      pendingContractSkuOutput = <PendingContractSkuOutput>[];
      json['pendingContractSkuOutput'].forEach((v) {
        pendingContractSkuOutput!.add(PendingContractSkuOutput.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    if (pendingContractSkuOutput != null) {
      data['pendingContractSkuOutput'] = pendingContractSkuOutput!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingContractSkuOutput {
  int? skuId;
  String? sku;
  double? quantityInCase;
  double? quantityInMT;
  int? bdoId;
  String? bdoName;
  double? rate;
  int? userId;
  String? biddingDate;
  String? dealer;
  List<PendingContractSkuDetails>? pendingContractSkuDetails;
  String? contractNumber;
  String? contractValidFrom;
  String? contractValidTo;

  PendingContractSkuOutput(
      {this.skuId,
      this.sku,
      this.quantityInCase,
      this.quantityInMT,
      this.bdoId,
      this.bdoName,
      this.rate,
      this.userId,
      this.biddingDate,
      this.dealer,
      this.pendingContractSkuDetails,
      this.contractNumber,
      this.contractValidFrom,
      this.contractValidTo});

  PendingContractSkuOutput.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    sku = json['sku'];
    quantityInCase = json['quantityInCase'];
    quantityInMT = json['quantityInMT'];
    bdoId = json['bdoId'];
    bdoName = json['bdoName'];
    rate = json['rate'];
    userId = json['userId'];
    biddingDate = json['biddingDate'];
    dealer = json['dealer'];
    if (json['pendingContractSkuDetails'] != null) {
      pendingContractSkuDetails = <PendingContractSkuDetails>[];
      json['pendingContractSkuDetails'].forEach((v) {
        pendingContractSkuDetails!.add(PendingContractSkuDetails.fromJson(v));
      });
    }
    contractNumber = json['contractNumber'];
    contractValidFrom = json['contractValidFrom'];
    contractValidTo = json['contractValidTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['sku'] = sku;
    data['quantityInCase'] = quantityInCase;
    data['quantityInMT'] = quantityInMT;
    data['bdoId'] = bdoId;
    data['bdoName'] = bdoName;
    data['rate'] = rate;
    data['userId'] = userId;
    data['biddingDate'] = biddingDate;
    data['dealer'] = dealer;
    if (pendingContractSkuDetails != null) {
      data['pendingContractSkuDetails'] = pendingContractSkuDetails!.map((v) => v.toJson()).toList();
    }
    data['contractNumber'] = contractNumber;
    data['contractValidFrom'] = contractValidFrom;
    data['contractValidTo'] = contractValidTo;
    return data;
  }
}

class PendingContractSkuDetails {
  double? quantityInCase;
  double? quantityInMT;
  int? bdoIsd;
  String? bdoName;
  double? rate;
  int? userId;
  String? biddingDate;
  String? dealer;
  String? contractNumber;
  String? contractValidFrom;
  String? contractValidTo;

  PendingContractSkuDetails(
      {this.quantityInCase, this.quantityInMT, this.bdoIsd, this.bdoName, this.rate, this.userId, this.biddingDate, this.dealer, this.contractNumber, this.contractValidFrom, this.contractValidTo});

  PendingContractSkuDetails.fromJson(Map<String, dynamic> json) {
    quantityInCase = json['quantityInCase'];
    quantityInMT = json['quantityInMT'];
    bdoIsd = json['bdoIsd'];
    bdoName = json['bdoName'];
    rate = json['rate'];
    userId = json['userId'];
    biddingDate = json['biddingDate'];
    dealer = json['dealer'];
    contractNumber = json['contractNumber'];
    contractValidFrom = json['contractValidFrom'];
    contractValidTo = json['contractValidTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantityInCase'] = quantityInCase;
    data['quantityInMT'] = quantityInMT;
    data['bdoIsd'] = bdoIsd;
    data['bdoName'] = bdoName;
    data['rate'] = rate;
    data['userId'] = userId;
    data['biddingDate'] = biddingDate;
    data['dealer'] = dealer;
    data['contractNumber'] = contractNumber;
    data['contractValidFrom'] = contractValidFrom;
    data['contractValidTo'] = contractValidTo;
    return data;
  }
}
