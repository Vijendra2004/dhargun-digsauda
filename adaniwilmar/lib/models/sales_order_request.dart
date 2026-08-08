class SalesOrder {
  int? bDOId;
  String? customerRemarks;
  int? dealerId;
  String? liftingDate;
  List<LiftingRequestDetails>? liftingRequestDetails;
  int? loginUserId;
  int? plantId;
  int? shipToPartyId;
  int? statusId;
  int? vehicleSizeId;
  int? saudaOrderId;
  String? saudaNumber;

  SalesOrder(
      {this.bDOId,
      this.customerRemarks,
      this.dealerId,
      this.liftingDate,
      this.liftingRequestDetails,
      this.loginUserId,
      this.plantId,
      this.shipToPartyId,
      this.statusId,
      this.vehicleSizeId,
      this.saudaOrderId,
      this.saudaNumber});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    bDOId = json['BDOId'];
    customerRemarks = json['CustomerRemarks'];
    dealerId = json['DealerId'];
    liftingDate = json['LiftingDate'];
    if (json['LiftingRequestDetails'] != null) {
      liftingRequestDetails = <LiftingRequestDetails>[];
      json['LiftingRequestDetails'].forEach((v) {
        liftingRequestDetails!.add(LiftingRequestDetails.fromJson(v));
      });
    }
    loginUserId = json['LoginUserId'];
    plantId = json['PlantId'];
    shipToPartyId = json['ShipToPartyId'];
    statusId = json['StatusId'];
    vehicleSizeId = json['VehicleSizeId'];
    saudaOrderId = json['saudaOrderId'];
    saudaNumber = json['saudaNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BDOId'] = bDOId;
    data['CustomerRemarks'] = customerRemarks;
    data['DealerId'] = dealerId;
    data['LiftingDate'] = liftingDate;
    if (liftingRequestDetails != null) {
      data['LiftingRequestDetails'] =
          liftingRequestDetails!.map((v) => v.toJson()).toList();
    }
    data['LoginUserId'] = loginUserId;
    data['PlantId'] = plantId;
    data['ShipToPartyId'] = shipToPartyId;
    data['StatusId'] = statusId;
    data['VehicleSizeId'] = vehicleSizeId;
    data['saudaOrderId'] = saudaOrderId;
    data['saudaNumber'] = saudaNumber;
    return data;
  }
}

class LiftingRequestDetails {
  double? grossWeight;
  double? liftingQuantity;
  double? liftingQuantityForMultiVolume;
  double? liftingQuantityForSingleVolume;
  double? liftingQuantityInMT;
  double? netWeight;
  int? oilTypeId;
  String? skuCode;
  int? skuId;
  String? skuName;
  int? saudaOrderId;
  String? saudaNumber;

  LiftingRequestDetails(
      {this.grossWeight,
      this.liftingQuantity,
      this.liftingQuantityForMultiVolume,
      this.liftingQuantityForSingleVolume,
      this.liftingQuantityInMT,
      this.netWeight,
      this.oilTypeId,
      this.skuCode,
      this.skuId,
      this.skuName,
      this.saudaOrderId,
      this.saudaNumber});

  LiftingRequestDetails.fromJson(Map<String, dynamic> json) {
    grossWeight = json['grossWeight'];
    liftingQuantity = json['LiftingQuantity'];
    liftingQuantityForMultiVolume = json['LiftingQuantityForMultiVolume'];
    liftingQuantityForSingleVolume = json['LiftingQuantityForSingleVolume'];
    liftingQuantityInMT = json['LiftingQuantityInMT'];
    netWeight = json['NetWeight'];
    oilTypeId = json['OilTypeId'];
    skuCode = json['skuCode'];
    skuId = json['SkuId'];
    skuName = json['skuName'];
    saudaOrderId = json['saudaOrderId'];
    saudaNumber = json['saudaNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grossWeight'] = grossWeight;
    data['LiftingQuantity'] = liftingQuantity;
    data['LiftingQuantityForMultiVolume'] = liftingQuantityForMultiVolume;
    data['LiftingQuantityForSingleVolume'] = liftingQuantityForSingleVolume;
    data['LiftingQuantityInMT'] = liftingQuantityInMT;
    data['NetWeight'] = netWeight;
    data['OilTypeId'] = oilTypeId;
    data['skuCode'] = skuCode;
    data['SkuId'] = skuId;
    data['skuName'] = skuName;
    data['saudaOrderId'] = saudaOrderId;
    data['saudaNumber'] = saudaNumber;
    return data;
  }
}
