class SKUList1 {
  int? skuId;
  String? skuName;
  double? bidQuantity;
  double? bidQuantityCase;
  double? caseToMetricTonValue;
  double? maxAllowableCasesSingleSku;
  double? maxAllowableCasesMultipleSku;
  double? grossWeight;
  double? maximumVehicleCapacityInPercent;
  double? maximumVolumeCapacityInPercent;
  int? oilTypeId;
  String? skuCode;

  SKUList1(
      {this.skuId,
      this.skuName,
      this.bidQuantity,
      this.bidQuantityCase,
      this.caseToMetricTonValue,
      this.maxAllowableCasesSingleSku,
      this.maxAllowableCasesMultipleSku,
      this.grossWeight,
      this.maximumVehicleCapacityInPercent,
      this.maximumVolumeCapacityInPercent,
      this.oilTypeId,
      this.skuCode});

  SKUList1.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    bidQuantity = json['bidQuantity'];
    bidQuantityCase = json['bidQuantityCase'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    maxAllowableCasesSingleSku = json['maxAllowableCasesSingleSku'];
    maxAllowableCasesMultipleSku = json['maxAllowableCasesMultipleSku'];
    grossWeight = json['grossWeight'];
    maximumVehicleCapacityInPercent = json['maximumVehicleCapacityInPercent'];
    maximumVolumeCapacityInPercent = json['maximumVolumeCapacityInPercent'];
    oilTypeId = json['oilTypeId'];
    skuCode = json['skuCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['bidQuantity'] = bidQuantity;
    data['bidQuantityCase'] = bidQuantityCase;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['maxAllowableCasesSingleSku'] = maxAllowableCasesSingleSku;
    data['maxAllowableCasesMultipleSku'] = maxAllowableCasesMultipleSku;
    data['grossWeight'] = grossWeight;
    data['maximumVehicleCapacityInPercent'] = maximumVehicleCapacityInPercent;
    data['maximumVolumeCapacityInPercent'] = maximumVolumeCapacityInPercent;
    data['oilTypeId'] = oilTypeId;
    data['skuCode'] = skuCode;
    return data;
  }
}

class SKUList {
  int? id;
  String? saudaNumber;
  int? saudaOrderId;
  int? skuId;
  String? skuName;
  String? skuCode;
  int? skuUomId;
  String? skuUomName;
  double? availableQuantity;
  double? caseToMetricTonValue;
  double? maxAllowableCasesSingleSku;
  double? maxAllowableCasesMultipleSku;
  double? grossWeight;
  double? maximumVehicleCapacityInPercent;
  double? maximumVolumeCapacityInPercent;
  double? usedQuantity = 0;
  SKUList(
      {this.id,
      this.saudaNumber,
        this.saudaOrderId,
      this.skuId,
      this.skuName,
      this.skuCode,
      this.skuUomId,
      this.skuUomName,
      this.availableQuantity,
      this.caseToMetricTonValue,
      this.maxAllowableCasesSingleSku,
      this.maxAllowableCasesMultipleSku,
      this.grossWeight,
      this.maximumVehicleCapacityInPercent,
      this.maximumVolumeCapacityInPercent,
      this.usedQuantity});

  SKUList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saudaNumber = json['saudaNumber'];
    saudaOrderId = json['saudaOrderId'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    skuUomId = json['skuUomId'];
    skuUomName = json['skuUomName'];
    availableQuantity = json['availableQuantity'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    maxAllowableCasesSingleSku = json['maxAllowableCasesSingleSku'];
    maxAllowableCasesMultipleSku = json['maxAllowableCasesMultipleSku'];
    grossWeight = json['grossWeight'];
    maximumVehicleCapacityInPercent = json['maximumVehicleCapacityInPercent'];
    maximumVolumeCapacityInPercent = json['maximumVolumeCapacityInPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['saudaNumber'] = saudaNumber;
    data['saudaOrderId'] = saudaOrderId;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['skuCode'] = skuCode;
    data['skuUomId'] = skuUomId;
    data['skuUomName'] = skuUomName;
    data['availableQuantity'] = availableQuantity;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['maxAllowableCasesSingleSku'] = maxAllowableCasesSingleSku;
    data['maxAllowableCasesMultipleSku'] = maxAllowableCasesMultipleSku;
    data['grossWeight'] = grossWeight;
    data['maximumVehicleCapacityInPercent'] = maximumVehicleCapacityInPercent;
    data['maximumVolumeCapacityInPercent'] = maximumVolumeCapacityInPercent;
    return data;
  }
}
