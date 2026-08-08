class AssignedDiscountListRequest {
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
  int? stateId;
  String? stateName;
  List<int>? skuIds;
  String? subCategoryId;
  int? oilPackingTypeId;
  String? oilPackingType;
  String? skuName;
  String? skuCode;
  List<int>? customerId;
  int? stateIds;
  String? customerName;
  double? actualDiscount;
  int? loginUserId;
  int? roleId;
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
  String? skuList;
  String? userList;

  AssignedDiscountListRequest(
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
        this.stateId,
        this.stateName,
        this.skuIds,
        this.subCategoryId,
        this.oilPackingTypeId,
        this.oilPackingType,
        this.skuName,
        this.skuCode,
        this.customerId,
        this.stateIds,
        this.customerName,
        this.actualDiscount,
        this.loginUserId,
        this.roleId,
        this.isActive,
        this.postStatus,
        this.postMessage,
        this.validFrom,
        this.validTo,
        this.parentValidFrom,
        this.parentValidTo,
        this.parentDiscountAmount,
        this.isProcessed,
        this.skuDetails,
        this.skuList,
        this.userList});

  AssignedDiscountListRequest.fromJson(Map<String, dynamic> json) {
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
    stateId = json['stateId'];
    stateName = json['stateName'];
    skuIds = json['skuIds'].cast<int>();
    subCategoryId = json['subCategoryId'];
    oilPackingTypeId = json['oilPackingTypeId'];
    oilPackingType = json['oilPackingType'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    customerId = json['customerId'].cast<int>();
    stateIds = json['stateIds'];
    customerName = json['customerName'];
    actualDiscount = json['actualDiscount'];
    loginUserId = json['loginUserId'];
    roleId = json['roleId'];
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
    skuList = json['skuList'];
    userList = json['userList'];
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
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['skuIds'] = skuIds;
    data['subCategoryId'] = subCategoryId;
    data['oilPackingTypeId'] = oilPackingTypeId;
    data['oilPackingType'] = oilPackingType;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['customerId'] = customerId;
    data['stateIds'] = stateIds;
    data['customerName'] = customerName;
    data['actualDiscount'] = actualDiscount;
    data['loginUserId'] = loginUserId;
    data['roleId'] = roleId;
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
    data['skuList'] = skuList;
    data['userList'] = userList;
    return data;
  }
}
