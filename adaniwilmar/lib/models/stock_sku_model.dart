class StockSku {
  int? id;
  String? name;
  String? code;
  String? mobileNumber;
  double? caseToMetricTonValue;
  int? serialNo;
  int? oilTypeId;
  int? packGroupId;

  StockSku(
      {this.id,
      this.name,
      this.code,
      this.mobileNumber,
      this.caseToMetricTonValue,
      this.serialNo,
      this.oilTypeId,
      this.packGroupId});

  StockSku.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    mobileNumber = json['mobileNumber'];
    caseToMetricTonValue = json['caseToMetricTonValue']?.toDouble();
    serialNo = json['serialNo'];
    oilTypeId = json['oilTypeId'];
    packGroupId = json['packGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['mobileNumber'] = mobileNumber;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['serialNo'] = serialNo;
    data['oilTypeId'] = oilTypeId;
    data['packGroupId'] = packGroupId;
    return data;
  }
}
