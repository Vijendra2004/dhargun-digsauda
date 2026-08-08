class PendingSauda {
  int? id;
  int? saudaOrderId;
  String? biddingDate;
  double? totalBidPrice;
  double? totalBidQuantity;
  double? pendingliftQuantity;
  String? tradeTicketNumber;
  String? saudaNumber;
  String? user;
  int? userId;
  String? city;
  int? cityId;
  bool? isApproved;
  int? saudaStatusId;
  String? saudaStatus;
  int? statusId;
  String? status;
  String? skuName;
  String? skuCode;
  String? vertical;
  int? oilTypeId;
  String? oiltypeName;
  int? saudaId;
  int? dealerId;
  int? skuId;
  double? quotedPrice;
  double? bidQuantity;
  double? bidQuantityCase;
  double? bidPrice;
  String? discountType;
  double? discountAmount;
  String? incoterms1;
  String? incoterms2;
  String? plantName;
  String? dealerLocation;
  String? saudaBookingType;
  int? saudaBookingTypeId;
  int? discountTypeId;
  String? dealerName;
  String? createdBy;
  String? validFromDate;
  String? validToDate;
  String? remarks;
  bool? isActiveRemarks;
  bool? isSAPDataSyncApproval;
  bool? isSaudaApprovalSyncConfirmation;
  bool? isError;
  String? dealerCode;
  String? bdoName;
  int? createdById;
  String? createdDate;
  String? stateName;
  bool? isLooseVerticalForAcceptedStatus;
  double? counterBidOffer;
  double? basePricePerCase;
  double? basePricePerSku;
  double? bidPricePerSku;
  double? bidPricePerCase;
  int? saudaBookedNumber;
  String? bdoCode;
  bool? isSAPDataSync;
  bool? isSapSauda;
  bool? isSapSyncNotReceivedForSaudaNumber;
  bool? isSapSyncNotReceivedForSaudaApprovalConfirmation;
  String? modifiedDate;
  bool? isSaudaApprovalStatusFromSap;
  bool? isSapSaudaNumberUpdateSync;
  double? noOfSkusPerCase;
  double? forPlantPrice;
  double? forDepotPrice;
  double? forRakePrice;
  double? exPlantPrice;
  double? exDepotPrice;
  double? exRakePrice;
  int? incotermsTwo;

  PendingSauda(
      {this.id,
      this.saudaOrderId,
      this.biddingDate,
      this.totalBidPrice,
      this.totalBidQuantity,
      this.pendingliftQuantity,
      this.tradeTicketNumber,
      this.saudaNumber,
      this.user,
      this.userId,
      this.city,
      this.cityId,
      this.isApproved,
      this.saudaStatusId,
      this.saudaStatus,
      this.statusId,
      this.status,
      this.skuName,
      this.skuCode,
      this.vertical,
      this.oilTypeId,
      this.oiltypeName,
      this.saudaId,
      this.dealerId,
      this.skuId,
      this.quotedPrice,
      this.bidQuantity,
      this.bidQuantityCase,
      this.bidPrice,
      this.discountType,
      this.discountAmount,
      this.incoterms1,
      this.incoterms2,
      this.plantName,
      this.dealerLocation,
      this.saudaBookingType,
      this.saudaBookingTypeId,
      this.discountTypeId,
      this.dealerName,
      this.createdBy,
      this.validFromDate,
      this.validToDate,
      this.remarks,
      this.isActiveRemarks,
      this.isSAPDataSyncApproval,
      this.isSaudaApprovalSyncConfirmation,
      this.isError,
      this.dealerCode,
      this.bdoName,
      this.createdById,
      this.createdDate,
      this.stateName,
      this.isLooseVerticalForAcceptedStatus,
      this.counterBidOffer,
      this.basePricePerCase,
      this.basePricePerSku,
      this.bidPricePerSku,
      this.bidPricePerCase,
      this.saudaBookedNumber,
      this.bdoCode,
      this.isSAPDataSync,
      this.isSapSauda,
      this.isSapSyncNotReceivedForSaudaNumber,
      this.isSapSyncNotReceivedForSaudaApprovalConfirmation,
      this.modifiedDate,
      this.isSaudaApprovalStatusFromSap,
      this.isSapSaudaNumberUpdateSync,
      this.noOfSkusPerCase,
      this.forPlantPrice,
      this.forDepotPrice,
      this.forRakePrice,
      this.exPlantPrice,
      this.exDepotPrice,
      this.exRakePrice,
      this.incotermsTwo});

  PendingSauda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saudaOrderId = json['saudaOrderId'];
    biddingDate = json['biddingDate'];
    totalBidPrice = json['totalBidPrice'];
    totalBidQuantity = json['totalBidQuantity'];
    pendingliftQuantity = json['pendingliftQuantity'];
    tradeTicketNumber = json['tradeTicketNumber'];
    saudaNumber = json['saudaNumber'];
    user = json['user'];
    userId = json['userId'];
    city = json['city'];
    cityId = json['cityId'];
    isApproved = json['isApproved'];
    saudaStatusId = json['saudaStatusId'];
    saudaStatus = json['saudaStatus'];
    statusId = json['statusId'];
    status = json['status'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    vertical = json['vertical'];
    oilTypeId = json['oilTypeId'];
    oiltypeName = json['oiltypeName'];
    saudaId = json['saudaId'];
    dealerId = json['dealerId'];
    skuId = json['skuId'];
    quotedPrice = json['quotedPrice'];
    bidQuantity = json['bidQuantity'];
    bidQuantityCase = json['bidQuantityCase'];
    bidPrice = json['bidPrice'];
    discountType = json['discountType'];
    discountAmount = json['discountAmount'];
    incoterms1 = json['incoterms1'];
    incoterms2 = json['incoterms2'];
    plantName = json['plantName'];
    dealerLocation = json['dealerLocation'];
    saudaBookingType = json['saudaBookingType'];
    saudaBookingTypeId = json['saudaBookingTypeId'];
    discountTypeId = json['discountTypeId'];
    dealerName = json['dealerName'];
    createdBy = json['createdBy'];
    validFromDate = json['validFromDate'];
    validToDate = json['validToDate'];
    remarks = json['remarks'];
    isActiveRemarks = json['isActiveRemarks'];
    isSAPDataSyncApproval = json['isSAPDataSyncApproval'];
    isSaudaApprovalSyncConfirmation = json['isSaudaApprovalSyncConfirmation'];
    isError = json['isError'];
    dealerCode = json['dealerCode'];
    bdoName = json['bdoName'];
    createdById = json['createdById'];
    createdDate = json['createdDate'];
    stateName = json['stateName'];
    isLooseVerticalForAcceptedStatus = json['isLooseVerticalForAcceptedStatus'];
    counterBidOffer = json['counterBidOffer'];
    basePricePerCase = json['basePricePerCase'];
    basePricePerSku = json['basePricePerSku'];
    bidPricePerSku = json['bidPricePerSku'];
    bidPricePerCase = json['bidPricePerCase'];
    saudaBookedNumber = json['saudaBookedNumber'];
    bdoCode = json['bdoCode'];
    isSAPDataSync = json['isSAPDataSync'];
    isSapSauda = json['isSapSauda'];
    isSapSyncNotReceivedForSaudaNumber =
        json['isSapSyncNotReceivedForSaudaNumber'];
    isSapSyncNotReceivedForSaudaApprovalConfirmation =
        json['isSapSyncNotReceivedForSaudaApprovalConfirmation'];
    modifiedDate = json['modifiedDate'];
    isSaudaApprovalStatusFromSap = json['isSaudaApprovalStatusFromSap'];
    isSapSaudaNumberUpdateSync = json['isSapSaudaNumberUpdateSync'];
    noOfSkusPerCase = json['noOfSkusPerCase'];
    forPlantPrice = json['forPlantPrice'];
    forDepotPrice = json['forDepotPrice'];
    forRakePrice = json['forRakePrice'];
    exPlantPrice = json['exPlantPrice'];
    exDepotPrice = json['exDepotPrice'];
    exRakePrice = json['exRakePrice'];
    incotermsTwo = json['incotermsTwo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['saudaOrderId'] = saudaOrderId;
    data['biddingDate'] = biddingDate;
    data['totalBidPrice'] = totalBidPrice;
    data['totalBidQuantity'] = totalBidQuantity;
    data['pendingliftQuantity'] = pendingliftQuantity;
    data['tradeTicketNumber'] = tradeTicketNumber;
    data['saudaNumber'] = saudaNumber;
    data['user'] = user;
    data['userId'] = userId;
    data['city'] = city;
    data['cityId'] = cityId;
    data['isApproved'] = isApproved;
    data['saudaStatusId'] = saudaStatusId;
    data['saudaStatus'] = saudaStatus;
    data['statusId'] = statusId;
    data['status'] = status;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['vertical'] = vertical;
    data['oilTypeId'] = oilTypeId;
    data['oiltypeName'] = oiltypeName;
    data['saudaId'] = saudaId;
    data['dealerId'] = dealerId;
    data['skuId'] = skuId;
    data['quotedPrice'] = quotedPrice;
    data['bidQuantity'] = bidQuantity;
    data['bidQuantityCase'] = bidQuantityCase;
    data['bidPrice'] = bidPrice;
    data['discountType'] = discountType;
    data['discountAmount'] = discountAmount;
    data['incoterms1'] = incoterms1;
    data['incoterms2'] = incoterms2;
    data['plantName'] = plantName;
    data['dealerLocation'] = dealerLocation;
    data['saudaBookingType'] = saudaBookingType;
    data['saudaBookingTypeId'] = saudaBookingTypeId;
    data['discountTypeId'] = discountTypeId;
    data['dealerName'] = dealerName;
    data['createdBy'] = createdBy;
    data['validFromDate'] = validFromDate;
    data['validToDate'] = validToDate;
    data['remarks'] = remarks;
    data['isActiveRemarks'] = isActiveRemarks;
    data['isSAPDataSyncApproval'] = isSAPDataSyncApproval;
    data['isSaudaApprovalSyncConfirmation'] = isSaudaApprovalSyncConfirmation;
    data['isError'] = isError;
    data['dealerCode'] = dealerCode;
    data['bdoName'] = bdoName;
    data['createdById'] = createdById;
    data['createdDate'] = createdDate;
    data['stateName'] = stateName;
    data['isLooseVerticalForAcceptedStatus'] = isLooseVerticalForAcceptedStatus;
    data['counterBidOffer'] = counterBidOffer;
    data['basePricePerCase'] = basePricePerCase;
    data['basePricePerSku'] = basePricePerSku;
    data['bidPricePerSku'] = bidPricePerSku;
    data['bidPricePerCase'] = bidPricePerCase;
    data['saudaBookedNumber'] = saudaBookedNumber;
    data['bdoCode'] = bdoCode;
    data['isSAPDataSync'] = isSAPDataSync;
    data['isSapSauda'] = isSapSauda;
    data['isSapSyncNotReceivedForSaudaNumber'] =
        isSapSyncNotReceivedForSaudaNumber;
    data['isSapSyncNotReceivedForSaudaApprovalConfirmation'] =
        isSapSyncNotReceivedForSaudaApprovalConfirmation;
    data['modifiedDate'] = modifiedDate;
    data['isSaudaApprovalStatusFromSap'] = isSaudaApprovalStatusFromSap;
    data['isSapSaudaNumberUpdateSync'] = isSapSaudaNumberUpdateSync;
    data['noOfSkusPerCase'] = noOfSkusPerCase;
    data['forPlantPrice'] = forPlantPrice;
    data['forDepotPrice'] = forDepotPrice;
    data['forRakePrice'] = forRakePrice;
    data['exPlantPrice'] = exPlantPrice;
    data['exDepotPrice'] = exDepotPrice;
    data['exRakePrice'] = exRakePrice;
    data['incotermsTwo'] = incotermsTwo;
    return data;
  }
}

class PendingSaudaDistributor {
  int? dealerId;
  String? plantName;
  String? dealerLocation;
  String? dealerName;
  String? dealerCode;

  PendingSaudaDistributor({
    this.dealerId,
    this.plantName,
    this.dealerLocation,
    this.dealerName,
    this.dealerCode,
  });

  PendingSaudaDistributor.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    plantName = json['plantName'];
    dealerLocation = json['dealerLocation'];
    dealerName = json['dealerName'];
    dealerCode = json['dealerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['plantName'] = plantName;
    data['dealerLocation'] = dealerLocation;
    data['dealerName'] = dealerName;
    data['dealerCode'] = dealerCode;
    return data;
  }
}
