class SpecialRateApprovals {
  int? loginUserId;
  int? userId;
  int? oilTypeId;
  int? skuId;
  int? ricingId;
  double? quantity;
  double? finalPrice;
  double? specialPrice;
  int? incotermsId;
  int? plantId;
  bool? isLTD;
  int? brokerId;

  SpecialRateApprovals(
      {this.loginUserId,
      this.userId,
      this.oilTypeId,
      this.skuId,
      this.ricingId,
      this.quantity,
      this.finalPrice,
      this.specialPrice,
      this.incotermsId,
      this.plantId,
      this.isLTD,
      this.brokerId});

  SpecialRateApprovals.fromJson(Map<String, dynamic> json) {
    loginUserId = json['loginUserId'];
    userId = json['userId'];
    oilTypeId = json['oilTypeId'];
    skuId = json['skuId'];
    ricingId = json['ricingId'];
    quantity = json['quantity'];
    finalPrice = json['finalPrice'];
    specialPrice = json['specialPrice'];
    incotermsId = json['incotermsId'];
    plantId = json['plantId'];
    isLTD = json['isLTD'];
    brokerId = json['brokerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginUserId'] = loginUserId;
    data['userId'] = userId;
    data['oilTypeId'] = oilTypeId;
    data['skuId'] = skuId;
    data['ricingId'] = ricingId;
    data['quantity'] = quantity;
    data['finalPrice'] = finalPrice;
    data['specialPrice'] = specialPrice;
    data['incotermsId'] = incotermsId;
    data['plantId'] = plantId;
    data['isLTD'] = isLTD;
    data['brokerId'] = brokerId;
    return data;
  }
}

class SpecialRateSearchInput {
  int? loginUserId;
  int? dealerId;
  int? oilTypeId;
  String? fromDate;
  String? toDate;

  SpecialRateSearchInput(
      {this.loginUserId,
      this.dealerId,
      this.oilTypeId,
      this.fromDate,
      this.toDate});

  SpecialRateSearchInput.fromJson(Map<String, dynamic> json) {
    loginUserId = json['loginUserId'];
    dealerId = json['dealerId'];
    oilTypeId = json['oilTypeId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginUserId'] = loginUserId;
    data['dealerId'] = dealerId;
    data['oilTypeId'] = oilTypeId;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    return data;
  }
}

class SpecialRate {
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
  List<SkuDetail>? oilTypeList;

