class DailySFQuantityAllocation {
  int? id;
  int? skuId;
  String? skuName;
  String? skuCode;
  double? quantity;

  DailySFQuantityAllocation(
      {this.id, this.skuId, this.skuName, this.skuCode, this.quantity});

  DailySFQuantityAllocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['quantity'] = quantity;
    return data;
  }
}

class SpecialtyFatQuantityRequestsList {
  List<int>? quantityRequestIds;
  int? id;
  int? userId;
  int? skuId;
  int? oiltypeId;
  double? quantity;
  int? statusId;
  int? specialtyFatQuantityLimitId;
  String? skuName;
  String? skuCode;
  String? userName;
  String? oilTypeName;
  String? status;
  int? loginUserId;
  double? remainingQuantity;
  int? parentQuantityId;
  bool? isChecked;
  bool? isRequestedUser;
  int? specialtyFatQuantityRequestId;
  int? roleId;
  bool? isApprove;
  bool? postStatus;
  String? postMessage;
  String? remarks;
  String? createdBy;
  int? verticleId;

  SpecialtyFatQuantityRequestsList(
      {this.quantityRequestIds,
      this.id,
      this.userId,
      this.skuId,
      this.oiltypeId,
      this.quantity,
      this.statusId,
      this.specialtyFatQuantityLimitId,
      this.skuName,
      this.skuCode,
      this.userName,
      this.oilTypeName,
      this.status,
      this.loginUserId,
      this.remainingQuantity,
      this.parentQuantityId,
      this.isChecked,
      this.isRequestedUser,
      this.specialtyFatQuantityRequestId,
      this.roleId,
      this.isApprove,
      this.postStatus,
      this.postMessage,
      this.remarks,
      this.createdBy,
      this.verticleId});

