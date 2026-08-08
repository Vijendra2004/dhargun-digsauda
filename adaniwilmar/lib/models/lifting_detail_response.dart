class LiftingDetailResponse {
  int? saudaId;
  String? saudaNumber;
  int? liftingId;
  String? liftingNumber;
  String? liftingDate;
  int? statusId;
  int? liftingStatus;
  int? dealerId;
  String? dealer;
  int? saudaBookingTypeId;
  String? saudaBookingType;
  String? tradeTicketNumber;
  int? createdBy;
  String? createdUser;
  int? liftingFlag;
  double? totalQuantity;
  String? status;
  double? vehicleSize;
  int? shipToPartyId;
  String? shipToParty;
  String? remarks;
  String? customerRemarks;
  List<LiftingRequestDetailList>? liftingRequestDetailList;
  String? liftingDetailGroupingList;
  bool? postStatus;
  String? postMessage;
  String? plantName;
  String? depotName;
  String? enquiryNumber;
  String? enquiryRemarks;

  LiftingDetailResponse(
      {this.saudaId,
      this.saudaNumber,
      this.liftingId,
      this.liftingNumber,
      this.liftingDate,
      this.statusId,
      this.liftingStatus,
      this.dealerId,
      this.dealer,
      this.saudaBookingTypeId,
      this.saudaBookingType,
      this.tradeTicketNumber,
      this.createdBy,
      this.createdUser,
      this.liftingFlag,
      this.totalQuantity,
      this.status,
      this.vehicleSize,
      this.shipToPartyId,
      this.shipToParty,
      this.remarks,
      this.customerRemarks,
      this.liftingRequestDetailList,
      this.liftingDetailGroupingList,
      this.postStatus,
      this.postMessage,
      this.plantName,
      this.depotName,
      this.enquiryNumber,
      this.enquiryRemarks});

  LiftingDetailResponse.fromJson(Map<String, dynamic> json) {
    saudaId = json['saudaId'];
    saudaNumber = json['saudaNumber'];
    liftingId = json['liftingId'];
    liftingNumber = json['liftingNumber'];
    liftingDate = json['liftingDate'];
    statusId = json['statusId'];
    liftingStatus = json['liftingStatus'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    saudaBookingTypeId = json['saudaBookingTypeId'];
    saudaBookingType = json['saudaBookingType'];
    tradeTicketNumber = json['tradeTicketNumber'];
    createdBy = json['createdBy'];
    createdUser = json['createdUser'];
    liftingFlag = json['liftingFlag'];
    totalQuantity = json['totalQuantity'];
    status = json['status'];
    vehicleSize = json['vehicleSize'];
    shipToPartyId = json['shipToPartyId'];
    shipToParty = json['shipToParty'];
    remarks = json['remarks'];
    customerRemarks = json['customerRemarks'];
    if (json['liftingRequestDetailList'] != null) {
      liftingRequestDetailList = <LiftingRequestDetailList>[];
      json['liftingRequestDetailList'].forEach((v) {
        liftingRequestDetailList!.add(LiftingRequestDetailList.fromJson(v));
      });
    }
    liftingDetailGroupingList = json['liftingDetailGroupingList'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    plantName = json['plantName'];
    depotName = json['depotName'];
    enquiryNumber = json['enquiryNumber'];
    enquiryRemarks = json['enquiryRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saudaId'] = saudaId;
    data['saudaNumber'] = saudaNumber;
    data['liftingId'] = liftingId;
    data['liftingNumber'] = liftingNumber;
    data['liftingDate'] = liftingDate;
    data['statusId'] = statusId;
    data['liftingStatus'] = liftingStatus;
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['saudaBookingTypeId'] = saudaBookingTypeId;
    data['saudaBookingType'] = saudaBookingType;
    data['tradeTicketNumber'] = tradeTicketNumber;
    data['createdBy'] = createdBy;
    data['createdUser'] = createdUser;
    data['liftingFlag'] = liftingFlag;
    data['totalQuantity'] = totalQuantity;
    data['status'] = status;
    data['vehicleSize'] = vehicleSize;
    data['shipToPartyId'] = shipToPartyId;
    data['shipToParty'] = shipToParty;
    data['remarks'] = remarks;
    data['customerRemarks'] = customerRemarks;
    if (liftingRequestDetailList != null) {
      data['liftingRequestDetailList'] =
          liftingRequestDetailList!.map((v) => v.toJson()).toList();
    }
    data['liftingDetailGroupingList'] = liftingDetailGroupingList;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['plantName'] = plantName;
    data['depotName'] = depotName;
    data['enquiryNumber'] = enquiryNumber;
    data['enquiryRemarks'] = enquiryRemarks;
    return data;
  }
}

class LiftingRequestDetailList {
  int? id;
  int? liftingRequestId;
  int? skuId;
  String? skuName;
  int? oilTypeId;
  String? oilType;
  int? saudaOrderId;
  double? liftingQuantity;
  double? liftingQuantityInMT;
  int? approvedBy;
  String? remarks;
  int? status;
  String? statusName;
  String? enquiryNo;
  String? enquiryRemarks;
  double? finalRate;

  LiftingRequestDetailList(
      {this.id,
      this.liftingRequestId,
      this.skuId,
      this.skuName,
      this.oilTypeId,
      this.oilType,
      this.saudaOrderId,
      this.liftingQuantity,
      this.liftingQuantityInMT,
      this.approvedBy,
      this.remarks,
      this.status,
      this.statusName,
      this.enquiryNo,
      this.enquiryRemarks,
      this.finalRate});

  LiftingRequestDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    liftingRequestId = json['liftingRequestId'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    saudaOrderId = json['saudaOrderId'];
    liftingQuantity = json['liftingQuantity'];
    liftingQuantityInMT = json['liftingQuantityInMT'];
    approvedBy = json['approvedBy'];
    remarks = json['remarks'];
    status = json['status'];
    statusName = json['statusName'];
    enquiryNo = json['enquiryNo'];
    enquiryRemarks = json['enquiryRemarks'];
    finalRate = json['finalRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['liftingRequestId'] = liftingRequestId;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['oilTypeId'] = oilTypeId;
    data['oilType'] = oilType;
    data['saudaOrderId'] = saudaOrderId;
    data['liftingQuantity'] = liftingQuantity;
    data['liftingQuantityInMT'] = liftingQuantityInMT;
    data['approvedBy'] = approvedBy;
    data['remarks'] = remarks;
    data['status'] = status;
    data['statusName'] = statusName;
    data['enquiryNo'] = enquiryNo;
    data['enquiryRemarks'] = enquiryRemarks;
    data['finalRate'] = finalRate;
    return data;
  }
}
