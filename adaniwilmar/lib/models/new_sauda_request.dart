import 'package:adaniwilmar/models/qps_res_model.dart';

class NewSaudaRequest {
  int? distributionChannelId;
  int? salesOrganizationId;
  int? divisionId;
  int? bDOId;
  String? biddingDate;
  int? dealerId;
  int? loginUserId;
  int? saudaBookingTypeId;
  bool? isCrossAndUpsellContract;
  int? saudaType;
  List<SaudaOrders>? saudaOrders;
  int? brokerId;

  // int? qpsDiscount;

  NewSaudaRequest(
      {this.distributionChannelId,
      this.salesOrganizationId,
      this.divisionId,
      this.bDOId,
      this.biddingDate,
      this.dealerId,
        this.isCrossAndUpsellContract,
      this.loginUserId,
      this.saudaBookingTypeId,
        this.saudaType,
      this.saudaOrders,
      this.brokerId,

      // this.qpsDiscount,
      });

  NewSaudaRequest.fromJson(Map<String, dynamic> json) {
    distributionChannelId = json['distributionChannelId'];
    salesOrganizationId = json['salesOrganizationId'];
    divisionId = json['divisionId'];
    bDOId = json['BDOId'];
    biddingDate = json['BiddingDate'];
    dealerId = json['DealerId'];
    loginUserId = json['LoginUserId'];
    isCrossAndUpsellContract = json['IsCrossAndUpsellContract'];
    saudaBookingTypeId = json['SaudaBookingTypeId'];
    brokerId = json['BrokerId'];
    saudaType = json['saudaType'];
    if (json['SaudaOrders'] != null) {
      saudaOrders = <SaudaOrders>[];
      json['SaudaOrders'].forEach((v) {
        saudaOrders!.add(SaudaOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distributionChannelId'] = distributionChannelId;
    data['salesOrganizationId'] = salesOrganizationId;
    data['divisionId'] = divisionId;
    data['BDOId'] = bDOId;
    data['BiddingDate'] = biddingDate;
    data['DealerId'] = dealerId;
    data['LoginUserId'] = loginUserId;

    data['SaudaBookingTypeId'] = saudaBookingTypeId;
    data['IsCrossAndUpsellContract'] = isCrossAndUpsellContract;
    data['saudaType'] = saudaType;
    data['brokerId'] = brokerId;
    // data['QPSDiscount'] = qpsDiscount;
    if (saudaOrders != null) {
      data['SaudaOrders'] = saudaOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaudaOrders {
  int? bidQuantity;
  double? discountAmount;
  double? discountAmountPerCase;
  int? discountTypeId;
  int? discountId = 0;
  /*int? saudaType;*/
  String? incoTerms;
  int? incotermsId;
  int? oilTypeId;
  String? plantDepot;
  int? plantId;
  int? pricingId;
  bool? isMandatorySku = false;
  double? quotedPrice;
  String? saudaValidFromDate;
  String? saudaValidToDate;
  int? skuId;
  String? skuName;
  int? statusId;
  String? uomName;
  double? qpsDiscount;
  double? mtQtyVal;
  bool? isBidQuantityManual = false;
  DateTime? bidQuantityUpdatedAt = DateTime.now();
  bool? isManuallyEdited = false;

  double? finalRate;
  List<QPSResponseData>? qpsResModel;

  double? finalBaseRate;

  SaudaOrders(
      {this.bidQuantity,
      this.discountAmount,
      this.discountAmountPerCase,
      this.discountTypeId,
      this.discountId,
     /* this.saudaType,*/
      this.incoTerms,
        this.isBidQuantityManual = false,
      this.bidQuantityUpdatedAt,
        this.isMandatorySku = false,
      this.incotermsId,
      this.oilTypeId,
      this.plantDepot,

      this.plantId,
      this.pricingId,
      this.quotedPrice,
      this.saudaValidFromDate,
      this.saudaValidToDate,
      this.skuId,
      this.skuName,
      this.statusId,
      this.uomName,
      this.qpsDiscount,
      this.mtQtyVal,
      this.finalRate,
        this.isManuallyEdited = false,
        this.qpsResModel,
        this.finalBaseRate,
      });

  SaudaOrders.fromJson(Map<String, dynamic> json) {
    bidQuantity = json['BidQuantity'];
    discountAmount = json['DiscountAmount'];
    discountAmountPerCase = json['DiscountAmountPerCase'];
    discountTypeId = json['DiscountTypeId'];
    discountId = json['DiscountId'];
    /*saudaType = json['saudaType'];*/
    incoTerms = json['incoTerms'];
    incotermsId = json['IncotermsId'];
isMandatorySku = json['IsMandatorySku'] ?? false;
    oilTypeId = json['OilTypeId'];
    plantDepot = json['plantDepot'];
    plantId = json['PlantId'];
    pricingId = json['PricingId'];
    quotedPrice = json['QuotedPrice'];
    saudaValidFromDate = json['SaudaValidFromDate'];
    saudaValidToDate = json['SaudaValidToDate'];
    skuId = json['SkuId'];
    skuName = json['skuName'];
    statusId = json['StatusId'];
    uomName = json['uomName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BidQuantity'] = bidQuantity;
    data['DiscountAmount'] = discountAmount;
    data['DiscountAmountPerCase'] = discountAmountPerCase;
    data['DiscountTypeId'] = discountTypeId;
    data['DiscountId'] = discountId;
    /*data['saudaType'] = saudaType;*/
    data['incoTerms'] = incoTerms;
    data['IncotermsId'] = incotermsId;
    data['OilTypeId'] = oilTypeId;
data['IsMandatorySku'] = isMandatorySku;
    data['plantDepot'] = plantDepot;
    data['PlantId'] = plantId;
    data['PricingId'] = pricingId;
    data['QuotedPrice'] = quotedPrice;
    data['SaudaValidFromDate'] = saudaValidFromDate;
    data['SaudaValidToDate'] = saudaValidToDate;
    data['SkuId'] = skuId;
    data['skuName'] = skuName;
    data['StatusId'] = statusId;
    data['uomName'] = uomName;
    data['QPSDiscount'] = qpsDiscount;
    data['mtQtyVal'] = mtQtyVal;
    return data;
  }
}
