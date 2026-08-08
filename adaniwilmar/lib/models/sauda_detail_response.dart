class SaudaDetailResponse {
  int? saudaId;
  int? saudaOrderId;
  String? saudaNumber;
  String? saudaDate;
  int? saudaExpireDays;
  int? saudaValidityDays;
  double? totalQuantity;
  double? totalQuantityInMT;
  double? totalAmount;
  double? impactMargin;
  int? dealerId;
  String? dealerName;
  String? dealerLoaction;
  String? plantOrDepot;
  String? incoterm;
  String? approverRemarks;
  String? expiryDate;
  double? totalPendingQuantity;
  List<SaudaOrderDetail>? saudaOrders;
  List<dynamic>? liftingDetailGrouping;
  bool? postStatus;
  String? postMessage;
  LiftingDetails? liftingDetails;
  int? statusId;
  int? saudaStatusId;
  String? saudaStatus;
  String? status;
  String? skuName;
  String? oiltypeName;
  double? quotedPrice;
  double? bidQuantity;
  double? bidQuantityCase;
  double? bidPrice;
  int? discountType;
  double? discountAmount;
  String? incoterms1;
  String? incoterms2;
  String? plantName;
  String? dealerLocation;
  String? saudaBookingType;
  String? broker;
  String? tradeTicketNumber;
  String? biddingDate;
  String? validFromDate;
  String? validToDate;
  int? createdBy;
  int? brokerId;
  String? brokerName;
  double? counterBidOffer;
  double? basePricePerCase;
  double? bidPricePerSku;
  double? bidPricePerCase;
  int? saudaBookedNumber;
  int? skuId;
  int? loginUserId;
  bool? isFromSAPData;
  List<int>? audiofileDetailIds;
  List<String>? imagePaths;
  String? remarks;
  bool? canSubmitAudioMapping;

  SaudaDetailResponse(
      {this.saudaId,
      this.saudaOrderId,
      this.saudaNumber,
      this.saudaDate,
      this.saudaExpireDays,
      this.saudaValidityDays,
      this.totalQuantity,
      this.totalQuantityInMT,
      this.totalAmount,
      this.impactMargin,
      this.dealerId,
      this.dealerName,
      this.dealerLoaction,
      this.plantOrDepot,
      this.incoterm,
      this.approverRemarks,
      this.expiryDate,
      this.totalPendingQuantity,
      this.saudaOrders,
      this.liftingDetailGrouping,
      this.postStatus,
      this.postMessage,
      this.liftingDetails,
      this.statusId,
      this.saudaStatusId,
      this.saudaStatus,
      this.status,
      this.skuName,
      this.oiltypeName,
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
      this.broker,
      this.tradeTicketNumber,
      this.biddingDate,
      this.validFromDate,
      this.validToDate,
      this.createdBy,
      this.brokerId,
      this.brokerName,
      this.counterBidOffer,
      this.basePricePerCase,
      this.bidPricePerSku,
      this.bidPricePerCase,
      this.saudaBookedNumber,
      this.skuId,
      this.loginUserId,
      this.isFromSAPData,
      this.audiofileDetailIds,
      this.imagePaths,
      this.canSubmitAudioMapping,
      this.remarks});

  SaudaDetailResponse.fromJson(Map<String, dynamic> json) {
    saudaId = json['saudaId'];
    saudaOrderId = json['saudaOrderId'];
    saudaNumber = json['saudaNumber'];
    saudaDate = json['saudaDate'];
    saudaExpireDays = json['saudaExpireDays'];
    saudaValidityDays = json['saudaValidityDays'];
    totalQuantity = json['totalQuantity'];
    totalQuantityInMT = json['totalQuantityInMT'];
    totalAmount = json['totalAmount'];
    impactMargin = json['impactMargin'];
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    dealerLoaction = json['dealerLoaction'];
    plantOrDepot = json['plantOrDepot'];
    incoterm = json['incoterm'];
    approverRemarks = json['approverRemarks'];
    expiryDate = json['expiryDate'];
    totalPendingQuantity = json['totalPendingQuantity'];
    if (json['saudaOrders'] != null) {
      saudaOrders = <SaudaOrderDetail>[];
      json['saudaOrders'].forEach((v) {
        saudaOrders!.add(SaudaOrderDetail.fromJson(v));
      });
    }
    if (json['liftingDetailGrouping'] != null) {
      liftingDetailGrouping = [];
    }
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    liftingDetails = json['liftingDetails'] != null
        ? LiftingDetails.fromJson(json['liftingDetails'])
        : null;
    statusId = json['statusId'];
    saudaStatusId = json['saudaStatusId'];
    saudaStatus = json['saudaStatus'];
    status = json['status'];
    skuName = json['skuName'];
    oiltypeName = json['oiltypeName'];
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
    broker = json['broker'];
    tradeTicketNumber = json['tradeTicketNumber'];
    biddingDate = json['biddingDate'];
    validFromDate = json['validFromDate'];
    validToDate = json['validToDate'];
    createdBy = json['createdBy'];
    brokerId = json['brokerId'];
    brokerName = json['brokerName'];
    counterBidOffer = json['counterBidOffer'];
    basePricePerCase = json['basePricePerCase'];
    bidPricePerSku = json['bidPricePerSku'];
    bidPricePerCase = json['bidPricePerCase'];
    saudaBookedNumber = json['saudaBookedNumber'];
    skuId = json['skuId'];
    loginUserId = json['loginUserId'];
    isFromSAPData = json['isFromSAPData'];
    audiofileDetailIds=[];
    if (json['audiofileDetailIds'] != null) {
      json['audiofileDetailIds'].forEach((v) {
        audiofileDetailIds!.add(v);
      });
    }
    imagePaths = [];
    if (json['imagePaths'] != null) {
      json['imagePaths'].forEach((v) {
        imagePaths!.add(v.toString());
      });
    }
    canSubmitAudioMapping = json['canSubmitAudioMapping'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saudaId'] = saudaId;
    data['saudaOrderId'] = saudaOrderId;
    data['saudaNumber'] = saudaNumber;
    data['saudaDate'] = saudaDate;
    data['saudaExpireDays'] = saudaExpireDays;
    data['saudaValidityDays'] = saudaValidityDays;
    data['totalQuantity'] = totalQuantity;
    data['totalQuantityInMT'] = totalQuantityInMT;
    data['totalAmount'] = totalAmount;
    data['impactMargin'] = impactMargin;
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['dealerLoaction'] = dealerLoaction;
    data['plantOrDepot'] = plantOrDepot;
    data['incoterm'] = incoterm;
    data['approverRemarks'] = approverRemarks;
    data['expiryDate'] = expiryDate;
    data['totalPendingQuantity'] = totalPendingQuantity;
    if (saudaOrders != null) {
      data['saudaOrders'] = saudaOrders!.map((v) => v.toJson()).toList();
    }
    if (liftingDetailGrouping != null) {
      data['liftingDetailGrouping'] =
          liftingDetailGrouping!.map((v) => v.toJson()).toList();
    }
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    if (liftingDetails != null) {
      data['liftingDetails'] = liftingDetails!.toJson();
    }
    data['statusId'] = statusId;
    data['saudaStatusId'] = saudaStatusId;
    data['saudaStatus'] = saudaStatus;
    data['status'] = status;
    data['skuName'] = skuName;
    data['oiltypeName'] = oiltypeName;
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
    data['broker'] = broker;
    data['tradeTicketNumber'] = tradeTicketNumber;
    data['biddingDate'] = biddingDate;
    data['validFromDate'] = validFromDate;
    data['validToDate'] = validToDate;
    data['createdBy'] = createdBy;
    data['brokerId'] = brokerId;
    data['brokerName'] = brokerName;
    data['counterBidOffer'] = counterBidOffer;
    data['basePricePerCase'] = basePricePerCase;
    data['bidPricePerSku'] = bidPricePerSku;
    data['bidPricePerCase'] = bidPricePerCase;
    data['saudaBookedNumber'] = saudaBookedNumber;
    data['skuId'] = skuId;
    data['loginUserId'] = loginUserId;
    data['isFromSAPData'] = isFromSAPData;
    if (audiofileDetailIds != null) {
      data['audiofileDetailIds'] =
          audiofileDetailIds!;
    }
    data['imagePaths'] = imagePaths;
    data['canSubmitAudioMapping'] = canSubmitAudioMapping;
    data['remarks'] = remarks;
    return data;
  }
}

class SaudaOrderDetail {
  int? skuId;
  String? skuName;
  String? skuCode;
  int? oilTypeId;
  String? oilTypeName;
  double? bidQuantity;
  double? bidQuantityCases;
  double? bidPrice;
  double? bidPricePerCase;
  double? counterBidOffer;
  double? counterBidOfferDate;
  double? discount;
  double? quotedPrice;
  String? liftedDate;
  String? incoTerms;
  String? plantDepot;
  int? statusId;
  String? status;
  String? validToDate;
  String? bookedDate;
  int? saudaId;
  int? saudaOrderId;
  String? saudaNumber;
  int? dealerId;
  String? dealerName;
  int? discountTypeId;
  int? saudaConversionId;
  int? createdBy;
  String? cityName;
  String? plantName;
  String? incoTerm;
  String? validFrom;
  double? pendingQuantity;
  double? pendingQuantityCases;
  String? remarks;
  int? plantId;
  int? depotId;
  int? incoTermId;
  double? bidPricePerCaseWithoutTax;
  String? skuDetail;
  bool? postStatus;
  String? postMessage;
  String? failedRecordName;
  String? message;

  SaudaOrderDetail(
      {this.skuId,
      this.skuName,
      this.skuCode,
      this.oilTypeId,
      this.oilTypeName,
      this.bidQuantity,
      this.bidQuantityCases,
      this.bidPrice,
      this.bidPricePerCase,
      this.counterBidOffer,
      this.counterBidOfferDate,
      this.discount,
      this.quotedPrice,
      this.liftedDate,
      this.incoTerms,
      this.plantDepot,
      this.statusId,
      this.status,
      this.validToDate,
      this.bookedDate,
      this.saudaId,
      this.saudaOrderId,
      this.saudaNumber,
      this.dealerId,
      this.dealerName,
      this.discountTypeId,
      this.saudaConversionId,
      this.createdBy,
      this.cityName,
      this.plantName,
      this.incoTerm,
      this.validFrom,
      this.pendingQuantity,
      this.pendingQuantityCases,
      this.remarks,
      this.plantId,
      this.depotId,
      this.incoTermId,
      this.bidPricePerCaseWithoutTax,
      this.skuDetail,
      this.postStatus,
      this.postMessage,
      this.failedRecordName,
      this.message});

  SaudaOrderDetail.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    bidQuantity = json['bidQuantity'];
    bidQuantityCases = json['bidQuantityCases'];
    bidPrice = json['bidPrice'];
    bidPricePerCase = json['bidPricePerCase'];
    counterBidOffer = json['counterBidOffer'];
    counterBidOfferDate = json['counterBidOfferDate'];
    discount = json['discount'];
    quotedPrice = json['quotedPrice'];
    liftedDate = json['liftedDate'];
    incoTerms = json['incoTerms'];
    plantDepot = json['plantDepot'];
    statusId = json['statusId'];
    status = json['status'];
    validToDate = json['validToDate'];
    bookedDate = json['bookedDate'];
    saudaId = json['saudaId'];
    saudaOrderId = json['saudaOrderId'];
    saudaNumber = json['saudaNumber'];
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    discountTypeId = json['discountTypeId'];
    saudaConversionId = json['saudaConversionId'];
    createdBy = json['createdBy'];
    cityName = json['cityName'];
    plantName = json['plantName'];
    incoTerm = json['incoTerm'];
    validFrom = json['validFrom'];
    pendingQuantity = json['pendingQuantity'];
    pendingQuantityCases = json['pendingQuantityCases'];
    remarks = json['remarks'];
    plantId = json['plantId'];
    depotId = json['depotId'];
    incoTermId = json['incoTermId'];
    bidPricePerCaseWithoutTax = json['bidPricePerCaseWithoutTax'];
    skuDetail = json['skuDetail'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    failedRecordName = json['failedRecordName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    data['bidQuantity'] = bidQuantity;
    data['bidQuantityCases'] = bidQuantityCases;
    data['bidPrice'] = bidPrice;
    data['bidPricePerCase'] = bidPricePerCase;
    data['counterBidOffer'] = counterBidOffer;
    data['counterBidOfferDate'] = counterBidOfferDate;
    data['discount'] = discount;
    data['quotedPrice'] = quotedPrice;
    data['liftedDate'] = liftedDate;
    data['incoTerms'] = incoTerms;
    data['plantDepot'] = plantDepot;
    data['statusId'] = statusId;
    data['status'] = status;
    data['validToDate'] = validToDate;
    data['bookedDate'] = bookedDate;
    data['saudaId'] = saudaId;
    data['saudaOrderId'] = saudaOrderId;
    data['saudaNumber'] = saudaNumber;
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['discountTypeId'] = discountTypeId;
    data['saudaConversionId'] = saudaConversionId;
    data['createdBy'] = createdBy;
    data['cityName'] = cityName;
    data['plantName'] = plantName;
    data['incoTerm'] = incoTerm;
    data['validFrom'] = validFrom;
    data['pendingQuantity'] = pendingQuantity;
    data['pendingQuantityCases'] = pendingQuantityCases;
    data['remarks'] = remarks;
    data['plantId'] = plantId;
    data['depotId'] = depotId;
    data['incoTermId'] = incoTermId;
    data['bidPricePerCaseWithoutTax'] = bidPricePerCaseWithoutTax;
    data['skuDetail'] = skuDetail;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['failedRecordName'] = failedRecordName;
    data['message'] = message;
    return data;
  }
}

class LiftingDetails {
  double? completedQuantity;
  double? inprogressQuantity;
  double? pendingQuantity;
  double? pendingQuantityCase;
  List<LiftedSku>? liftedSkus;

  LiftingDetails(
      {this.completedQuantity,
      this.inprogressQuantity,
      this.pendingQuantity,
      this.pendingQuantityCase,
      this.liftedSkus});

  LiftingDetails.fromJson(Map<String, dynamic> json) {
    completedQuantity = json['completedQuantity'];
    inprogressQuantity = json['inprogressQuantity'];
    pendingQuantity = json['pendingQuantity'];
    pendingQuantityCase = json['pendingQuantityCase'];
    if (json['liftedSkus'] != null) {
      liftedSkus = [];
      json['liftedSkus'].forEach((v) {
        liftedSkus!.add(LiftedSku.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['completedQuantity'] = completedQuantity;
    data['inprogressQuantity'] = inprogressQuantity;
    data['pendingQuantity'] = pendingQuantity;
    data['pendingQuantityCase'] = pendingQuantityCase;
    if (liftedSkus != null) {
      data['liftedSkus'] = liftedSkus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiftedSku {
  int? skuId;
  String? skuName;
  String? skuCode;
  int? oilTypeId;
  String? oilTypeName;
  double? bidQuantity;
  double? bidQuantityCases;
  double? bidPrice;
  double? bidPricePerCase;
  double? counterBidOffer;
  String? counterBidOfferDate;
  double? discount;
  double? quotedPrice;
  String? liftedDate;
  String? incoTerms;
  String? plantDepot;
  int? statusId;
  String? status;
  String? validToDate;
  String? bookedDate;
  int? saudaId;
  int? saudaOrderId;
  String? saudaNumber;
  int? dealerId;
  String? dealerName;
  int? discountTypeId;
  int? saudaConversionId;
  int? createdBy;
  String? cityName;
  String? plantName;
  String? incoTerm;
  String? validFrom;
  double? pendingQuantity;
  double? pendingQuantityCases;
  String? remarks;
  int? plantId;
  int? depotId;
  int? incoTermId;
  double? bidPricePerCaseWithoutTax;
  dynamic skuDetail;
  bool? postStatus;
  String? postMessage;
  String? failedRecordName;
  String? message;

  LiftedSku(
      {this.skuId,
      this.skuName,
      this.skuCode,
      this.oilTypeId,
      this.oilTypeName,
      this.bidQuantity,
      this.bidQuantityCases,
      this.bidPrice,
      this.bidPricePerCase,
      this.counterBidOffer,
      this.counterBidOfferDate,
      this.discount,
      this.quotedPrice,
      this.liftedDate,
      this.incoTerms,
      this.plantDepot,
      this.statusId,
      this.status,
      this.validToDate,
      this.bookedDate,
      this.saudaId,
      this.saudaOrderId,
      this.saudaNumber,
      this.dealerId,
      this.dealerName,
      this.discountTypeId,
      this.saudaConversionId,
      this.createdBy,
      this.cityName,
      this.plantName,
      this.incoTerm,
      this.validFrom,
      this.pendingQuantity,
      this.pendingQuantityCases,
      this.remarks,
      this.plantId,
      this.depotId,
      this.incoTermId,
      this.bidPricePerCaseWithoutTax,
      this.skuDetail,
      this.postStatus,
      this.postMessage,
      this.failedRecordName,
      this.message});

  LiftedSku.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    bidQuantity = json['bidQuantity'];
    bidQuantityCases = json['bidQuantityCases'];
    bidPrice = json['bidPrice'];
    bidPricePerCase = json['bidPricePerCase'];
    counterBidOffer = json['counterBidOffer'];
    counterBidOfferDate = json['counterBidOfferDate'];
    discount = json['discount'];
    quotedPrice = json['quotedPrice'];
    liftedDate = json['liftedDate'];
    incoTerms = json['incoTerms'];
    plantDepot = json['plantDepot'];
    statusId = json['statusId'];
    status = json['status'];
    validToDate = json['validToDate'];
    bookedDate = json['bookedDate'];
    saudaId = json['saudaId'];
    saudaOrderId = json['saudaOrderId'];
    saudaNumber = json['saudaNumber'];
    dealerId = json['dealerId'];
    dealerName = json['dealerName'];
    discountTypeId = json['discountTypeId'];
    saudaConversionId = json['saudaConversionId'];
    createdBy = json['createdBy'];
    cityName = json['cityName'];
    plantName = json['plantName'];
    incoTerm = json['incoTerm'];
    validFrom = json['validFrom'];
    pendingQuantity = json['pendingQuantity'];
    pendingQuantityCases = json['pendingQuantityCases'];
    remarks = json['remarks'];
    plantId = json['plantId'];
    depotId = json['depotId'];
    incoTermId = json['incoTermId'];
    bidPricePerCaseWithoutTax = json['bidPricePerCaseWithoutTax'];
    skuDetail = json['skuDetail'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    failedRecordName = json['failedRecordName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    data['bidQuantity'] = bidQuantity;
    data['bidQuantityCases'] = bidQuantityCases;
    data['bidPrice'] = bidPrice;
    data['bidPricePerCase'] = bidPricePerCase;
    data['counterBidOffer'] = counterBidOffer;
    data['counterBidOfferDate'] = counterBidOfferDate;
    data['discount'] = discount;
    data['quotedPrice'] = quotedPrice;
    data['liftedDate'] = liftedDate;
    data['incoTerms'] = incoTerms;
    data['plantDepot'] = plantDepot;
    data['statusId'] = statusId;
    data['status'] = status;
    data['validToDate'] = validToDate;
    data['bookedDate'] = bookedDate;
    data['saudaId'] = saudaId;
    data['saudaOrderId'] = saudaOrderId;
    data['saudaNumber'] = saudaNumber;
    data['dealerId'] = dealerId;
    data['dealerName'] = dealerName;
    data['discountTypeId'] = discountTypeId;
    data['saudaConversionId'] = saudaConversionId;
    data['createdBy'] = createdBy;
    data['cityName'] = cityName;
    data['plantName'] = plantName;
    data['incoTerm'] = incoTerm;
    data['validFrom'] = validFrom;
    data['pendingQuantity'] = pendingQuantity;
    data['pendingQuantityCases'] = pendingQuantityCases;
    data['remarks'] = remarks;
    data['plantId'] = plantId;
    data['depotId'] = depotId;
    data['incoTermId'] = incoTermId;
    data['bidPricePerCaseWithoutTax'] = bidPricePerCaseWithoutTax;
    data['skuDetail'] = skuDetail;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['failedRecordName'] = failedRecordName;
    data['message'] = message;
    return data;
  }
}
