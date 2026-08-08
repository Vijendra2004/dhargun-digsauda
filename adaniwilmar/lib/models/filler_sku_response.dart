class FillerSKU {
  int? skuId;
  int? packTypeId;
  int? userId;
  double? bidedCases;
  String? skuCode;
  String? skuName;
  double? suggestedQuantity;
  double? maxAllowableSingleSku;
  double? maxAllowableMultipleSku;
  double? grossWeight;
  double? caseToMetricTon;
  String? dealerCode;
  String? dealerName;
  String? packType;
  int? oilTypeId;
  bool? isSelected = false;
  double? selectedQty = 0;
  FillerSKU(
      {this.skuId,
      this.packTypeId,
      this.userId,
      this.bidedCases,
      this.skuCode,
      this.skuName,
      this.suggestedQuantity,
      this.maxAllowableSingleSku,
      this.maxAllowableMultipleSku,
      this.grossWeight,
      this.caseToMetricTon,
      this.dealerCode,
      this.dealerName,
      this.packType,
      this.oilTypeId,
      this.isSelected = false,
      this.selectedQty = 0});

  FillerSKU.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    packTypeId = json['packTypeId'];
    userId = json['userId'];
    bidedCases = json['bidedCases'];
    skuCode = json['skuCode'];
    skuName = json['skuName'];
    suggestedQuantity = json['suggestedQuantity'];
    maxAllowableSingleSku = json['maxAllowableSingleSku'];
    maxAllowableMultipleSku = json['maxAllowableMultipleSku'];
    grossWeight = json['grossWeight'];
    caseToMetricTon = json['caseToMetricTon'];
    dealerCode = json['dealerCode'];
    dealerName = json['dealerName'];
    packType = json['packType'];
    oilTypeId = json['oilTypeId'];
    // isSelected=json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['packTypeId'] = packTypeId;
    data['userId'] = userId;
    data['bidedCases'] = bidedCases;
    data['skuCode'] = skuCode;
    data['skuName'] = skuName;
    data['suggestedQuantity'] = suggestedQuantity;
    data['maxAllowableSingleSku'] = maxAllowableSingleSku;
    data['maxAllowableMultipleSku'] = maxAllowableMultipleSku;
    data['grossWeight'] = grossWeight;
    data['caseToMetricTon'] = caseToMetricTon;
    data['dealerCode'] = dealerCode;
    data['dealerName'] = dealerName;
    data['packType'] = packType;
    data['oilTypeId'] = oilTypeId;
    data['isSelected'] = isSelected;
    return data;
  }
}
