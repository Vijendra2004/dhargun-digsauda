class OilTypeSkuList {
  int? skuId;
  String? skuName;
  String? code;
  double? caseToMetricTonValue;
  double? unit;

  OilTypeSkuList(
      {this.skuId,
      this.skuName,
      this.code,
      this.caseToMetricTonValue,
      this.unit});

  OilTypeSkuList.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['code'] = code;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['unit'] = unit;
    return data;
  }
}
