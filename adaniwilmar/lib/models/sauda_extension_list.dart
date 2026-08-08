class SaudaBookedDealerDetail {
  SaudaBookedDealerDetail({this.dealerName, this.dealerId, this.dealerCode});
  String? dealerName;
  int? dealerId;
  String? dealerCode;
  List<SaudaBookedSaudaWithExtensionDetails>? saudaBookedList;

  SaudaBookedDealerDetail.fromJson(Map<String, dynamic> json) {
    dealerName = json['dealerName'];
    dealerId = json['dealerId'];
    dealerCode = json['dealerCode'];
    saudaBookedList = List.from(json['saudaBookedList'])
        .map((e) => SaudaBookedSaudaWithExtensionDetails.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dealerName'] = dealerName;
    _data['dealerId'] = dealerId;
    _data['dealerCode'] = dealerCode;
    _data['pendingList'] = saudaBookedList!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SaudaBookedSaudaWithExtensionDetails {
  SaudaBookedSaudaWithExtensionDetails({
    this.saudaOrderId,
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
  });
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

  SaudaBookedSaudaWithExtensionDetails.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['saudaOrderId'] = saudaOrderId;
    _data['pendingContractId'] = pendingContractId;
    _data['saudaNumber'] = saudaNumber;
    _data['saudaBookedDate'] = saudaBookedDate;
    _data['saudaValidToDate'] = saudaValidToDate;
    _data['saudaExtendedToDate'] = saudaExtendedToDate;
    _data['saudaQuantityMT'] = saudaQuantityMT;
    _data['saudaQuantityCase'] = saudaQuantityCase;
    _data['bookedSku'] = bookedSku;
    _data['saudaExtendedDays'] = saudaExtendedDays;
    _data['saudaRequestDate'] = saudaRequestDate;
    _data['basicRate'] = basicRate;
    _data['dealerName'] = dealerName;
    _data['saudaQuantityInMt'] = saudaQuantityInMt;
    _data['saudaValidFromDate'] = saudaValidFromDate;
    _data['remarks'] = remarks;
    _data['sapRemarks'] = sapRemarks;
    _data['isApproval'] = isApproval;
    _data['bdoName'] = bdoName;
    _data['bdoId'] = bdoId;
    _data['dealerId'] = dealerId;
    _data['bdoAddress'] = bdoAddress;
    _data['dealerAddress'] = dealerAddress;
    _data['zonalHeadName'] = zonalHeadName;
    _data['pendingQuantityMT'] = pendingQuantityMT;
    _data['pendingQuantityCase'] = pendingQuantityCase;
    _data['validFrom'] = validFrom;
    _data['validTo'] = validTo;
    _data['id'] = id;
    _data['saudaExtensionUpdateFromSap'] = saudaExtensionUpdateFromSap;
    _data['modifiedDate'] = modifiedDate;
    _data['isSapDataSync'] = isSapDataSync;
    return _data;
  }
}

class BookedSaudha {
  BookedSaudha({
    this.pendingList,
    this.approvedList,
  });
  List<SaudaBookedDealerDetail>? pendingList;
  List<SaudaBookedDealerDetail>? approvedList;

  BookedSaudha.fromJson(Map<String, dynamic> json) {
    pendingList = List.from(json['pendingList'])
        .map((e) => SaudaBookedDealerDetail.fromJson(e))
        .toList();
    approvedList = List.from(json['approvedList'])
        .map((e) => SaudaBookedDealerDetail.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pendingList'] = pendingList!.map((e) => e.toJson()).toList();
    _data['approvedList'] = approvedList!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DealerBookedSaudha {
  DealerBookedSaudha({
    this.pendingList,
    this.approvedList,
  });
  List<SaudaBookedSaudaWithExtensionDetails>? pendingList;
  List<SaudaBookedSaudaWithExtensionDetails>? approvedList;

  DealerBookedSaudha.fromJson(Map<String, dynamic> json) {
    pendingList = List.from(json['pendingList'])
        .map((e) => SaudaBookedSaudaWithExtensionDetails.fromJson(e))
        .toList();
    approvedList = List.from(json['approvedList'])
        .map((e) => SaudaBookedSaudaWithExtensionDetails.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pendingList'] = pendingList!.map((e) => e.toJson()).toList();
    _data['approvedList'] = approvedList!.map((e) => e.toJson()).toList();
    return _data;
  }
}
