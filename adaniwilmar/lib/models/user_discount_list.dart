class UserDiscountListRequest {
  int? id;
  String? encryptedId;
  int? salesOrganizationId;
  String? salesOrganization;
  int? distributionChannelId;
  String? distributionChannel;
  int? divisionId;
  String? division;
  String? discountReason;
  int? oilTypeId;
  String? oilTypeName;
  String? oilTypeCode;
  int? skuId;
  List<int>? skuIds;
  String? subCategoryId;
  int? oilPackingTypeId;
  String? oilPackingType;
  String? skuName;
  String? skuCode;
  List<int>? customerId;
  String? customerName;
  List<int>? stateIds;
  double? actualDiscount;
  int? loginUserId;
  bool? isActive;
  bool? postStatus;
  String? postMessage;
  String? validFrom;
  String? validTo;
  String? parentValidFrom;
  String? parentValidTo;
  double? parentDiscountAmount;
  bool? isProcessed;
  String? skuDetails;

  UserDiscountListRequest(
      {this.id,
        this.encryptedId,
        this.salesOrganizationId,
        this.salesOrganization,
        this.distributionChannelId,
        this.distributionChannel,
        this.divisionId,
        this.division,
        this.discountReason,
        this.oilTypeId,
        this.oilTypeName,
        this.oilTypeCode,
        this.skuId,
        this.skuIds,
        this.subCategoryId,
        this.oilPackingTypeId,
        this.oilPackingType,
        this.skuName,
        this.skuCode,
        this.customerId,
        this.customerName,
        this.stateIds,
        this.actualDiscount,
        this.loginUserId,
        this.isActive,
        this.postStatus,
        this.postMessage,
        this.validFrom,
        this.validTo,
        this.parentValidFrom,
        this.parentValidTo,
        this.parentDiscountAmount,
        this.isProcessed,
        this.skuDetails});

  UserDiscountListRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedId = json['encryptedId'];
    salesOrganizationId = json['salesOrganizationId'];
    salesOrganization = json['salesOrganization'];
    distributionChannelId = json['distributionChannelId'];
    distributionChannel = json['distributionChannel'];
    divisionId = json['divisionId'];
    division = json['division'];
    discountReason = json['discountReason'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    oilTypeCode = json['oilTypeCode'];
    skuId = json['skuId'];
    skuIds = json['skuIds'].cast<int>();
    subCategoryId = json['subCategoryId'];
    oilPackingTypeId = json['oilPackingTypeId'];
    oilPackingType = json['oilPackingType'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    customerId = json['customerId'].cast<int>();
    customerName = json['customerName'];
    stateIds = json['stateIds'].cast<int>();
    actualDiscount = json['actualDiscount'];
    loginUserId = json['loginUserId'];
    isActive = json['isActive'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    parentValidFrom = json['parentValidFrom'];
    parentValidTo = json['parentValidTo'];
    parentDiscountAmount = json['parentDiscountAmount'];
    isProcessed = json['isProcessed'];
    skuDetails = json['skuDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['encryptedId'] = encryptedId;
    data['salesOrganizationId'] = salesOrganizationId;
    data['salesOrganization'] = salesOrganization;
    data['distributionChannelId'] = distributionChannelId;
    data['distributionChannel'] = distributionChannel;
    data['divisionId'] = divisionId;
    data['division'] = division;
    data['discountReason'] = discountReason;
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    data['oilTypeCode'] = oilTypeCode;
    data['skuId'] = skuId;
    data['skuIds'] = skuIds;
    data['subCategoryId'] = subCategoryId;
    data['oilPackingTypeId'] = oilPackingTypeId;
    data['oilPackingType'] = oilPackingType;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['stateIds'] = stateIds;
    data['actualDiscount'] = actualDiscount;
    data['loginUserId'] = loginUserId;
    data['isActive'] = isActive;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['validFrom'] = validFrom;
    data['validTo'] = validTo;
    data['parentValidFrom'] = parentValidFrom;
    data['parentValidTo'] = parentValidTo;
    data['parentDiscountAmount'] = parentDiscountAmount;
    data['isProcessed'] = isProcessed;
    data['skuDetails'] = skuDetails;
    return data;
  }
}

class UserDiscountDetails {
  int? id;
  int? userId;
  String? employeeName;
  String? email;
  String? mobileNumber;
  List<DiscountList>? discountList;

  UserDiscountDetails(
      {this.id,
        this.userId,
        this.employeeName,
        this.email,
        this.mobileNumber,
        this.discountList});

  UserDiscountDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    employeeName = json['employeeName'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    if (json['discountList'] != null) {
      discountList = <DiscountList>[];
      json['discountList'].forEach((v) {
        discountList!.add(new DiscountList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['employeeName'] = this.employeeName;
    data['email'] = this.email;
    data['mobileNumber'] = this.mobileNumber;
    if (this.discountList != null) {
      data['discountList'] = this.discountList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiscountList {
  int? id;
  int? salesOrganizationId;
  String? salesOrganization;
  int? distributionChannelId;
  String? distributionChannel;
  int? divisionId;
  String? division;
  String? discountReason;
  int? skuId;
  String? skuName;
  String? skuCode;
  int? oilTypeId;
  String? oilTypeName;
  int? employeeId;
  String? employeeName;
  int? stateId;
  String? stateName;
  String? email;
  String? mobileNumber;
  String? designation;
  double? discount;
  String? validFrom;
  String? validTo;

  DiscountList(
      {this.id,
        this.salesOrganizationId,
        this.salesOrganization,
        this.distributionChannelId,
        this.distributionChannel,
        this.divisionId,
        this.division,
        this.discountReason,
        this.skuId,
        this.skuName,
        this.skuCode,
        this.oilTypeId,
        this.oilTypeName,
        this.employeeId,
        this.employeeName,
        this.stateId,
        this.stateName,
        this.email,
        this.mobileNumber,
        this.designation,
        this.discount,
        this.validFrom,
        this.validTo});

  DiscountList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrganizationId = json['salesOrganizationId'];
    salesOrganization = json['salesOrganization'];
    distributionChannelId = json['distributionChannelId'];
    distributionChannel = json['distributionChannel'];
    divisionId = json['divisionId'];
    division = json['division'];
    discountReason = json['discountReason'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    designation = json['designation'];
    discount = json['discount'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salesOrganizationId'] = this.salesOrganizationId;
    data['salesOrganization'] = this.salesOrganization;
    data['distributionChannelId'] = this.distributionChannelId;
    data['distributionChannel'] = this.distributionChannel;
    data['divisionId'] = this.divisionId;
    data['division'] = this.division;
    data['discountReason'] = this.discountReason;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['skuCode'] = this.skuCode;
    data['oilTypeId'] = this.oilTypeId;
    data['oilTypeName'] = this.oilTypeName;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['stateId'] = this.stateId;
    data['stateName'] = this.stateName;
    data['email'] = this.email;
    data['mobileNumber'] = this.mobileNumber;
    data['designation'] = this.designation;
    data['discount'] = this.discount;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    return data;
  }
}