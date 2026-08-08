class SaudaExtension {
  int? saudaOrderId;
  int? pendingContractId;
  String? saudaNumber;
  String? saudaBookedDate;
  String? saudaValidToDate;
  String? saudaExtendedToDate;
  double? saudaQuantityMT;
  double? saudaQuantityCase;
  String? bookedSku;
  String? saudaExtendedDays;
  String? saudaRequestDate;
  double? basicRate;
  String? dealerName;
  double? saudaQuantityInMt;
  String? saudaValidFromDate;
  String? remarks;
  String? sapRemarks;
  bool? isApproval;
  String? bdoName;
  int? bdoId;
  int? dealerId;
  String? bdoAddress;
  String? dealerAddress;
  String? zonalHeadName;
  double? pendingQuantityMT;
  double? pendingQuantityCase;
  String? validFrom;
  String? validTo;
  int? id;
  bool? saudaExtensionUpdateFromSap;
  String? modifiedDate;
  bool? isSapDataSync;
  int? extendedDays;
  String? extendedToDate;
  bool? isSelected = false;
  bool? isExpanded = false;
  List<SaudaExtensionSkuList>? skuList;

  SaudaExtension(
      {this.saudaOrderId,
      this.pendingContractId,
      this.saudaNumber,
      this.saudaBookedDate,
      this.saudaValidToDate,
      this.saudaExtendedToDate,
      this.saudaQuantityMT,
      this.saudaQuantityCase,
      this.bookedSku,
      this.saudaExtendedDays,
      this.saudaRequestDate,
      this.basicRate,
      this.dealerName,
      this.saudaQuantityInMt,
      this.saudaValidFromDate,
      this.remarks,
      this.sapRemarks,
      this.isApproval,
      this.bdoName,
      this.bdoId,
      this.dealerId,
      this.bdoAddress,
      this.dealerAddress,
      this.zonalHeadName,
      this.pendingQuantityMT,
      this.pendingQuantityCase,
      this.validFrom,
      this.validTo,
      this.id,
      this.saudaExtensionUpdateFromSap,
      this.modifiedDate,
      this.isSapDataSync,
      this.extendedDays,
      this.extendedToDate,
      this.isSelected,
      this.isExpanded,
      this.skuList});

  SaudaExtension.fromJson(Map<String, dynamic> json) {
    saudaOrderId = json['saudaOrderId'];
    pendingContractId = json['pendingContractId'];
    saudaNumber = json['saudaNumber'];
    saudaBookedDate = json['saudaBookedDate'];
    saudaValidToDate = json['saudaValidToDate'];
    saudaExtendedToDate = json['saudaExtendedToDate'];
    saudaQuantityMT = json['saudaQuantityMT'];
    saudaQuantityCase = json['saudaQuantityCase'];
    bookedSku = json['bookedSku'];
    saudaExtendedDays = json['saudaExtendedDays'];
    saudaRequestDate = json['saudaRequestDate'];
    basicRate = json['basicRate'];
    dealerName = json['dealerName'];
    saudaQuantityInMt = json['saudaQuantityInMt'];
    saudaValidFromDate = json['saudaValidFromDate'];
    remarks = json['remarks'];
    sapRemarks = json['sapRemarks'];
    isApproval = json['isApproval'];
    bdoName = json['bdoName'];
    bdoId = json['bdoId'];
    dealerId = json['dealerId'];
    bdoAddress = json['bdoAddress'];
    dealerAddress = json['dealerAddress'];
    zonalHeadName = json['zonalHeadName'];
    pendingQuantityMT = json['pendingQuantityMT'];
    pendingQuantityCase = json['pendingQuantityCase'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    id = json['id'];
    saudaExtensionUpdateFromSap = json['saudaExtensionUpdateFromSap'];
    modifiedDate = json['modifiedDate'];
    isSapDataSync = json['isSapDataSync'];
    if (json['skuList'] != null) {
      skuList = <SaudaExtensionSkuList>[];
      json['skuList'].forEach((v) {
        skuList!.add(SaudaExtensionSkuList.fromJson(v));
      });
    }
    // extendedDays = json['extendedDays'];
    // extendedToDate = json['extendedToDate'];
    // isSelected=json["isSelected"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saudaOrderId'] = saudaOrderId;
    data['pendingContractId'] = pendingContractId;
    data['saudaNumber'] = saudaNumber;
    data['saudaBookedDate'] = saudaBookedDate;
    data['saudaValidToDate'] = saudaValidToDate;
    data['saudaExtendedToDate'] = saudaExtendedToDate;
    data['saudaQuantityMT'] = saudaQuantityMT;
    data['saudaQuantityCase'] = saudaQuantityCase;
    data['bookedSku'] = bookedSku;
    data['saudaExtendedDays'] = saudaExtendedDays;
    data['saudaRequestDate'] = saudaRequestDate;
    data['basicRate'] = basicRate;
    data['dealerName'] = dealerName;
    data['saudaQuantityInMt'] = saudaQuantityInMt;
    data['saudaValidFromDate'] = saudaValidFromDate;
    data['remarks'] = remarks;
    data['sapRemarks'] = sapRemarks;
    data['isApproval'] = isApproval;
    data['bdoName'] = bdoName;
    data['bdoId'] = bdoId;
    data['dealerId'] = dealerId;
    data['bdoAddress'] = bdoAddress;
    data['dealerAddress'] = dealerAddress;
    data['zonalHeadName'] = zonalHeadName;
    data['pendingQuantityMT'] = pendingQuantityMT;
    data['pendingQuantityCase'] = pendingQuantityCase;
    data['validFrom'] = validFrom;
    data['validTo'] = validTo;
    data['id'] = id;
    data['saudaExtensionUpdateFromSap'] = saudaExtensionUpdateFromSap;
    data['modifiedDate'] = modifiedDate;
    data['isSapDataSync'] = isSapDataSync;
    data['extendedDays'] = extendedDays;
    data['extendedToDate'] = extendedToDate;
    data["isSelected"] = isSelected;
    data["isExpanded"] = isExpanded;
    if (skuList != null) {
      data['skuList'] = skuList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class SaudaExtensionSkuList {
  String? skuName;
  String? skuCode;
  int? skuId;

  SaudaExtensionSkuList(
      {this.skuName, this.skuCode, this.skuId});

  SaudaExtensionSkuList.fromJson(Map<String, dynamic> json) {
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    skuId = json['skuId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuName'] = this.skuName;
    data['skuCode'] = this.skuCode;
    data['skuId'] = this.skuId;
    return data;
  }
}
