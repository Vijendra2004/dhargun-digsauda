class SpecialRateView {
  int? dealerId;
  String? dealerName;
  String? requestDate;
  String? status;
  int? statusId;
  String? remarks;
  String? saudaLimitExceedRemarks;
  bool? isAccessToApprove;
  List<SpecialRateSkuDetail>? skuList;

  SpecialRateView(
      {this.dealerId,
      this.dealerName,
      this.requestDate,
      this.status,
      this.statusId,
      this.remarks,
      this.saudaLimitExceedRemarks,
      this.isAccessToApprove,
      this.skuList});

  SpecialRateView.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    requestDate = json['requestDate'];
    status = json['status'];
    statusId = json['statusId'];
    remarks = json['remarks'];
    saudaLimitExceedRemarks = json['saudaLimitExceedRemarks'];
    isAccessToApprove = json['isAccessToApprove'];
    if (json['skuList'] != null) {
      skuList = <SpecialRateSkuDetail>[];
      json['skuList'].forEach((v) {
        skuList!.add(SpecialRateSkuDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['requestDate'] = requestDate;
    data['status'] = status;
    data['statusId'] = statusId;
    data['remarks'] = remarks;
    data['saudaLimitExceedRemarks'] = saudaLimitExceedRemarks;
    data['isAccessToApprove'] = isAccessToApprove;
    if (skuList != null) {
      data['skuList'] = skuList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialRateSkuDetail {
  int? specialRateId;
  int? skuId;
  String? skuName;
  double? quantity;
  double? quantityCase;
  double? finalPrice;
  double? specialPrice;
  double? liftedDate;
  double? impactOnMarginMT;
  double? impactOnMarginCase;
  String? incotermsName;
  bool? isRake;
  String? dealerLocationName;
  String? plantName;
  double? caseToMetricTonValue;
  bool? isLTD;

  SpecialRateSkuDetail(
      {this.specialRateId,
      this.skuId,
      this.skuName,
      this.quantity,
      this.quantityCase,
      this.finalPrice,
      this.specialPrice,
      this.liftedDate,
      this.impactOnMarginMT,
      this.impactOnMarginCase,
      this.incotermsName,
      this.isRake,
      this.dealerLocationName,
      this.plantName,
      this.caseToMetricTonValue,
      this.isLTD});

  SpecialRateSkuDetail.fromJson(Map<String, dynamic> json) {
    specialRateId = json['specialRateId'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    quantity = json['quantity'];
    quantityCase = json['quantityCase'];
    finalPrice = json['finalPrice'];
    specialPrice = json['specialPrice'];
    liftedDate = json['liftedDate'];
    impactOnMarginMT = json['impactOnMarginMT'];
    impactOnMarginCase = json['impactOnMarginCase'];
    incotermsName = json['incotermsName'];
    isRake = json['isRake'];
    dealerLocationName = json['dealerLocationName'];
    plantName = json['plantName'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    isLTD = json['isLTD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialRateId'] = specialRateId;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['quantity'] = quantity;
    data['quantityCase'] = quantityCase;
    data['finalPrice'] = finalPrice;
    data['specialPrice'] = specialPrice;
    data['liftedDate'] = liftedDate;
    data['impactOnMarginMT'] = impactOnMarginMT;
    data['impactOnMarginCase'] = impactOnMarginCase;
    data['incotermsName'] = incotermsName;
    data['isRake'] = isRake;
    data['dealerLocationName'] = dealerLocationName;
    data['plantName'] = plantName;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['isLTD'] = isLTD;
    return data;
  }
}

class SpecialRateResponse {
  int? dealerId;
  String? dealerName;
  List<SpecialRateList>? specialRateList;

  SpecialRateResponse({this.dealerId, this.dealerName, this.specialRateList});

  SpecialRateResponse.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    if (json['specialRateList'] != null) {
      specialRateList = <SpecialRateList>[];
      json['specialRateList'].forEach((v) {
        specialRateList!.add(SpecialRateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    if (specialRateList != null) {
      data['specialRateList'] =
          specialRateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialRateList {
  int? specialRateId;
  String? requestDate;
  int? dealerId;
  String? dealerName;
  int? statusId;
  String? statusName;
  bool? isBroker;
  bool? isLTD;
  double? specialPrice;
  int? skuId;
  String? skuName;
  double? quantity;
  double? discountOrPremium;
  int? createdBy;
  double? discountAmountInConfiguration;
  List<SpecialRateOilTypeList>? oilTypeList;
  bool? isError = false;
  bool? isApproved = false;

  SpecialRateList(
      {this.specialRateId,
      this.requestDate,
      this.dealerId,
      this.dealerName,
      this.statusId,
      this.statusName,
      this.isBroker,
      this.isLTD,
      this.specialPrice,
      this.skuId,
      this.skuName,
      this.quantity,
      this.discountOrPremium,
      this.createdBy,
      this.discountAmountInConfiguration,
      this.oilTypeList,
      this.isApproved = false,
      this.isError = false});

  SpecialRateList.fromJson(Map<String, dynamic> json) {
    specialRateId = json['specialRateId'];
    requestDate = json['requestDate'];
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    statusId = json['statusId'];
    statusName = json['statusName'];
    isBroker = json['isBroker'];
    isLTD = json['isLTD'];
    specialPrice = json['specialPrice'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    quantity = json['quantity'];
    discountOrPremium = json['discountOrPremium'];
    createdBy = json['createdBy'];
    discountAmountInConfiguration = json['discountAmountInConfiguration'];
    if (json['oilTypeList'] != null) {
      oilTypeList = <SpecialRateOilTypeList>[];
      json['oilTypeList'].forEach((v) {
        oilTypeList!.add(SpecialRateOilTypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialRateId'] = specialRateId;
    data['requestDate'] = requestDate;
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['statusId'] = statusId;
    data['statusName'] = statusName;
    data['isBroker'] = isBroker;
    data['isLTD'] = isLTD;
    data['specialPrice'] = specialPrice;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['quantity'] = quantity;
    data['discountOrPremium'] = discountOrPremium;
    data['createdBy'] = createdBy;
    data['discountAmountInConfiguration'] = discountAmountInConfiguration;
    if (oilTypeList != null) {
      data['oilTypeList'] = oilTypeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialRateOilTypeList {
  int? oilTypeId;
  String? oilTypeName;
  int? skuCount;
  int? skuId;
  String? skuName;

  SpecialRateOilTypeList(
      {this.oilTypeId,
      this.oilTypeName,
      this.skuCount,
      this.skuId,
      this.skuName});

  SpecialRateOilTypeList.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    skuCount = json['skuCount'];
    skuId = json['skuId'];
    skuName = json['skuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    data['skuCount'] = skuCount;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    return data;
  }
}
