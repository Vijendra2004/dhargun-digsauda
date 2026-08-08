class QuantityAllocationCreateReq {
  int? id;
  String? encryptedId;
  int? verticleId;
  int? salesOrganizationId;
  int? distributionChannelId;
  int? oilTypeId;
  String? oilTypeName;
  String? oilTypeCode;
  int? skuId;
  String? skuName;
  String? skuCode;
  List<int>? customerId;
  String? customerName;
  double? quantityLimit;
  double? actualDiscount;
  int? requestedQuantityLimit;
  int? loginUserId;
  bool? isActive;
  bool? postStatus;
  String? postMessage;
  int? discountType;
  dynamic remainingQuantity;
  int? parentQuantityId;
  int? parentId;
  List<int>? skuIds;
  String? subCategoryId;
  double? empActualDiscount;
  double? remainingQuantityHidden;
  String? validFrom;
  String? empValidFrom;
  String? empValidTo;
  String? validTo;
  String? employeeId;
  String? employeeName;

  QuantityAllocationCreateReq(
      {this.id,
        this.encryptedId,
        this.verticleId,
        this.empValidFrom,
        this.salesOrganizationId,
        this.remainingQuantity,
        this.distributionChannelId,
        this.oilTypeId,
        this.remainingQuantityHidden,
        this.actualDiscount,
        this.oilTypeName,
        this.oilTypeCode,
        this.skuId,
        this.skuName,
        this.skuCode,
        this.customerId,
        this.customerName,
        this.quantityLimit,
        this.requestedQuantityLimit,
        this.loginUserId,
        this.isActive,
        this.postStatus,
        this.postMessage,
        this.discountType,
        this.parentQuantityId,
        this.parentId,
        this.skuIds,
        this.empActualDiscount,
        this.subCategoryId,
        this.validFrom,
        this.validTo,
        this.employeeId,
        this.empValidTo,
        this.employeeName});

  QuantityAllocationCreateReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empValidFrom = json['empValidFrom'];
    encryptedId = json['encryptedId'];
    verticleId = json['verticleId'];
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    oilTypeCode = json['oilTypeCode'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    actualDiscount = json['actualDiscount'];
    customerId = json['customerId'].cast<int>();
    customerName = json['customerName'];
    quantityLimit = json['quantityLimit'];
    requestedQuantityLimit = json['requestedQuantityLimit'];
    loginUserId = json['loginUserId'];
    isActive = json['isActive'];
    remainingQuantityHidden = json['remainingQuantityHidden'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    discountType = json['discountType'];
    remainingQuantity = json['remainingQuantity'];
    parentQuantityId = json['parentQuantityId'];
    parentId = json['parentId'];
    skuIds = json['skuIds'].cast<int>();
    subCategoryId = json['subCategoryId'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    employeeId = json['employeeId'];
    empActualDiscount = json['empActualDiscount'];
    empValidTo = json['empValidTo'];
    employeeName = json['employeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['encryptedId'] = this.encryptedId;
    //
    // data['oilTypeName'] = this.oilTypeName;
    // data['oilTypeCode'] = this.oilTypeCode;
    //
    // data['skuName'] = this.skuName;
    // data['skuCode'] = this.skuCode;
    // data['customerName'] = this.customerName;
    // data['requestedQuantityLimit'] = this.requestedQuantityLimit;
    // data['isActive'] = this.isActive;
    // data['postStatus'] = this.postStatus;
    // data['postMessage'] = this.postMessage;
    // data['discountType'] = this.discountType;
    // data['remainingQuantity'] = this.remainingQuantity;
    // data['parentQuantityId'] = this.parentQuantityId;
    // data['parentId'] = this.parentId;
    // data['subCategoryId'] = this.subCategoryId;
    // data['employeeId'] = this.employeeId;
    // data['employeeName'] = this.employeeName;
    // data['skuId'] = this.skuId;
    // data['skuIds'] = this.skuIds;

    data['id'] = this.id??0;
    data['loginUserId'] = this.loginUserId;
    data['empValidFrom'] = this.empValidFrom;
    data['empValidTo'] = this.empValidTo;
    data['verticleId'] = this.verticleId;
    data['salesOrganizationId'] = this.salesOrganizationId;
    data['distributionChannelId'] = this.distributionChannelId;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    data['oilTypeId'] = this.oilTypeId;
    data['quantityLimit'] = this.quantityLimit;
    data['actualDiscount'] = this.actualDiscount;
    data['empActualDiscount'] = this.empActualDiscount;
    data['customerId'] = this.customerId;
    data['remainingQuantityHidden'] = this.remainingQuantityHidden;


    return data;
  }
}
