class UserDiscountRequest {
  int? id;
  String? discountReason;
  List<int>? skuIds;
  List<int>? customerId;
  List<int>? stateIds;
  double? actualDiscount;
  int? loginUserId;
  String? validFrom;
  String? validTo;

  UserDiscountRequest(
      {this.id,
        this.discountReason,
        this.skuIds,
        this.customerId,
        this.stateIds,
        this.actualDiscount,
        this.loginUserId,
        this.validFrom,
        this.validTo});

  UserDiscountRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    discountReason = json['DiscountReason'];
    skuIds = json['SkuIds'].cast<int>();
    customerId = json['CustomerId'].cast<int>();
    stateIds = json['stateIds'].cast<int>();
    actualDiscount = json['ActualDiscount'];
    loginUserId = json['LoginUserId'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = id;
    data['DiscountReason'] = discountReason;
    data['SkuIds'] = skuIds;
    data['CustomerId'] = customerId;
    data['stateIds'] = stateIds;
    data['ActualDiscount'] = actualDiscount;
    data['LoginUserId'] = loginUserId;
    data['ValidFrom'] = validFrom;
    data['ValidTo'] = validTo;
    return data;
  }
}


class AssignedDiscountRequest {
  int? id;
  String? discountReason;
  List<int>? skuIds;
  List<int>? customerId;
  List<int>? stateIds;
  double? actualDiscount;
  int? loginUserId;
  int? stateId;
  String? validFrom;
  String? validTo;

  AssignedDiscountRequest(
      {this.id,
        this.discountReason,
        this.skuIds,
        this.customerId,
        this.stateIds,
        this.actualDiscount,
        this.loginUserId,
        this.validFrom,
        this.validTo,this.stateId});

  AssignedDiscountRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    discountReason = json['DiscountReason'];
    skuIds = json['SkuIds'].cast<int>();
    customerId = json['CustomerId'].cast<int>();
    stateIds = json['stateIds'].cast<int>();
    actualDiscount = json['ActualDiscount'];
    loginUserId = json['LoginUserId'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
    stateId = json['StateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = id;
    data['DiscountReason'] = discountReason;
    data['SkuIds'] = skuIds;
    data['CustomerId'] = customerId;
    data['stateIds'] = stateIds;
    data['EmpActualDiscount'] = actualDiscount;
    data['LoginUserId'] = loginUserId;
    data['EmpValidFrom'] = validFrom;
    data['EmpValidTo'] = validTo;
    data['StateId'] = stateId;
    return data;
  }
}