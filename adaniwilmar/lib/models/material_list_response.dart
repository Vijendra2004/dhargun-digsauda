class MaterialList {
  int? id;
  String? name;
  String? code;
  String? mobileNumber;
  int? caseToMetricTonValue;
  int? serialNo;

  MaterialList(
      {this.id,
        this.name,
        this.code,
        this.mobileNumber,
        this.caseToMetricTonValue,
        this.serialNo});

  MaterialList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    mobileNumber = json['mobileNumber'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    serialNo = json['serialNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['mobileNumber'] = mobileNumber;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['serialNo'] = serialNo;
    return data;
  }
}