  SpecialtyFatQuantityRequestsList.fromJson(Map<String, dynamic> json) {
    if (json['quantityRequestIds'] != null) {
      quantityRequestIds = json['quantityRequestIds'].cast<int>();
    }
    id = json['id'];
    userId = json['userId'];
    skuId = json['skuId'];
    oiltypeId = json['oiltypeId'];
    quantity = json['quantity'];
    statusId = json['statusId'];
    specialtyFatQuantityLimitId = json['specialtyFatQuantityLimitId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    userName = json['userName'];
    oilTypeName = json['oilTypeName'];
    status = json['status'];
    loginUserId = json['loginUserId'];
    remainingQuantity = json['remainingQuantity'];
    parentQuantityId = json['parentQuantityId'];
    isChecked = json['isChecked'];
    isRequestedUser = json['isRequestedUser'];
    specialtyFatQuantityRequestId = json['specialtyFatQuantityRequestId'];
    roleId = json['roleId'];
    isApprove = json['isApprove'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    verticleId = json['verticleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantityRequestIds'] = quantityRequestIds;
    data['id'] = id;
    data['userId'] = userId;
    data['skuId'] = skuId;
    data['oiltypeId'] = oiltypeId;
    data['quantity'] = quantity;
    data['statusId'] = statusId;
    data['specialtyFatQuantityLimitId'] = specialtyFatQuantityLimitId;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['userName'] = userName;
    data['oilTypeName'] = oilTypeName;
    data['status'] = status;
    data['loginUserId'] = loginUserId;
    data['remainingQuantity'] = remainingQuantity;
    data['parentQuantityId'] = parentQuantityId;
    data['isChecked'] = isChecked;
    data['isRequestedUser'] = isRequestedUser;
    data['specialtyFatQuantityRequestId'] = specialtyFatQuantityRequestId;
    data['roleId'] = roleId;
    data['isApprove'] = isApprove;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['remarks'] = remarks;
    data['createdBy'] = createdBy;
    data['verticleId'] = verticleId;
    return data;
  }
}

//NH Quantity Request
class QuantityRequestList {
  int? id;
  int? verticleId;
  int? oilTypeId;
  String? oilTypeName;
  String? oilTypeCode;
  int? skuId;
  String? skuName;
  String? skuCode;
  int? customerId;
  String? customerName;
  double? quantityLimit;
  double? requestedQuantityLimit;
  int? loginUserId;
  bool? isActive;
  bool? postStatus;
  String? postMessage;
  int? discountType;
  double? remainingQuantity;
  int? parentQuantityId;
  int? parentId;
  String? skuIds;
  int? subCategoryId;
  String? validFrom;
  String? validTo;
  int? employeeId;
  String? employeeName;
  String? skuDetails;
  double? actualQuantity;

  QuantityRequestList(
      {this.id,
        this.verticleId,
        this.oilTypeId,
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
        this.validTo,
        this.employeeId,
        this.employeeName,
        this.skuDetails,
        this.actualQuantity});

  QuantityRequestList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    verticleId = json['verticleId'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    oilTypeCode = json['oilTypeCode'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    customerId = json['customerId'];
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
    skuIds = json['skuIds'];
    subCategoryId = json['subCategoryId'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    skuDetails = json['skuDetails'];
    actualQuantity = json['actualQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['verticleId'] = this.verticleId;
    data['oilTypeId'] = this.oilTypeId;
    data['oilTypeName'] = this.oilTypeName;
    data['oilTypeCode'] = this.oilTypeCode;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
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
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['skuDetails'] = this.skuDetails;
    data['actualQuantity'] = this.actualQuantity;
    return data;
  }
}

class CreateQuantityLimitRequest {
  List<int>? skuIds;
  List<int>? customerId;
  int? loginUserId;
  int? oilTypeId;
  double? quantityLimit;
  String? validFrom;
  String? validTo;

  CreateQuantityLimitRequest(
      {this.skuIds,
        this.customerId,
        this.loginUserId,
        this.oilTypeId,
        this.quantityLimit,
        this.validFrom,
        this.validTo});

  CreateQuantityLimitRequest.fromJson(Map<String, dynamic> json) {
    skuIds = json['SkuIds'].cast<int>();
    customerId = json['CustomerId'].cast<int>();
    loginUserId = json['LoginUserId'];
    oilTypeId = json['OilTypeId'];
    quantityLimit = json['QuantityLimit'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SkuIds'] = this.skuIds;
    data['CustomerId'] = this.customerId;
    data['LoginUserId'] = this.loginUserId;
    data['OilTypeId'] = this.oilTypeId;
    data['QuantityLimit'] = this.quantityLimit;
    data['ValidFrom'] = this.validFrom;
    data['ValidTo'] = this.validTo;
    return data;
  }
}

class UpdateQuantityLimitRequest {
  int? loginUserId;
  double? actualDiscount;
  int? specialityFatDiscountId;

  UpdateQuantityLimitRequest(
      {this.loginUserId,
        this.actualDiscount,
        this.specialityFatDiscountId});

  UpdateQuantityLimitRequest.fromJson(Map<String, dynamic> json) {
    loginUserId = json['LoginUserId'];
    specialityFatDiscountId = json['specialityFatDiscountId'];
    actualDiscount = json['actualDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserId'] = this.loginUserId;
    data['SpecialityFatDiscountId'] = this.specialityFatDiscountId;
    data['ActualDiscount'] = this.actualDiscount;
    return data;
  }
}

class AllocateQuantityLimitRequest {
  List<int>? customerId;
  double? empActualDiscount;
  String? empValidFrom;
  String? empValidTo;
  int? id;
  int? loginUserId;
  int? oilTypeId;
  int? skuId;

  AllocateQuantityLimitRequest(
      {this.customerId,
        this.empActualDiscount,
        this.empValidFrom,
        this.empValidTo,
        this.id,
        this.loginUserId,
        this.oilTypeId,
        this.skuId});

  AllocateQuantityLimitRequest.fromJson(Map<String, dynamic> json) {
    customerId = json['CustomerId'].cast<int>();
    empActualDiscount = json['EmpActualDiscount'];
    empValidFrom = json['EmpValidFrom'];
    empValidTo = json['EmpValidTo'];
    id = json['Id'];
    loginUserId = json['LoginUserId'];
    oilTypeId = json['OilTypeId'];
    skuId = json['SkuId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerId'] = this.customerId;
    data['EmpActualDiscount'] = this.empActualDiscount;
    data['EmpValidFrom'] = this.empValidFrom;
    data['EmpValidTo'] = this.empValidTo;
    data['Id'] = this.id;
    data['LoginUserId'] = this.loginUserId;
    data['OilTypeId'] = this.oilTypeId;
    data['SkuId'] = this.skuId;
    return data;
  }
}

class AssignedQuantityLimitRequest {
  int? loginUserId;
  int? id;
  double? quantityLimit;

  AssignedQuantityLimitRequest({this.loginUserId, this.id, this.quantityLimit});

  AssignedQuantityLimitRequest.fromJson(Map<String, dynamic> json) {
    loginUserId = json['LoginUserId'];
    id = json['Id'];
    quantityLimit = json['QuantityLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserId'] = this.loginUserId;
    data['Id'] = this.id;
    data['QuantityLimit'] = this.quantityLimit;
    return data;
  }
}