  SpecialRate(
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
      this.oilTypeList});

  SpecialRate.fromJson(Map<String, dynamic> json) {
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
      oilTypeList = <SkuDetail>[];
      json['oilTypeList'].forEach((v) {
        oilTypeList!.add(SkuDetail.fromJson(v));
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

class SkuDetail {
  int? oilTypeId;
  String? oilTypeName;
  int? skuId;
  String? skuName;

  SkuDetail({this.oilTypeId, this.oilTypeName, this.skuId, this.skuName});

  SkuDetail.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    skuId = json['skuId'];
    skuName = json['skuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    return data;
  }
}

class SpecialRateRequest {
  int? bDOId;
  List<SpecialRateApproval>? specialRateApprovals;

  SpecialRateRequest({this.bDOId, this.specialRateApprovals});

  SpecialRateRequest.fromJson(Map<String, dynamic> json) {
    bDOId = json['BDOId'];
    if (json['SpecialRateApprovals'] != null) {
      specialRateApprovals = <SpecialRateApproval>[];
      json['SpecialRateApprovals'].forEach((v) {
        specialRateApprovals!.add(SpecialRateApproval.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BDOId'] = bDOId;
    if (specialRateApprovals != null) {
      data['SpecialRateApprovals'] =
          specialRateApprovals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialRateApproval {
  double? finalPrice;
  int? incotermsId;
  int? loginUserId;
  int? oilTypeId;
  int? plantId;
  int? pricingId;
  double? quantity;
  int? skuId;
  double? specialPrice;
  int? userId;
  int? salesOrganizationId;
  int? distributionChannelId;
  int? divisionId;
  String? skuName;

  SpecialRateApproval(
      {this.finalPrice,
      this.incotermsId,
      this.loginUserId,
      this.oilTypeId,
      this.plantId,
      this.pricingId,
      this.quantity,
      this.skuId,
      this.specialPrice,
      this.userId,
      this.salesOrganizationId,
      this.distributionChannelId,
      this.divisionId,
      this.skuName});

  SpecialRateApproval.fromJson(Map<String, dynamic> json) {
    finalPrice = json['FinalPrice'];
    incotermsId = json['incotermsId'];
    loginUserId = json['LoginUserId'];
    oilTypeId = json['OilTypeId'];
    plantId = json['plantId'];
    pricingId = json['pricingId'];
    quantity = json['Quantity'];
    skuId = json['SkuId'];
    specialPrice = json['SpecialPrice'];
    userId = json['UserId'];
    salesOrganizationId = json['SalesOrganizationId'];
    distributionChannelId = json['DistributionChannelId'];
    divisionId = json['DivisionId'];
    skuName = json['SkuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FinalPrice'] = finalPrice;
    data['incotermsId'] = incotermsId;
    data['LoginUserId'] = loginUserId;
    data['OilTypeId'] = oilTypeId;
    data['plantId'] = plantId;
    data['pricingId'] = pricingId;
    data['Quantity'] = quantity;
    data['SkuId'] = skuId;
    data['SpecialPrice'] = specialPrice;
    data['UserId'] = userId;
    data['SalesOrganizationId'] = salesOrganizationId;
    data['DistributionChannelId'] = distributionChannelId;
    data['DivisionId'] = divisionId;
    data['SkuName'] = skuName;
    return data;
  }
}


class SpecialRateManagerRequest {
  int? loginUserId;
  int? statusId;
  String? remarks;
  int? salesOrganizationId;
  int? distributionChannelId;
  int? divisionId;
  List<SpecialRateIdInfo>? specialRateIdInfo;

  SpecialRateManagerRequest(
      {this.loginUserId,
        this.statusId,
        this.remarks,
        this.salesOrganizationId,
        this.distributionChannelId,
        this.divisionId,
        this.specialRateIdInfo});

  SpecialRateManagerRequest.fromJson(Map<String, dynamic> json) {
    loginUserId = json['LoginUserId'];
    statusId = json['StatusId'];
    remarks = json['Remarks'];
    salesOrganizationId = json['SalesOrganizationId'];
    distributionChannelId = json['DistributionChannelId'];
    divisionId = json['DivisionId'];
    if (json['SpecialRateIdInfo'] != null) {
      specialRateIdInfo = <SpecialRateIdInfo>[];
      json['SpecialRateIdInfo'].forEach((v) {
        specialRateIdInfo!.add(new SpecialRateIdInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserId'] = this.loginUserId;
    data['StatusId'] = this.statusId;
    data['Remarks'] = this.remarks;
    data['SalesOrganizationId'] = this.salesOrganizationId;
    data['DistributionChannelId'] = this.distributionChannelId;
    data['DivisionId'] = this.divisionId;
    if (this.specialRateIdInfo != null) {
      data['SpecialRateIdInfo'] =
          this.specialRateIdInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class SpecialRateIdInfo {
//   int? specialRateIds;
//   String? saudaValidFromDate;
//
//   SpecialRateIdInfo({this.specialRateIds, this.saudaValidFromDate});
//
//   SpecialRateIdInfo.fromJson(Map<String, dynamic> json) {
//     specialRateIds = json['SpecialRateIds'];
//     saudaValidFromDate = json['SaudaValidFromDate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['SpecialRateIds'] = this.specialRateIds;
//     data['SaudaValidFromDate'] = this.saudaValidFromDate;
//     return data;
//   }
// }

class SpecialRateIdInfo {
  double? quantityInCases;
  int? dealerId;
  int? specialRateIds;

  SpecialRateIdInfo({this.quantityInCases, this.dealerId, this.specialRateIds});

  SpecialRateIdInfo.fromJson(Map<String, dynamic> json) {
    quantityInCases = json['quantityInCases'];
    dealerId = json['dealerId'];
    specialRateIds = json['specialRateIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantityInCases'] = this.quantityInCases;
    data['dealerId'] = this.dealerId;
    data['specialRateIds'] = this.specialRateIds;
    return data;
  }
}
