class QAListModel {
  List<QAListResponseValue>? response;
  String? message;

  QAListModel({this.response, this.message});

  QAListModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <QAListResponseValue>[];
      json['response'].forEach((v) {
        response!.add(new QAListResponseValue.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class QAListResponseValue {
  int? id;
  String? encryptedId;
  String? salesOrganizationName;
  int? verticleId;
  int? salesOrganizationId;
  int? distributionChannelId;
  int? oilTypeId;
  String? oilTypeName;
  String? oilTypeCode;
  int? skuId;
  String? skuName;
  String? skuCode;
  String? customerId;
  String? customerName;
  double? quantityLimit;
  double? quantity;
  double? actualDiscount;
  double? requestedQuantityLimit;
  int? loginUserId;
  bool? isActive;
  bool? postStatus;
  bool? isRequestedUser;
  String? postMessage;
  int? discountType;
  int? statusId;
  double? remainingQuantity;
  int? parentQuantityId;
  int? parentId;
  String? skuIds;
  String? subCategoryId;
  String? validFrom;
  String? validTo;
  String? createdBy;
  String? status;
  int? employeeId;
  String? employeeName;
  String? distributionChannelName;
  String? divisionName;
  String? skuDetails;

  QAListResponseValue(
      {this.id,
        this.encryptedId,
        this.verticleId,
        this.quantity,
        this.status,
        this.statusId,
        this.actualDiscount,
        this.salesOrganizationName,
        this.salesOrganizationId,
        this.distributionChannelId,
        this.oilTypeId,
        this.isRequestedUser,
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
        this.remainingQuantity,
        this.parentQuantityId,
        this.parentId,
        this.skuIds,
        this.subCategoryId,
        this.validFrom,
        this.distributionChannelName,
        this.validTo,
        this.employeeId,
        this.divisionName,
        this.createdBy,
        this.employeeName,
        this.skuDetails});

  QAListResponseValue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedId = json['encryptedId'];
    verticleId = json['verticleId'];
    status = json['status'];
    statusId = json['statusId'];
    isRequestedUser = json['isRequestedUser'];
    quantity = json['quantity'];
    salesOrganizationName = json['salesOrganizationName'];
    actualDiscount = json['actualDiscount'];
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    oilTypeCode = json['oilTypeCode'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    divisionName = json['divisionName'];
    if((json['customerId']??"") is String)
      {
        customerId = json['customerId'];
      }
    else
      {
        customerId = json['customerId'].join(', ');
      }

    customerName = json['customerName'];
    quantityLimit = json['quantityLimit'];
    requestedQuantityLimit = json['requestedQuantityLimit'];
    loginUserId = json['loginUserId'];
    isActive = json['isActive'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    discountType = json['discountType'];
    remainingQuantity = json['remainingQuantity'];
    parentQuantityId = json['parentQuantityId'];
    parentId = json['parentId'];
    createdBy = json['createdBy'];
    if((json['customerId']??"") is String)
    {
      skuIds = json['skuIds'];
    }
    else
    {
      skuIds = json['skuIds'].join(', ');

    }

    subCategoryId = json['subCategoryId'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    skuDetails = json['skuDetails'];
    distributionChannelName = json['distributionChannelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['encryptedId'] = this.encryptedId;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['isRequestedUser'] = this.isRequestedUser;
    data['verticleId'] = this.verticleId;
    data['divisionName'] = this.divisionName;
    data['salesOrganizationId'] = this.salesOrganizationId;
    data['distributionChannelId'] = this.distributionChannelId;
    data['oilTypeId'] = this.oilTypeId;
    data['salesOrganizationName'] = this.salesOrganizationName;
    data['distributionChannelName'] = this.distributionChannelName;
    data['oilTypeName'] = this.oilTypeName;
    data['oilTypeCode'] = this.oilTypeCode;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['quantity'] = this.quantity;
    data['skuCode'] = this.skuCode;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['quantityLimit'] = this.quantityLimit;
    data['requestedQuantityLimit'] = this.requestedQuantityLimit;
    data['loginUserId'] = this.loginUserId;
    data['isActive'] = this.isActive;
    data['postStatus'] = this.postStatus;
    data['postMessage'] = this.postMessage;
    data['discountType'] = this.discountType;
    data['remainingQuantity'] = this.remainingQuantity;
    data['parentQuantityId'] = this.parentQuantityId;
    data['parentId'] = this.parentId;
    data['skuIds'] = this.skuIds;
    data['subCategoryId'] = this.subCategoryId;
    data['actualDiscount'] = this.actualDiscount;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['skuDetails'] = this.skuDetails;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
